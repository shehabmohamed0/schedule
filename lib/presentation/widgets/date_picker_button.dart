import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/presentation/widgets/picker_outlined_button.dart';

class DatePickerButton extends StatelessWidget {
  final void Function() onPressed;
  final String dateTimeString;

  const DatePickerButton(
      {Key? key, required this.onPressed, required this.dateTimeString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PickerOutlinedButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(
            FontAwesomeIcons.calendar,
            size: 24,
            color: KIconColor,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            dateTimeString,
            style: const TextStyle(
                color: KIconColor, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
