import 'package:flutter/material.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/presentation/widgets/picker_outlined_button.dart';

class ColorPickerButton extends StatelessWidget {
  const ColorPickerButton({
    Key? key,
    required this.onPressed,
    required this.color,
  }) : super(key: key);
  final Function() onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return PickerOutlinedButton(
      onPressed: onPressed,
      shape: CircleBorder(),
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.7, color: color)),
        child: Icon(
          Icons.circle,
          size: 18,
          color: color,
        ),
      ),
    );
  }
}
