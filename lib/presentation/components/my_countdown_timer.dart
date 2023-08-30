import 'dart:async';

import 'package:flutter/material.dart';

class MyCountDownTimer extends StatefulWidget {
  final int endTime;
  final Widget Function(Duration? time)? widgetBuilder;
  final Function()? onEnd;

  const MyCountDownTimer({
    super.key,
    required this.endTime,
    this.widgetBuilder,
    this.onEnd,
  });

  @override
  State<MyCountDownTimer> createState() => _MyCountDownTimerState();
}

class _MyCountDownTimerState extends State<MyCountDownTimer> {
  late Timer _timer;
  late int endTime;

  @override
  void initState() {
    const oneSec = Duration(seconds: 1);
    endTime = (widget.endTime / 60).toInt();

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (endTime == 0) {
          setState(() {
            timer.cancel();
            widget.onEnd?.call();
          });
        } else {
          setState(() {
            endTime--;
          });
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.widgetBuilder == null
        ? Text(endTime.toString())
        : widget.widgetBuilder!(Duration(seconds: endTime));
  }
}
