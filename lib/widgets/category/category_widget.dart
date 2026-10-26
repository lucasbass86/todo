import 'package:flutter/material.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/pages/_pages.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/extensions.dart';

class CategoryWidget extends StatelessWidget {
  final TaskCategory category;
  const CategoryWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);
    int completed = taskProvider.tasks
        .where((t) => t.idCategory == category.id && t.status == TaskStatus.completed)
        .length;
    int pending = taskProvider.tasks
        .where((t) => t.idCategory == category.id && t.status == TaskStatus.pending)
        .length;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, CategoryDetailPage.routeName, arguments: category),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          spacing: 15,
          children: [
            CircleAvatar(backgroundColor: category.colorValue, child: Icon(category.icon)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.name, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
                  5.h,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [Text('$completed completadas'), Text('$pending pendientes')],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
