import 'package:flutter/material.dart';

class DialogActionButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;

  const DialogActionButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
