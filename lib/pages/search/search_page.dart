import 'package:flutter/material.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/pages/_pages.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/utils/enums.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/widgets/_widgets.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = 'SearchPage';
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);
  TextEditingController searchController = TextEditingController();
  TaskStatus status = TaskStatus.all;
  TaskPriority priority = TaskPriority.all;
  List<TaskCategory> categories = [];

  @override
  void initState() {
    super.initState();
    _filter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Buscar')),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _search(),
              StatusWidget(
                onTap: (value) {
                  setState(() {
                    status = value;
                    _filter();
                  });
                },
              ),
              _priorities(),
              20.h,
              _categories(),
              20.h,
            ],
          ),
        ),
      ),
    );
  }

  void _filter() {
    List<Task> tasks = taskProvider.tasks
        .where(
          (t) =>
              (!t.deleted) &&
              (priority == TaskPriority.all ? true : t.priority == priority) &&
              (status == TaskStatus.all ? true : t.status == status) &&
              (searchController.text.isEmpty
                  ? true
                  : (t.description.toUpperCase().contains(searchController.text.toUpperCase()) ||
                        t.title.toUpperCase().contains(searchController.text.toUpperCase()))),
        )
        .toList();
    List<String> ids = tasks.map((t) => t.idCategory).toSet().toList();
    categories = taskProvider.categories.where((c) => ids.contains(c.id)).toList();
    setState(() {});
  }

  Widget _search() {
    return TextField(
      controller: searchController,
      maxLength: 50,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        counterText: '',
        prefixIcon: Icon(Icons.search),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              searchController.text = '';
              _filter();
            });
          },
          child: Icon(Icons.clear),
        ),
        hint: Text('Buscar tarea...'),
      ),
      onChanged: (value) => _filter(),
    );
  }

  Widget _priorities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Prioridad', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
        20.h,
        SizedBox(
          height: 50,
          child: Center(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: TaskPriority.values.length,
              itemBuilder: (BuildContext context, int index) {
                return PriorityWidget(
                  priority: TaskPriority.values[index],
                  selected: priority == TaskPriority.values[index],
                  onTap: (value) {
                    priority = value;
                    _filter();
                    setState(() {});
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _categories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categorías', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
        20.h,
        if (categories.isNotEmpty)
          ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: categories.length,
            separatorBuilder: (BuildContext context, int index) => const Divider(),
            itemBuilder: (BuildContext context, int index) {
              final TaskCategory category = categories[index];
              int numOfTasks = taskProvider.tasks
                  .where(
                    (t) =>
                        (!t.deleted) &&
                        (t.idCategory == category.id) &&
                        (priority == TaskPriority.all ? true : t.priority == priority) &&
                        (status == TaskStatus.all ? true : t.status == status) &&
                        (searchController.text.isEmpty
                            ? true
                            : t.description.toUpperCase().contains(
                                    searchController.text.toUpperCase(),
                                  ) ||
                                  t.title.toUpperCase().contains(
                                    searchController.text.toUpperCase(),
                                  )),
                  )
                  .toList()
                  .length;
              return ListTile(
                shape: StadiumBorder(),
                onTap: () =>
                    Navigator.pushNamed(context, CategoryDetailPage.routeName, arguments: category),
                leading: CircleAvatar(
                  backgroundColor: category.colorValue,
                  child: Icon(category.icon),
                ),
                title: Text(
                  category.name,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
                ),
                trailing: Text('$numOfTasks', style: TextStyle(fontSize: 19)),
              );
            },
          ),
        if (categories.isEmpty) NoTasksWidget(status: status),
      ],
    );
  }
}
