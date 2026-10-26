import 'package:flutter/material.dart';
import 'package:todo/helpers/helper.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/pages/_pages.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/utils/utils.dart';

class TaskDetailPage extends StatelessWidget {
  static const String routeName = 'TaskDetailPage';
  const TaskDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of(context);
    final Task task = ModalRoute.of(context)!.settings.arguments as Task;
    TaskCategory category = taskProvider.categories.firstWhere((c) => c.id == task.idCategory);
    final double iconSize = 30;
    final TextStyle textStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
    return Scaffold(
      backgroundColor: AppTheme.primary,
      appBar: AppBar(
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('')),
        centerTitle: false,
        actions: [
          IconButton(
            tooltip: 'Editar',
            onPressed: () => Navigator.pushNamed(context, TaskEditPage.routeName, arguments: task),
            icon: Icon(Icons.edit),
          ),
          PopupMenuButton(
            tooltip: 'Más opciones',
            icon: Icon(Icons.more_vert),
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
            constraints: BoxConstraints(maxWidth: 50),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () async {
                    if (!task.deleted) {
                      Helper.switchRemoveTask(context, taskProvider, task);
                    } else {
                      final resp = await Helper.deleteTask(context, taskProvider, task);
                      if (resp && context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Icon(Icons.delete, color: AppTheme.primary),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 150,
            padding: const EdgeInsets.only(left: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: category.colorValue,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.border, width: 2),
                      ),
                    ),
                    Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            color: AppTheme.surface,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            CategoryDetailPage.routeName,
                            arguments: category,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppTheme.surface,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              spacing: 20,
                              children: [
                                Icon(category.icon),
                                Text(
                                  category.name,
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppTheme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          spacing: 20,
                          children: [
                            Icon(Icons.calendar_month, size: iconSize),
                            Text(Utils.dateEnglishToSpanish(task.date), style: textStyle),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          spacing: 20,
                          children: [
                            Icon(Icons.watch_later_outlined, size: iconSize),
                            Text(Utils.timeOfDayToString(task.time), style: textStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                  20.h,
                  Row(
                    spacing: 20,
                    children: [
                      Icon(task.priority.icon, color: task.priority.color, size: iconSize),
                      Text(task.priority.displayName, style: textStyle),
                    ],
                  ),
                  20.h,
                  if (task.description.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        Icon(Icons.description_outlined, size: iconSize),
                        Expanded(child: Text(task.description, style: textStyle)),
                      ],
                    ),
                  Expanded(child: 1.h),
                  if (!task.deleted)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () async => await Helper.finishTask(context, taskProvider, task),
                        child: Text(
                          'Marcar como ${task.status == TaskStatus.completed ? 'pendiente' : 'completada'}',
                        ),
                      ),
                    ),
                  if (task.deleted)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () async {
                          final resp = await Helper.switchRemoveTask(context, taskProvider, task);
                          if (resp && context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Restaurar'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
