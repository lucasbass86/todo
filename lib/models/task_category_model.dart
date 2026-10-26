import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todo/utils/utils.dart';

class TaskCategory {
  final String id;
  String name;
  Color colorValue;
  IconData icon;

  @override
  String toString() => name;

  TaskCategory({required this.name, required this.colorValue, required this.icon})
    : id = Utils.uuid();

  TaskCategory copyWith({String? name, Color? colorValue, IconData? icon}) {
    return TaskCategory(
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      icon: icon ?? this.icon,
    );
  }

  TaskCategory.withId({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.icon,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'colorIndex': Utils.categoryColors.indexOf(colorValue),
    'iconIndex': Utils.categoryIcons.indexOf(icon),
  };

  factory TaskCategory.fromJson(Map<String, dynamic> json) {
    final colorIndex = json['colorIndex'] as int;
    final iconIndex = json['iconIndex'] as int;
    return TaskCategory.withId(
      id: json['id'] as String,
      name: json['name'] as String,
      colorValue: Utils.categoryColors[colorIndex],
      icon: Utils.categoryIcons[iconIndex],
    );
  }
}
