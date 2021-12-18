import 'package:flutter/material.dart';
import 'package:schedule/core/constants/constants.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(18),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            side: BorderSide(color: KIconColor.withOpacity(0.3), width: 2)),
        child: const Icon(
          Icons.close,
          size: 24,
          color: KIconColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        });
  }
}
