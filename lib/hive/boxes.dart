import 'package:hive/hive.dart';

class Boxes {
  //CATEGORIAS
  static final String boxNameCategories = 'ToDoCategories';
  static final Box categories = Hive.box(boxNameCategories);

  //TAREAS
  static final String boxNameTasks = 'ToDoTasks';
  static final Box tasks = Hive.box(boxNameTasks);
}
