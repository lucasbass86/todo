import 'package:flutter/material.dart';
import 'package:todo/themes/themes.dart';

enum TaskStatus { all, pending, completed }

extension ExTaskStatus on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pendientes';
      case TaskStatus.completed:
        return 'Completadas';
      case TaskStatus.all:
        return 'Todas';
    }
  }

  int get order {
    switch (this) {
      case TaskStatus.all:
        return 2;
      case TaskStatus.pending:
        return 0;
      case TaskStatus.completed:
        return 1;
    }
  }
}

enum TaskPriority { all, low, medium, high }

extension ExTaskPriority on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.all:
        return 'Todas';
      case TaskPriority.low:
        return 'Baja';
      case TaskPriority.medium:
        return 'Media';
      case TaskPriority.high:
        return 'Alta';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.all:
        return AppTheme.primary;
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.amber;
      case TaskPriority.high:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.all:
      case TaskPriority.low:
      case TaskPriority.medium:
        return Icons.circle;
      case TaskPriority.high:
        return Icons.hexagon;
    }
  }
}

enum StatisticsType { week, month, year }

extension ExStatisticsType on StatisticsType {
  String get displayName {
    switch (this) {
      case StatisticsType.week:
        return 'Semana';
      case StatisticsType.month:
        return 'Mes';
      case StatisticsType.year:
        return 'Año';
    }
  }
}
