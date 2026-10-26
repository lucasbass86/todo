import 'package:flutter/material.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/utils/utils.dart';
import 'package:todo/widgets/_widgets.dart';

class TaskEditPage extends StatefulWidget {
  static const String routeName = 'TaskEditPage';
  const TaskEditPage({super.key});

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  late TaskProvider taskProvider;
  late TextEditingController name;
  late TextEditingController description;
  TaskPriority priority = TaskPriority.medium;
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  TaskCategory? category;
  late Task task;
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of<TaskProvider>(context, listen: false);
    task = ModalRoute.of(context)!.settings.arguments as Task;
    if (isLoading) {
      name = TextEditingController(text: task.title);
      description = TextEditingController(text: task.description);
      priority = task.priority;
      date = task.date;
      time = task.time;
      category = taskProvider.categories.firstWhere((c) => c.id == task.idCategory);
      isLoading = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Editar tarea')),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Título', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              10.h,
              TextField(
                controller: name,
                maxLength: 50,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hint: Text('Introduce el título de la tarea'),
                  counterText: '',
                ),
              ),
              20.h,
              Text('Descripción', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              10.h,
              TextField(
                controller: description,
                maxLength: 200,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hint: Text('Añade más detalles . . .'),
                  counterText: '',
                ),
              ),
              20.h,
              Text('Fecha y hora', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              10.h,
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        final newDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1986),
                          lastDate: DateTime(2099),
                          currentDate: date,
                        );
                        if (newDate != null) {
                          setState(() => date = newDate);
                        }
                      },
                      child: BasicContainer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(Icons.calendar_month),
                            Text(Utils.dateEnglishToSpanish(date)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        final timeOfDay = await showTimePicker(
                          helpText: 'Indica la hora',
                          cancelText: 'Cancelar',
                          confirmText: 'Aceptar',
                          context: context,
                          initialTime: time,
                          initialEntryMode: TimePickerEntryMode.dialOnly,
                        );
                        if (timeOfDay != null) {
                          setState(() => time = timeOfDay);
                        }
                      },
                      child: BasicContainer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(Icons.watch_later_outlined),
                            Text(Utils.timeOfDayToString(time)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              20.h,
              Text('Prioridad', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              10.h,
              SizedBox(
                height: 50,
                child: Center(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: TaskPriority.values
                        .skipWhile((value) => value == TaskPriority.all)
                        .length,
                    itemBuilder: (BuildContext context, int index) {
                      return PriorityWidget(
                        priority: TaskPriority.values
                            .skipWhile((value) => value == TaskPriority.all)
                            .toList()[index],
                        selected:
                            priority ==
                            TaskPriority.values
                                .skipWhile((value) => value == TaskPriority.all)
                                .toList()[index],
                        onTap: (value) => setState(() => priority = value),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(width: 20),
                  ),
                ),
              ),
              20.h,
              Text('Categoría', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              10.h,
              BasicContainer(
                child: DropdownButton(
                  value: category,
                  borderRadius: BorderRadius.circular(10),
                  isExpanded: true,
                  underline: Container(),
                  items: taskProvider.categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat,
                          child: Row(
                            spacing: 10,
                            children: [
                              Icon(cat.icon),
                              Text(cat.name, style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => category = value!),
                ),
              ),
              10.h,
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (name.text.isEmpty) {
                      Utils.showSnackBar(context, 'Hay que indicar el título', isBad: true);
                      return;
                    }
                    if (category == null) {
                      Utils.showSnackBar(context, 'Indica la categoría', isBad: true);
                      return;
                    }
                    task.title = name.text;
                    task.description = description.text;
                    task.idCategory = category!.id;
                    task.date = date;
                    task.time = time;
                    task.priority = priority;
                    if (taskProvider.addTask(task)) {
                      Utils.showSnackBar(context, 'Tarea modificada');
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
