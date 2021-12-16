part of 'task_date_time_picker.dart';

class TaskDialogListTile extends StatelessWidget {
  const TaskDialogListTile({
    Key? key,
    required this.leadingIcon,
    required this.title,
    required this.trailingText,
  }) : super(key: key);

  final IconData leadingIcon;
  final String title;
  final String trailingText;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: () {},
      leading: Icon(
        leadingIcon,
        size: 20,
        color: Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      trailing: Text(
        trailingText,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
