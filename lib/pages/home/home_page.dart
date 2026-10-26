import 'package:flutter/material.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/widgets/_widgets.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'HomePage';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    List<Task> tasks = taskProvider.tasks
        .where(
          (t) =>
              !t.deleted &&
              (taskProvider.taskStatus == TaskStatus.all
                  ? true
                  : t.status == taskProvider.taskStatus),
        )
        .toList();
    return Scaffold(
      body: Column(
        children: [
          StatusWidget(),
          TasksListWidget(tasks: tasks, taskProvider: taskProvider),
        ],
      ),
    );
  }
}
