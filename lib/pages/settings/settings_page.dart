import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:todo/pages/_pages.dart';
import 'package:todo/preferences/preferences.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/utils/extensions.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = 'SettingsPage';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TaskProvider taskProvider;
  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              shape: StadiumBorder(),
              value: taskProvider.groupTasks,
              onChanged: (value) => setState(() => taskProvider.groupTasks = value),
              title: Text(
                'Agrupar tareas por categoría',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
            ),
            Divider(),
            _settingItem(CategoriesListPage.routeName, Icons.label_rounded, 'Categorias'),
            Divider(),
            _settingItem(TasksDeletedPage.routeName, Icons.delete, 'Eliminadas'),
            Divider(),
            _settingItem(BackUpPage.routeName, Icons.cloud_rounded, 'Copias seguridad'),
            Divider(),
            ListTile(
              shape: StadiumBorder(),
              onTap: _info,
              leading: Icon(Icons.info_outline, color: AppTheme.primary),
              title: Text(
                'Información',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.primary),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _settingItem(String routeName, IconData icon, String title) {
    return ListTile(
      shape: StadiumBorder(),
      onTap: () => Navigator.pushNamed(context, routeName),
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.primary),
    );
  }

  void _info() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Información', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500)),
              10.h,
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Licencia: ${Preferences.license}', style: TextStyle(fontSize: 17)),
                        Divider(),
                        FutureBuilder(
                          future: PackageInfo.fromPlatform(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              PackageInfo packageInfo = snapshot.data as PackageInfo;
                              return Text(
                                'Version: ${packageInfo.version}',
                                style: TextStyle(fontSize: 17),
                              );
                            } else {
                              return Text('');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
