import 'package:flutter/material.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/utils/enums.dart';

class TaskStatusWidget extends StatelessWidget {
  final TaskStatus status;
  final Function(TaskStatus)? onTap;
  const TaskStatusWidget({super.key, required this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of(context);
    final selected = taskProvider.taskStatus == status;
    return GestureDetector(
      onTap: () {
        taskProvider.taskStatus = status;
        onTap?.call(status);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppTheme.secondary : AppTheme.indicator,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            status.displayName,
            style: TextStyle(
              color: selected ? AppTheme.surface : AppTheme.onSurface,
              fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
