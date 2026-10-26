import 'package:flutter/material.dart';
import 'package:todo/dialogs/dialogs.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/pages/_pages.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/utils/utils.dart';
import 'package:todo/widgets/_widgets.dart';

class CategoryDetailPage extends StatelessWidget {
  static const String routeName = 'CategoryDetailPage';
  const CategoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskProvider taskProvider = Provider.of(context);
    final TaskCategory category = ModalRoute.of(context)!.settings.arguments as TaskCategory;
    List<Task> tasks = taskProvider.tasks
        .where(
          (t) =>
              !t.deleted &&
              (taskProvider.taskStatus == TaskStatus.all
                  ? true
                  : t.status == taskProvider.taskStatus) &&
              (t.idCategory == category.id),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text(category.name)),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, CategoryNewPage.routeName, arguments: category),
            icon: Icon(Icons.edit),
          ),
          PopupMenuButton(
            tooltip: 'Más opciones',
            icon: Icon(Icons.more_vert),
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
            constraints: BoxConstraints(maxWidth: 50),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () async {
                  List<Task> allTasks = taskProvider.tasks
                      .where((t) => t.idCategory == category.id)
                      .toList();
                  String title = allTasks.isEmpty
                      ? ''
                      : allTasks.length == 1
                      ? ' con 1 tarea'
                      : ' con ${allTasks.length} tareas';
                  final resp = await showMessage(
                    context: context,
                    title: '¿Borrar la categoría$title?',
                    subtitle: 'Esta acción no se puede deshacer.',
                    aceptText: 'Sí',
                    cancelText: 'No',
                    aceptColor: Colors.red[300],
                    header: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red[300]),
                          child: Icon(Icons.delete, size: 40, color: Colors.white),
                        ),
                        20.h,
                      ],
                    ),
                  );
                  if (resp != null && resp && context.mounted) {
                    if (taskProvider.deleteCategory(category)) {
                      Utils.snackBar(context, 'Categoría borrada');
                      Navigator.pop(context);
                    } else {
                      Utils.snackBar(context, 'Algo ha fallado . . .', isBad: false);
                    }
                  }
                },
                child: Icon(Icons.delete, color: AppTheme.primary),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: StadiumBorder(),
        onPressed: () => Navigator.pushNamed(context, TaskNewPage.routeName, arguments: category),
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          StatusWidget(),
          TasksListWidget(tasks: tasks, taskProvider: taskProvider, isFromCategory: true),
        ],
      ),
    );
  }
}
