import 'package:flutter/material.dart';
import 'package:schedule/data/models/category.dart';

class CategoryPickerListTile extends StatelessWidget {
  const CategoryPickerListTile(
      {Key? key, required this.category, required this.onTap})
      : super(key: key);
  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color: category.categoryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: category.categoryColor,
                blurRadius: 2,
                offset: Offset(1, 1),
              ),
            ]),
      ),
      title: Text(
        category.categoryName,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
