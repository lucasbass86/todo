import 'package:flutter/material.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/pages/_pages.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/widgets/_widgets.dart';

class CategoriesListPage extends StatelessWidget {
  static const String routeName = 'CategoriesListPage';
  const CategoriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    List<TaskCategory> categories = taskProvider.categories
      ..sort((a, b) => a.name.compareTo(b.name));
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: () => Navigator.pop(context), child: Text('Mis categorías')),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const StadiumBorder(),
        onPressed: () => Navigator.pushNamed(context, CategoryNewPage.routeName),
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: categories.length,
          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
          itemBuilder: (BuildContext context, int index) =>
              CategoryWidget(category: categories[index]),
        ),
      ),
    );
  }
}
