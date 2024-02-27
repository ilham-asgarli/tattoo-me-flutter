import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../utils/logic/state/bloc/designer-status/designer_status_bloc.dart';
import '../../../widgets/auto_index.dart';

class AnimatedRetouching extends StatelessWidget {
  const AnimatedRetouching({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoIndex(
      working: context.watch<DesignerStatusBloc>().state is HasDesigner,
      itemCount: 6,
      child: (index) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(50),
              child: Image.asset(
                "ic_retouching".toPNG,
                height: context.height / 6,
              ),
            ),
            Positioned(
              left: 50,
              top: 75,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: index == 0
                    ? const FaIcon(
                        FontAwesomeIcons.crop,
                        size: 15,
                      )
                    : null,
              ),
            ),
            Positioned(
              top: 45,
              left: 90,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: index == 1
                    ? const FaIcon(
                        FontAwesomeIcons.fillDrip,
                        size: 15,
                      )
                    : null,
              ),
            ),
            Positioned(
              right: 90,
              top: 75,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: index == 2
                    ? const FaIcon(
                        FontAwesomeIcons.eye,
                        size: 15,
                      )
                    : null,
              ),
            ),
            Positioned(
              right: 20,
              top: 40,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: index == 3
                    ? const Icon(
                        Icons.brush,
                        size: 15,
                      )
                    : null,
              ),
            ),
            Positioned(
              top: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: index == 4
                    ? const FaIcon(
                        FontAwesomeIcons.squarePen,
                        size: 15,
                      )
                    : null,
              ),
            ),
            Positioned(
              right: 75,
              top: 45,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: index == 5
                    ? const FaIcon(
                        FontAwesomeIcons.locationPin,
                        size: 15,
                      )
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
