import 'package:flutter/material.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/utils/utils.dart';
import 'package:todo/widgets/_widgets.dart';

class TaskNewPage extends StatefulWidget {
  static const String routeName = 'TaskNewPage';
  const TaskNewPage({super.key});

  @override
  State<TaskNewPage> createState() => _TaskNewPageState();
}

class _TaskNewPageState extends State<TaskNewPage> {
  late TaskProvider taskProvider;
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TaskPriority priority = TaskPriority.medium;
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  TaskCategory? category;
  bool isNew = true;
  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of<TaskProvider>(context, listen: false);
    var arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is TaskCategory && isNew) {
      category = arguments;
      isNew = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Nueva tarea')),
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
                          initialDate: date,
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
                    if (taskProvider.addTask(
                      Task(
                        title: name.text,
                        description: description.text,
                        idCategory: category!.id,
                        date: date,
                        time: time,
                        priority: priority,
                      ),
                    )) {
                      Utils.showSnackBar(context, 'Tarea guardada');
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
