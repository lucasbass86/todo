import 'package:flutter/material.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/utils/enums.dart';

class StatisticsWidget extends StatelessWidget {
  final StatisticsType type;
  final Function(StatisticsType)? onTap;
  const StatisticsWidget({super.key, required this.type, this.onTap});

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of(context);
    final selected = taskProvider.statisticsType == type;
    return GestureDetector(
      onTap: () {
        taskProvider.statisticsType = type;
        onTap?.call(type);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppTheme.secondary : AppTheme.indicator,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            type.displayName,
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
