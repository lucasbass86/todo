import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/widgets/_widgets.dart';

class StatisticsPage extends StatefulWidget {
  static const String routeName = 'StatisticsPage';
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late TaskProvider taskProvider;
  List<Task> tasks = [];
  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of(context);
    tasks = taskProvider.getFilter(status: TaskStatus.completed);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _statisticsType(),
              _info(),
              if (tasks.isNotEmpty) _completedTaskGraphic(),
              if (tasks.isNotEmpty) _completedCategoriesGraphic(),
              _tasks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statisticsType() {
    return Center(
      child: SizedBox(
        height: 50,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: StatisticsType.values.length,
          separatorBuilder: (BuildContext context, int index) => SizedBox(width: 10),
          itemBuilder: (BuildContext context, int index) {
            return StatisticsWidget(type: StatisticsType.values[index]);
          },
        ),
      ),
    );
  }

  Widget _info() {
    List<Task> infoTasks = taskProvider.getFilter();
    int total = infoTasks.length;
    int completed = infoTasks.where((t) => t.status == TaskStatus.completed).toList().length;
    int pending = total - completed;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          _individualInfo(AppTheme.primary, total, 'Tareas'),
          _individualInfo(Colors.green, completed, 'Completadas'),
          _individualInfo(Colors.red, pending, 'Pendientes'),
        ],
      ),
    );
  }

  Widget _individualInfo(Color color, int numOfTasks, String title) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(50),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              '$numOfTasks',
              style: TextStyle(color: color, fontSize: 23, fontWeight: FontWeight.w700),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _completedTaskGraphic() {
    List<ChartData> data = [];
    switch (taskProvider.statisticsType) {
      case StatisticsType.week:
        data = completedOfWeek(tasks);
        break;
      case StatisticsType.month:
        data = completedOfMonth(tasks);
        break;
      case StatisticsType.year:
        data = completedOfYear(tasks);
        break;
    }
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tareas completadas', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(interval: 1),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries>[
              ColumnSeries<ChartData, String>(
                dataSource: data,
                xValueMapper: (item, _) => item.label,
                yValueMapper: (item, _) => item.value,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                color: AppTheme.secondary,
                name: 'Completadas',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _completedCategoriesGraphic() {
    List<String> ids = tasks.map((t) => t.idCategory).toSet().toList();
    List<ChartDataCategory> data = [];
    for (final i in ids) {
      final TaskCategory category = taskProvider.categories.firstWhere((c) => c.id == i);
      final int length = tasks.where((t) => t.idCategory == i).toList().length;
      final int percent = (length * 100 / tasks.length).floor();
      data.add(ChartDataCategory(category: category, value: length, percent: percent));
    }
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Categorías', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
          SfCircularChart(
            legend: Legend(
              overflowMode: LegendItemOverflowMode.wrap,
              isVisible: true,
              position: LegendPosition.left,
              legendItemBuilder: (legendText, series, point, seriesIndex) {
                ChartDataCategory data = series!.dataSource![seriesIndex] as ChartDataCategory;
                return Row(
                  spacing: 5,
                  children: [
                    Icon(Icons.circle, color: data.category.colorValue),
                    Text(data.category.name, style: TextStyle(fontWeight: FontWeight.w700)),
                    20.w,
                    Text('${data.percent}%'),
                  ],
                );
              },
            ),
            annotations: <CircularChartAnnotation>[
              CircularChartAnnotation(
                widget: Text(
                  '${tasks.length}',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            series: <CircularSeries>[
              DoughnutSeries<ChartDataCategory, String>(
                dataSource: data,
                pointColorMapper: (ChartDataCategory data, _) => data.category.colorValue,
                xValueMapper: (ChartDataCategory data, _) => data.category.name,
                yValueMapper: (ChartDataCategory data, _) => data.percent,
                innerRadius: '80%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tasks() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tasks.isNotEmpty)
            Text('Tareas completadas', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700)),
          20.h,
          TasksListWidget(
            taskProvider: taskProvider,
            tasks: tasks,
            expanded: false,
            status: TaskStatus.completed,
          ),
        ],
      ),
    );
  }

  List<ChartData> completedOfWeek(List<Task> tasks) {
    final counts = {
      1: 0, // L
      2: 0, // M
      3: 0, // X
      4: 0, // J
      5: 0, // V
      6: 0, // S
      7: 0, // D
    };

    for (final t in tasks) {
      counts[t.date.weekday] = counts[t.date.weekday]! + 1;
    }

    return [
      ChartData(label: 'L', value: counts[1]!),
      ChartData(label: 'M', value: counts[2]!),
      ChartData(label: 'X', value: counts[3]!),
      ChartData(label: 'J', value: counts[4]!),
      ChartData(label: 'V', value: counts[5]!),
      ChartData(label: 'S', value: counts[6]!),
      ChartData(label: 'D', value: counts[7]!),
    ];
  }

  List<ChartData> completedOfMonth(List<Task> tasks) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final counts = List<int>.filled(daysInMonth, 0);
    for (final workout in tasks) {
      if (workout.date.year == now.year && workout.date.month == now.month) {
        counts[workout.date.day - 1]++;
      }
    }

    return List.generate(
      daysInMonth,
      (index) => ChartData(label: (index + 1).toString(), value: counts[index]),
    );
  }

  List<ChartData> completedOfYear(List<Task> tasks) {
    final now = DateTime.now();
    final counts = List<int>.filled(12, 0);
    for (final workout in tasks) {
      if (workout.date.year == now.year) {
        counts[workout.date.month - 1]++;
      }
    }
    const months = ['E', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
    return List.generate(12, (index) => ChartData(label: months[index], value: counts[index]));
  }
}

class ChartData {
  final String label;
  final int value;

  const ChartData({required this.label, required this.value});
}

class ChartDataCategory {
  final TaskCategory category;
  final int value;
  final int percent;

  const ChartDataCategory({required this.category, required this.value, required this.percent});
}
