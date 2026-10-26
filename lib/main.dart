import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/hive/boxes.dart';
import 'package:todo/pages/_pages.dart';
import 'package:todo/preferences/preferences.dart';
import 'package:todo/providers/task_provider.dart';
import 'package:todo/routes/routes.dart';
import 'package:todo/themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Preferences.init();

  await Hive.initFlutter();

  await Hive.openBox(Boxes.boxNameCategories);
  await Hive.openBox(Boxes.boxNameTasks);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TaskProvider(), lazy: true)],
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo',
      routes: routes,
      initialRoute: MainPage.routeName,
      theme: AppTheme.coffeeTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        //Locale('en'), // English
        Locale('es'), // Spanish
      ],
    );
  }
}
