import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool _groupTasks = false;
  static bool get groupTasks => _prefs.getBool('groupTasks') ?? _groupTasks;
  static set groupTasks(bool value) {
    _groupTasks = value;
    _prefs.setBool('groupTasks', value);
  }

  static String _backUp = '';
  static String get backUp => _prefs.getString('backUp') ?? _backUp;
  static set backUp(String value) {
    _backUp = value;
    _prefs.setString('backUp', _backUp);
  }

  static int _backupDays = 10;
  static int get backupDays => _prefs.getInt('backupDays') ?? _backupDays;
  static set backupDays(int value) {
    _backupDays = value;
    _prefs.setInt('backupDays', value);
  }

  static String _license = '';
  static String get license => _prefs.getString('license') ?? _license;
  static set license(String value) {
    _license = value;
    _prefs.setString('license', value);
  }

  static String _email = '';
  static String get email => _prefs.getString('email') ?? _email;
  static set email(String value) {
    _email = value;
    _prefs.setString('email', value);
  }

  static String _passBackUp = '';
  static String get passBackUp => _prefs.getString('passBackUp') ?? _passBackUp;
  static set passBackUp(String value) {
    _passBackUp = value;
    _prefs.setString('passBackUp', value);
  }
}
