import 'package:flutter/material.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/utils/extensions.dart';
import 'package:todo/utils/utils.dart';

class CategoryNewPage extends StatefulWidget {
  static const String routeName = 'CategoryNewPage';
  const CategoryNewPage({super.key});

  @override
  State<CategoryNewPage> createState() => _CategoryNewPageState();
}

class _CategoryNewPageState extends State<CategoryNewPage> {
  TextEditingController controller = TextEditingController();
  Color color = Utils.categoryColors[0];
  IconData icon = Utils.categoryIcons[0];
  TaskCategory? category;
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments is TaskCategory && isLoading) {
      category = arguments;
      controller = TextEditingController(text: category!.name);
      color = category!.colorValue;
      icon = category!.icon;
      isLoading = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(category == null ? 'Nueva categoría' : 'Editar categoría'),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            10.h,
            TextField(
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 50,
              decoration: InputDecoration(
                hint: Text('Introduce el título de la categoría'),
                counterText: '',
              ),
            ),
            20.h,
            Text('Icono', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            SizedBox(
              height: 50,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: Utils.categoryIcons.length,
                separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10),
                itemBuilder: (BuildContext context, int index) {
                  bool selected = Utils.categoryIcons[index] == icon;
                  return GestureDetector(
                    onTap: () => setState(() {
                      icon = Utils.categoryIcons[index];
                    }),
                    child: Icon(Utils.categoryIcons[index], size: selected ? 50 : 30),
                  );
                },
              ),
            ),
            20.h,
            Text('Color', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            10.h,
            SizedBox(
              height: 50,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: Utils.categoryColors.length,
                separatorBuilder: (BuildContext context, int index) => SizedBox(width: 10),
                itemBuilder: (BuildContext context, int index) {
                  bool selected = Utils.categoryColors[index] == color;
                  return GestureDetector(
                    onTap: () => setState(() {
                      color = Utils.categoryColors[index];
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: selected ? 50 : 35,
                      height: selected ? 50 : 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Utils.categoryColors[index],
                      ),
                    ),
                  );
                },
              ),
            ),
            10.h,
            20.h,
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.text.isEmpty) {
                    Utils.showSnackBar(context, 'El nombre es obligatorio', isBad: true);
                    return;
                  }
                  TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);
                  if (category == null) {
                    category = TaskCategory(name: controller.text, colorValue: color, icon: icon);
                  } else {
                    category!.name = controller.text;
                    category!.colorValue = color;
                    category!.icon = icon;
                  }
                  if (taskProvider.addCategory(category!)) {
                    Utils.showSnackBar(context, 'Categoría guardada');
                    Navigator.pop(context);
                  }
                },
                child: Text(category == null ? 'Guardar' : 'Modificar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
