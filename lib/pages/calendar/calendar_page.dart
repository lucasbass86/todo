import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/utils/utils.dart';
import 'package:todo/widgets/_widgets.dart';

class CalendarPage extends StatefulWidget {
  static const String routeName = 'CalendarPage';
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late TaskProvider taskProvider;
  DateTime date = Utils.normalizeDate(DateTime.now());
  DateTime _selectedDay = Utils.normalizeDate(DateTime.now());

  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of<TaskProvider>(context);
    List<Task> tasks = taskProvider.tasks
        .where((t) => t.status == TaskStatus.pending && isSameDay(t.date, _selectedDay))
        .toList();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              startingDayOfWeek: StartingDayOfWeek.monday,
              locale: 'es_ES',
              focusedDay: _selectedDay,
              firstDay: DateTime(1986),
              lastDay: DateTime(2099),
              sixWeekMonthsEnforced: true,
              headerStyle: const HeaderStyle(titleCentered: true, formatButtonVisible: false),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(color: AppTheme.border, shape: BoxShape.circle),
                markerDecoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(
                  color: AppTheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) =>
                  setState(() => _selectedDay = selectedDay),
              eventLoader: (day) {
                return taskProvider.tasks
                    .where((t) => t.status == TaskStatus.pending && isSameDay(t.date, day))
                    .toList();
              },
              onPageChanged: (focusedDay) {
                if (Utils.isInSameMonth(focusedDay)) {
                  _selectedDay = DateTime.now();
                } else {
                  _selectedDay = focusedDay;
                }
                setState(() {});
              },
            ),
            Text('Tareas pendientes', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
            10.h,
            TasksListWidget(taskProvider: taskProvider, tasks: tasks),
          ],
        ),
      ),
    );
  }
}
