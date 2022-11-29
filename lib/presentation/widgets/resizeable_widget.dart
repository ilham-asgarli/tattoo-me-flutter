import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tattoo/utils/logic/helpers/gallery/gallery_helper.dart';

class ResizeableWidget extends StatefulWidget {
  final double width;
  final double height;
  final Widget Function(double width, double height, double angle) builder;
  final Function(Offset offset) onDragEnd;
  final Function() onClose;
  final Future<File> Function() onCrop;
  final bool isEditable;
  final BuildContext positionedContext;

  const ResizeableWidget({
    super.key,
    required this.width,
    required this.height,
    required this.builder,
    required this.onDragEnd,
    required this.onClose,
    required this.onCrop,
    required this.positionedContext,
    this.isEditable = true,
  });

  @override
  State<ResizeableWidget> createState() => _ResizeableWidgetState();
}

const ballDiameter = 50.0;

enum BallLocation {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class _ResizeableWidgetState extends State<ResizeableWidget>
    with SingleTickerProviderStateMixin {
  late double height;
  late double width;
  double top = 0;
  double left = 0;
  late AnimationController animationController;
  bool isDragging = false;

  @override
  void initState() {
    height = widget.height;
    width = widget.width;
    animationController = AnimationController.unbounded(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (ctx, w) {
        return Transform.rotate(
          angle: animationController.value,
          child: SizedBox(
            width: width + ballDiameter, // width + ballDiameter
            height: height + ballDiameter, // height + ballDiameter
            child: Center(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: top + ballDiameter / 2,
                    left: left + ballDiameter / 2,
                    child: Container(
                      height: height,
                      width: width,
                      decoration: BoxDecoration(
                        border: isDragging
                            ? null
                            : Border.all(
                                width: 1,
                                color: HexColor("#4d4d4d"),
                              ),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Draggable(
                        maxSimultaneousDrags: 1,
                        feedback: buildChild(),
                        childWhenDragging: Opacity(
                          opacity: 0,
                          child: buildChild(angle: 0),
                        ),
                        onDragEnd: (DraggableDetails details) {
                          setState(() {
                            isDragging = false;
                          });

                          RenderBox renderBox = widget.positionedContext
                              .findRenderObject() as RenderBox;

                          widget.onDragEnd(
                            renderBox.globalToLocal(
                              details.offset -
                                  Offset(top + ballDiameter / 2,
                                      left + ballDiameter / 2),
                            ),
                          );
                        },
                        child: Transform.scale(
                          scale: 1,
                          child: buildChild(angle: 0),
                        ),
                      ),
                    ),
                  ),
                  // bottom right
                  Positioned(
                    top: top + height,
                    left: left + width,
                    child: ManipulatingBall(
                      onTap: () {},
                      ballLocation: BallLocation.bottomRight,
                      onDrag: (dx, dy, angle) {
                        var mid = dx + dy;
                        mid = mid > 0
                            ? sqrt(pow(dx, 2) + pow(dy, 2))
                            : -sqrt(pow(dx, 2) + pow(dy, 2));

                        double oldHeight = height;
                        double newHeight = height + mid > 1 ? height + mid : 1;
                        var ratio = newHeight / oldHeight;

                        if (newHeight != oldHeight) {
                          setState(() {
                            height = newHeight > 0 ? newHeight : 0;
                            width *= ratio;
                          });
                        }
                      },
                    ),
                  ),
                  // bottom left
                  Positioned(
                    top: top + height,
                    left: left,
                    child: ManipulatingBall(
                      onTap: () {},
                      ballLocation: BallLocation.bottomLeft,
                      onDrag: (dx, dy, direction) {
                        var mid = (dx * -1) + dy;

                        setState(() {
                          animationController.value = direction;
                        });
                      },
                    ),
                  ),
                  // top left
                  Positioned(
                    top: top,
                    left: left,
                    child: ManipulatingBall(
                      onTap: () async {
                        File file = await widget.onCrop();

                        var size = await GalleryHelper.instance
                            .computeSize(context, file);
                        setState(() {
                          width = size[0];
                          height = size[1];
                        });
                      },
                      ballLocation: BallLocation.topLeft,
                      color: Colors.white,
                      onDrag: (dx, dy, angle) {
                        var mid = (dx + dy);
                      },
                    ),
                  ),
                  // top right
                  Positioned(
                    top: top,
                    left: left + width,
                    child: ManipulatingBall(
                      onTap: widget.onClose,
                      ballLocation: BallLocation.topRight,
                      onDrag: (dx, dy, angle) {
                        var mid = dx + (dy * -1);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildChild({double? angle}) {
    return widget.builder(
      width,
      height,
      angle ?? animationController.value,
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  const ManipulatingBall({
    super.key,
    this.color = Colors.white,
    required this.ballLocation,
    required this.onDrag,
    required this.onTap,
  });

  final Function onTap;
  final Function(double dx, double dy, double direction) onDrag;
  final Color color;
  final BallLocation ballLocation;

  @override
  State<ManipulatingBall> createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  double finalDirection = 0;
  double sensitivity = 0.4;

  _handleStart(DragStartDetails details, Offset touchPositionFromCenter) {}

  _handleUpdate(DragUpdateDetails details, Offset touchPositionFromCenter) {
    double computedDegree = computeDegree(details);
    double computedRadian = degreeToRadians(computedDegree);
    finalDirection = finalDirection + computedRadian * sensitivity;

    widget.onDrag(details.delta.dx, details.delta.dy, finalDirection);
  }

  double degreeToRadians(double degrees) => degrees * (pi / 180);

  double radianToDegrees(double radians) => radians * (180 / pi);

  double computeDegree(DragUpdateDetails details) {
    /// Pan location on the wheel
    bool onTop = details.localPosition.dy <= ballDiameter / 2;
    bool onLeftSide = details.localPosition.dx <= ballDiameter / 2;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Pan movements
    bool panUp = details.delta.dy <= 0.0;
    bool panLeft = details.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Absolute change on axis
    double yChange = details.delta.dy.abs();
    double xChange = details.delta.dx.abs();

    /// Directional change on wheel
    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    /// Total computed change
    double rotationalChange = verticalRotation + horizontalRotation;

    return rotationalChange;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Offset centerOfGestureDetector =
            Offset(constraints.minWidth / 2, constraints.minHeight / 2);

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (DragStartDetails details) {
            final touchPositionFromCenter =
                details.localPosition - centerOfGestureDetector;

            _handleStart(details, touchPositionFromCenter);
          },
          onPanUpdate: (DragUpdateDetails details) {
            final touchPositionFromCenter =
                details.localPosition - centerOfGestureDetector;

            _handleUpdate(details, touchPositionFromCenter);
          },
          onTap: () {
            widget.onTap();
          },
          onLongPress: () {
            widget.onTap();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            width: ballDiameter,
            height: ballDiameter,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
              child: Transform.rotate(
                angle: widget.ballLocation == BallLocation.bottomLeft
                    ? -pi
                    : widget.ballLocation == BallLocation.topRight
                        ? 0
                        : -pi / 2,
                child: FaIcon(
                  widget.ballLocation == BallLocation.bottomLeft
                      ? FontAwesomeIcons.rotateLeft
                      : widget.ballLocation == BallLocation.topRight
                          ? FontAwesomeIcons.xmark
                          : widget.ballLocation == BallLocation.topLeft
                              ? FontAwesomeIcons.crop
                              : FontAwesomeIcons.upRightAndDownLeftFromCenter,
                  color: HexColor("#4d4d4d"),
                  size: 15,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
