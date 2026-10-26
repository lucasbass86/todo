import 'package:flutter/material.dart';
import 'package:todo/pages/_pages.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/services/backup_service.dart';
import 'package:todo/services/license_service.dart';
import 'package:todo/utils/utils.dart';

class MainPage extends StatefulWidget {
  static const String routeName = 'MainPage';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String title = 'Mis Tareas';
  int pageIndex = 0;
  bool _hasRun = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkData(context));
  }

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        actions: [
          if (pageIndex == 0)
            IconButton(
              onPressed: () => Navigator.pushNamed(context, SearchPage.routeName),
              icon: Icon(Icons.search),
            ),
        ],
      ),
      body: _getPage(),
      floatingActionButton: pageIndex != 3
          ? FloatingActionButton(
              shape: StadiumBorder(),
              onPressed: () {
                if (taskProvider.categories.isNotEmpty) {
                  Navigator.pushNamed(context, TaskNewPage.routeName);
                } else {
                  Utils.showSnackBar(context, 'Hay que crear categorías', isBad: true);
                  Navigator.pushNamed(context, CategoriesListPage.routeName);
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) {
          pageIndex = value;
          switch (pageIndex) {
            case 0:
              title = 'Mis Tareas';
            case 1:
              title = 'Calendario';
            case 2:
              title = 'Estadísticas';
            case 3:
              title = 'Ajustes';
          }
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(label: 'Inicio', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Calendario', icon: Icon(Icons.calendar_month)),
          BottomNavigationBarItem(label: 'Estadísticas', icon: Icon(Icons.bar_chart_rounded)),
          BottomNavigationBarItem(label: 'Ajustes', icon: Icon(Icons.settings)),
        ],
      ),
    );
  }

  Widget _getPage() {
    switch (pageIndex) {
      case 0:
        return HomePage();
      case 1:
        return CalendarPage();
      case 2:
        return StatisticsPage();
      case 3:
        return SettingsPage();
      default:
        return HomePage();
    }
  }

  void _checkData(BuildContext context) async {
    if (!_hasRun) {
      _hasRun = true;
      Future.delayed(const Duration(seconds: 1), () async {
        if (context.mounted) await LicenseService.checkLicense(context);
        if (context.mounted) await UpdateService.checkUpdates(context);
        if (context.mounted) {
          final resp = await BackupService.checkBackUp(context);
          if (resp) {
            setState(() => pageIndex = 3);
          }
        }
      });
    }
  }
}
