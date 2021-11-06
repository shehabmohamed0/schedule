part of '../category_screen.dart';

class TaskNumberCard extends StatelessWidget {
  const TaskNumberCard(
      {Key? key,
      required this.number,
      required this.text,
      required this.color,
      required this.borderRadius})
      : super(key: key);
  final int number;
  final String text;
  final BorderRadius borderRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 120,
        width: 100,
        decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: KIconColor.withOpacity(0.1),
            )
          ],
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$number',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
