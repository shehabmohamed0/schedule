import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        FaIcon(
          FontAwesomeIcons.solidCalendar,
          color: Colors.blueAccent.withOpacity(.5),
          size: 28,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 2.5),
          child: Text(
            '18',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
