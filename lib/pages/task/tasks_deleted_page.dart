import 'package:flutter/material.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/widgets/_widgets.dart';

class TasksDeletedPage extends StatelessWidget {
  static const String routeName = 'TasksDeletedPage';
  const TasksDeletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    List<String> idsCategories = taskProvider.tasks
        .where((t) => t.deleted)
        .map((d) => d.idCategory)
        .toSet()
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text('Tareas eliminadas'),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: idsCategories.isNotEmpty
            ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: idsCategories.length,
                separatorBuilder: (BuildContext context, int index) => 30.h,
                itemBuilder: (BuildContext context, int index) {
                  TaskCategory category = taskProvider.categories.firstWhere(
                    (c) => c.id == idsCategories[index],
                  );
                  List<Task> deletedTasks = taskProvider.tasks
                      .where((t) => t.deleted && t.idCategory == idsCategories[index])
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: deletedTasks.length,
                        separatorBuilder: (BuildContext context, int index) => 10.h,
                        itemBuilder: (BuildContext context, int index) {
                          final Task task = deletedTasks[index];
                          return TaskWidget(task: task, taskProvider: taskProvider);
                        },
                      ),
                    ],
                  );
                },
              )
            : Center(child: Text('No hay tareas eliminadas', style: TextStyle(fontSize: 21))),
      ),
    );
  }
}
