import 'package:flutter/material.dart';
import 'package:todo/pages/_pages.dart';
import 'package:todo/services/license_service.dart';

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
  MainPage.routeName: (_) => const MainPage(),
  HomePage.routeName: (_) => const HomePage(),
  CalendarPage.routeName: (_) => const CalendarPage(),
  StatisticsPage.routeName: (_) => const StatisticsPage(),
  SettingsPage.routeName: (_) => const SettingsPage(),
  TaskNewPage.routeName: (_) => const TaskNewPage(),
  CategoriesListPage.routeName: (_) => const CategoriesListPage(),
  CategoryNewPage.routeName: (_) => const CategoryNewPage(),
  TaskDetailPage.routeName: (_) => const TaskDetailPage(),
  SearchPage.routeName: (_) => const SearchPage(),
  TasksDeletedPage.routeName: (_) => const TasksDeletedPage(),
  TaskEditPage.routeName: (_) => const TaskEditPage(),
  CategoryDetailPage.routeName: (_) => const CategoryDetailPage(),
  BackUpPage.routeName: (_) => const BackUpPage(),
  UpdatePage.routeName: (_) => const UpdatePage(),
};
