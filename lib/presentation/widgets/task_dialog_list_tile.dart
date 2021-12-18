part of 'task_date_time_picker.dart';

class TaskDialogListTile extends StatelessWidget {
  const TaskDialogListTile(
      {Key? key,
      required this.leadingIcon,
      required this.title,
      required this.trailingText,
      required this.onTap})
      : super(key: key);

  final IconData leadingIcon;
  final String title;
  final String trailingText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onTap,
      leading: Icon(
        leadingIcon,
        size: 20,
        color: Colors.grey,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      trailing: Text(
        trailingText,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}
