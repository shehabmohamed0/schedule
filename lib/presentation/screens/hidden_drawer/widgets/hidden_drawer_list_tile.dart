import 'package:flutter/material.dart';
import 'package:schedule/core/constants/constants.dart';

class HiddenDrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function()? onTap;
  HiddenDrawerListTile(
      {Key? key, required this.icon, required this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight / 14,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          icon,
          color: KIconColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
