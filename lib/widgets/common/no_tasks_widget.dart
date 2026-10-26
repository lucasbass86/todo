import 'package:flutter/material.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/extensions.dart';

class NoTasksWidget extends StatelessWidget {
  final TaskStatus status;
  const NoTasksWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String title = '';
    switch (status) {
      case TaskStatus.all:
        title = '';
        break;
      case TaskStatus.pending:
        title = ' pendientes';
        break;
      case TaskStatus.completed:
        title = ' completadas';
        break;
    }
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withAlpha(100),
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Center(child: Icon(Icons.task_rounded)),
              ),
            ),
            20.h,
            Text(
              'No hay tareas$title',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
            Text('¡Crea una tarea y empieza a organizar tu día!'),
            20.h,
          ],
        ),
      ),
    );
  }
}
