import 'package:flutter/material.dart';
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
          color: priority.color.withAlpha(25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? priority.color : Colors.transparent, width: 2),
        ),
        child: Center(
          child: Row(
            spacing: 10,
            children: [
              Icon(priority.icon, color: priority.color),
              Text(
                priority.displayName,
                style: TextStyle(color: priority.color, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
