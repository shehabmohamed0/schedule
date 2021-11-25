import 'package:flutter/material.dart';
import 'package:schedule/core/constants/constants.dart';

class PickerOutlinedButton extends StatelessWidget {
  const PickerOutlinedButton(
      {Key? key, required this.onPressed, required this.child,required this.shape})
      : super(key: key);
  final Function() onPressed;
  final Widget child;
  final OutlinedBorder shape;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape:shape
              ,
          side: BorderSide(color: KIconColor.withOpacity(0.3), width: 2)),
      onPressed: onPressed,
      child: child,
    );
  }
}
