import 'package:flutter/material.dart';
import 'package:todo/helpers/helper.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/pages/_pages.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/utils/utils.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final TaskProvider taskProvider;
  const TaskWidget({super.key, required this.task, required this.taskProvider});

  @override
  Widget build(BuildContext context) {
    TaskCategory category = taskProvider.categories.firstWhere((c) => c.id == task.idCategory);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, TaskDetailPage.routeName, arguments: task),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              spacing: 15,
              children: [
                Container(width: 7, color: category.colorValue),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category.icon),
                    Icon(task.priority.icon, color: task.priority.color),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          decoration: task.status == TaskStatus.completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${Utils.actualDate(task.date)} - ${Utils.timeOfDayToString(task.time)}',
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
                  itemBuilder: (context) {
                    String pop = task.status == TaskStatus.completed ? 'Iniciar' : 'Completar';
                    return [
                      if (!task.deleted)
                        PopupMenuItem(
                          onTap: () async => await Helper.finishTask(context, taskProvider, task),
                          child: Text(pop),
                        ),
                      PopupMenuItem(
                        onTap: () {
                          Helper.switchRemoveTask(context, taskProvider, task);
                        },
                        child: Text(task.deleted ? 'Restaurar' : 'Borrar'),
                      ),
                    ];
                  },
                ),
                5.w,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
