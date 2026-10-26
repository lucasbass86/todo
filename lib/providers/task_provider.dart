export 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:todo/hive/boxes.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/preferences/preferences.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/utils.dart';

class TaskProvider with ChangeNotifier {
  TaskStatus _taskStatus = TaskStatus.pending;
  TaskStatus get taskStatus => _taskStatus;
  set taskStatus(TaskStatus value) {
    _taskStatus = value;
    notifyListeners();
  }

  StatisticsType _statisticsType = StatisticsType.week;
  StatisticsType get statisticsType => _statisticsType;
  set statisticsType(StatisticsType value) {
    _statisticsType = value;
    notifyListeners();
  }

  bool get groupTasks => Preferences.groupTasks;
  set groupTasks(bool value) {
    Preferences.groupTasks = value;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  TaskProvider() {
    // Boxes.categories.deleteAll(Boxes.categories.keys);
    // Boxes.tasks.deleteAll(Boxes.tasks.keys);

    loadCategories();
    loadTask();
  }

  ///
  ///CAREGORIES
  ///

  List<TaskCategory> categories = [];
  void loadCategories() {
    categories = Boxes.categories.keys.map((key) {
      final value = Boxes.categories.get(key);
      return TaskCategory.fromJson(Map<String, dynamic>.from(value));
    }).toList();
    notifyListeners();
  }

  bool addCategory(TaskCategory category) {
    try {
      if (!categories.any((t) => t.id == category.id)) categories.add(category);
      categories[categories.indexOf(category)] = category;
      Boxes.categories.put(category.id, category.toJson());
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool deleteCategory(TaskCategory category) {
    try {
      categories.remove(category);
      Boxes.categories.delete(category.id);
      //BORRAR TODAS LAS TAREAS DE ESTA CATEGORIA:
      List<Task> tasksOfCategory = tasks.where((t) => t.idCategory == category.id).toList();
      for (Task t in tasksOfCategory) {
        deleteTask(t, notify: false);
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  ///
  ///TASK
  ///
  List<Task> tasks = [];

  void loadTask() {
    tasks = Boxes.tasks.keys.map((key) {
      final value = Boxes.tasks.get(key);
      return Task.fromJson(Map<String, dynamic>.from(value));
    }).toList();
    notifyListeners();
  }

  bool addTask(Task task) {
    try {
      if (!tasks.any((t) => t.id == task.id)) tasks.add(task);
      Boxes.tasks.put(task.id, task.toJson());
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool switchFinishTask(Task task) {
    try {
      if (!tasks.any((t) => t.id == task.id)) tasks.add(task);
      tasks[tasks.indexOf(task)] = task;
      Boxes.tasks.put(task.id, task.toJson());
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool switchRemoveTask(Task task) {
    try {
      task.deleted = !task.deleted;
      Boxes.tasks.put(task.id, task.toJson());
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool deleteTask(Task task, {bool notify = true}) {
    try {
      tasks.remove(task);
      Boxes.tasks.delete(task.id);
      if (notify) notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  //STATISTICS
  List<Task> getFilter({TaskStatus? status}) {
    switch (statisticsType) {
      case StatisticsType.week:
        return tasks
            .where(
              (t) => Utils.isInSameWeek(t.date) && (status != null ? t.status == status : true),
            )
            .toList();
      case StatisticsType.month:
        return tasks
            .where(
              (t) => Utils.isInSameMonth(t.date) && (status != null ? t.status == status : true),
            )
            .toList();
      case StatisticsType.year:
        return tasks
            .where(
              (t) => Utils.isInSameYear(t.date) && (status != null ? t.status == status : true),
            )
            .toList();
    }
  }
}
