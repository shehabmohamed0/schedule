import 'package:flutter/material.dart';

final categoriesTable = 'categories';

class CategoryFields {
  static const List<String> values = [
    /// Add all fields
    id, name, color
  ];
  static const String id = '_categoryId';
  static const String name = 'categoryName';
  static const String color = 'categoryColor';
}

class Category {
  final int? categoryID;
  final String categoryName;
  final Color categoryColor;

  Category(
      {this.categoryID,
      required this.categoryName,
      required this.categoryColor});

  Category copyWith({
    int? categoryId,
    String? categoryName,
    Color? categoryColor,
  }) =>
      Category(
          categoryID: categoryID ?? this.categoryID,
          categoryName: categoryName ?? this.categoryName,
          categoryColor: categoryColor ?? this.categoryColor);

  Map<String, dynamic> toJson() => {
        CategoryFields.id: categoryID,
        CategoryFields.name: categoryName,
        CategoryFields.color: categoryColor.value,
      };

  static Category fromJson(Map<String, Object?> json) {
    return Category(
      categoryID: json[CategoryFields.id] as int?,
      categoryName: json[CategoryFields.name] as String,
      categoryColor: Color(json[CategoryFields.color] as int),
    );
  }
}
