import 'package:flutter/material.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/widgets/_widgets.dart';

class TasksListWidget extends StatelessWidget {
  final TaskProvider taskProvider;
  final List<Task> tasks;
  final bool expanded;
  final bool isFromCategory;
  final TaskStatus? status;
  const TasksListWidget({
    super.key,
    required this.taskProvider,
    required this.tasks,
    this.expanded = true,
    this.isFromCategory = false,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return expanded
        ? Expanded(
            child: tasks.isEmpty
                ? _noTasks()
                : taskProvider.groupTasks && !isFromCategory
                ? _groupedItems()
                : _items(tasks),
          )
        : tasks.isEmpty
        ? _noTasks()
        : taskProvider.groupTasks && !isFromCategory
        ? _groupedItems()
        : _items(tasks);
  }

  Widget _items(List<Task> tasks) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: tasks.length,
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) =>
          TaskWidget(task: tasks[index], taskProvider: taskProvider),
    );
  }

  Widget _groupedItems() {
    List<String> ids = tasks.map((e) => e.idCategory).toSet().toList();
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: ids.length,
      separatorBuilder: (BuildContext context, int index) => 10.h,
      itemBuilder: (BuildContext context, int index) {
        final TaskCategory category = taskProvider.categories.firstWhere((c) => c.id == ids[index]);
        final List<Task> tasksOfCategory = tasks.where((t) => t.idCategory == category.id).toList();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category.name, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)),
              10.h,
              _items(tasksOfCategory),
            ],
          ),
        );
      },
    );
  }

  NoTasksWidget _noTasks() => NoTasksWidget(status: status ?? taskProvider.taskStatus);
}
