// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/dialogs/dialogs.dart';
import 'package:todo/hive/boxes.dart';
import 'package:todo/models/_models.dart';
import 'package:todo/preferences/preferences.dart';
import 'package:todo/secrets/secrets.dart';

class User {
  String email;
  String password;
  List<TaskCategory> categories;
  List<Task> tasks;

  @override
  String toString() => email;

  User({
    required this.email,
    required this.password,
    required this.categories,
    required this.tasks,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    email: json['email'],
    password: json['password'].toString(),
    categories: (json['categories'] as List).map((e) => TaskCategory.fromJson(e)).toList(),
    tasks: (json['tasks'] as List?)?.map((e) => Task.fromJson(e)).toList() ?? [],
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'categories': (categories).map((e) => e.toJson()).toList(),
    'tasks': (tasks).map((e) => e.toJson()).toList(),
  };
}

class BackupService {
  static final _baseUrl = Secret.firebaseUrl;

  static Future<void> addBackUp(User user) async {
    final String emailKey = user.email.replaceAll('.', ',');
    final url = Uri.https(_baseUrl, '${Secret.appName}/$emailKey.json');
    final resp = await http.put(url, body: jsonEncode(user.toJson()));
    final decodedData = resp.body;
  }

  static Future<User?> getBackUp(String email) async {
    final String emailKey = email.replaceAll('.', ',');
    final url = Uri.https(_baseUrl, '${Secret.appName}/$emailKey.json');
    final resp = await http.get(url);
    if (resp.statusCode != 200 || resp.body == 'null') {
      print('No se encontró el backup');
      return null;
    }
    final Map<String, dynamic> data = jsonDecode(resp.body);
    User user = User.fromJson(data);
    return user;
  }

  static Future<void> deleteBackUp(String email) async {
    final String emailKey = email.replaceAll('.', ',');
    final url = Uri.https(_baseUrl, '${Secret.appName}/$emailKey.json');
    final resp = await http.delete(url);
    print(resp);
  }

  static Future<bool> checkBackUp(BuildContext context) async {
    final navigator = Navigator.of(context);
    bool wantBackUp = false;
    if (Preferences.backUp.isNotEmpty && Boxes.categories.values.isNotEmpty) {
      if (DateTime.now().difference(DateTime.parse(Preferences.backUp)).inDays >=
          Preferences.backupDays) {
        final resp = await showMessage(
          context: context,
          title: 'Llevas ciertos días sin hacer copia de seguridad. ¿Hacer copia?',
          showCancel: true,
        );
        if (resp) {
          wantBackUp = true;
        }
      }
    }
    return wantBackUp;
  }
}
