import 'package:flutter/material.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/utils/enums.dart';

class PriorityWidget extends StatelessWidget {
  final TaskPriority priority;
  final bool selected;
  final Function(TaskPriority)? onTap;
  const PriorityWidget({super.key, required this.priority, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(priority),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _getColor().withAlpha(25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? _getColor() : Colors.transparent, width: 2),
        ),
        child: Center(
          child: Row(
            spacing: 10,
            children: [
              Icon(_getIcon(), color: _getColor()),
              Text(
                priority.displayName,
                style: TextStyle(color: _getColor(), fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.amber;
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.all:
        return AppTheme.primary;
    }
  }

  IconData _getIcon() {
    switch (priority) {
      case TaskPriority.all:
      case TaskPriority.low:
      case TaskPriority.medium:
        return selected ? Icons.circle : Icons.circle_outlined;
      case TaskPriority.high:
        return selected ? Icons.hexagon : Icons.hexagon_outlined;
    }
  }
}
