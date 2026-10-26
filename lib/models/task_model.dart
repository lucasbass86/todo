import 'package:flutter/material.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/utils.dart';

class Task {
  String id;
  String title;
  String description;

  DateTime date;
  TimeOfDay time;

  TaskPriority priority;
  TaskStatus status;
  String idCategory;
  bool deleted;

  @override
  String toString() => title;

  Task({
    required this.title,
    this.description = '',
    required this.date,
    required this.time,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    required this.idCategory,
    this.deleted = false,
  }) : id = Utils.uuid();

  Task.withId({
    required this.id,
    required this.title,
    this.description = '',
    required this.date,
    required this.time,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    required this.idCategory,
    this.deleted = false,
  });

  bool get isCompleted => status == TaskStatus.completed;

  Task copyWith({
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? time,
    TaskPriority? priority,
    TaskStatus? status,
    String? idCategory,
    bool? deleted,
  }) {
    return Task.withId(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      idCategory: idCategory ?? this.idCategory,
      deleted: deleted ?? this.deleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
    'hour': time.hour,
    'minute': time.minute,
    'priority': priority.name,
    'status': status.name,
    'idCategory': idCategory,
    'deleted': deleted,
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task.withId(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TaskStatus.pending,
      ),
      idCategory: json['idCategory'],
      deleted: json.containsKey('deleted') ? json['deleted'] as bool : false,
    );
  }
}
