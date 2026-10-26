import 'package:flutter/material.dart';
import 'package:todo/dialogs/dialogs.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/pages/_pages.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/utils/utils.dart';

class Helper {
  static Future<bool> switchRemoveTask(
    BuildContext context,
    TaskProvider taskProvider,
    Task task,
  ) async {
    bool result = false;
    String title = task.deleted ? 'Restaurar' : 'Eliminar';
    final resp = await showMessage(
      context: context,
      title: '¿$title tarea?',
      subtitle: 'Esta acción se puede deshacer.',
      aceptText: 'Sí',
      cancelText: 'No',
      aceptColor: !task.deleted ? Colors.red[300] : null,
      header: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: !task.deleted ? Colors.red[300] : AppTheme.primary,
            ),
            child: Icon(
              !task.deleted ? Icons.delete : Icons.restart_alt_outlined,
              size: 40,
              color: Colors.white,
            ),
          ),
          20.h,
        ],
      ),
    );
    if (resp != null) {
      if (taskProvider.switchRemoveTask(task) && context.mounted) {
        Utils.snackBar(context, task.deleted ? 'Tarea restaurada' : 'Tarea eliminada');
        result = true;
      } else {
        if (context.mounted) {
          Utils.snackBar(context, 'Algo ha fallado...', isBad: true);
          result = false;
        }
      }
    }
    return result;
  }

  static Future<bool> deleteTask(BuildContext context, TaskProvider taskProvider, Task task) async {
    bool result = false;
    final resp = await showMessage(
      context: context,
      title: '¿Eliminar la tarea definitivamente?',
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
    if (resp != null) {
      if (taskProvider.deleteTask(task) && context.mounted) {
        Utils.snackBar(context, 'Tarea eliminada definitivamente');
        result = true;
      } else {
        if (context.mounted) {
          Utils.snackBar(context, 'Algo ha fallado...', isBad: true);
          result = false;
        }
      }
    }
    return result;
  }

  static Future<bool> finishTask(BuildContext context, TaskProvider taskProvider, Task task) async {
    bool result = false;
    String title = task.status == TaskStatus.completed ? '¿Iniciar tarea?' : '¿Completar tarea?';
    final resp = await showMessage(
      context: context,
      title: title,
      aceptText: 'Sí',
      cancelText: 'No',
      header: Column(children: [Icon(Icons.check_rounded, size: 50), 20.h]),
    );
    if (resp != null) {
      task.status = task.status == TaskStatus.completed ? TaskStatus.pending : TaskStatus.completed;
      if (taskProvider.switchFinishTask(task) && context.mounted) {
        if (task.status == TaskStatus.pending) {
          Utils.snackBar(context, 'Tarea actualizada');
        } else {
          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TaskCompletedPage(
                  // onTap: () {
                  //   Navigator.of(context).pop();
                  // },
                ),
              ),
            );
          }
        }
      } else {
        if (context.mounted) {
          Utils.snackBar(context, 'Algo ha fallado...', isBad: true);
        }
      }
    }
    return result;
  }
}
