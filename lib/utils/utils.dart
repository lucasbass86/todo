import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Utils {
  // Colores de categorías
  static const List<Color> categoryColors = [
    Color(0xFF3267F6),
    Color(0xFF9333EA),
    Color(0xFFF59E0B),
    Color(0xFF22C55E),
    Color(0xFFEF4444),
    Color(0xFF0891B2),
    Color(0xFFEC4899),
    Color(0xFF64748B),
    Colors.teal,
  ];

  // Iconos de categorías
  static final List<IconData> categoryIcons = [
    Icons.work_outline, // Trabajo
    Icons.person_outline, // Personal
    Icons.school_outlined, // Estudios
    Icons.favorite_border, // Salud
    Icons.shopping_cart_outlined, // Compras
    Icons.home_outlined, // Hogar
    Icons.fitness_center, // Deporte
    Icons.account_balance_wallet_outlined, // Finanzas
    Icons.event_outlined, // Eventos
    Icons.folder_outlined, // Otros
    Icons.local_hospital_rounded,
    Icons.rocket_launch,
  ];

  //UUID
  static String uuid() => Uuid().v4();

  //
  //SNACKBAR
  //
  static void snackBar(BuildContext context, String text, {Color? color, bool isBad = false}) {
    SnackBar snackBar = SnackBar(
      content: Text(text, style: const TextStyle(color: Colors.white)),
      backgroundColor: isBad ? Colors.red[300] : Colors.green[300],
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSnackBar(BuildContext context, String text, {Color? color, bool isBad = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: const TextStyle(color: Colors.white)),
        backgroundColor: isBad ? Colors.red[300] : Colors.green[300],
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  static String dateEnglishToSpanish(
    DateTime dateTime, {
    bool showTime = false,
    bool shortYear = false,
  }) {
    String date = dateTime.toString();
    String year = shortYear ? date.substring(2, 4) : date.substring(0, 4);
    String month = date.substring(5, 7);
    String day = date.substring(8, 10);
    if (!showTime) {
      return "$day-$month-$year";
    } else if (date.length > 10) {
      String hour = date.substring(11, 13);
      String minute = date.substring(14, 16);
      // String seconds = date.substring(17, 19);
      return "$day-$month-$year $hour:$minute";
    } else {
      return "$day-$month-$year 00:00";
    }
  }

  static String actualDate(DateTime dateTime) {
    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime normalized = DateTime(dateTime.year, dateTime.month, dateTime.day);
    if (now == normalized) {
      return 'Hoy';
    } else if (normalized == now.add(Duration(days: 1))) {
      return 'Mañana';
    } else {
      return dateEnglishToSpanish(dateTime);
    }
  }

  static DateTime normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  static bool isInSameWeek(DateTime date, {DateTime? reference}) {
    final ref = reference ?? DateTime.now();
    // Lunes de la semana de referencia
    final weekStart = ref.subtract(Duration(days: ref.weekday - 1));
    // Normalizar fechas
    final d1 = DateTime(date.year, date.month, date.day);
    final d2 = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final difference = d1.difference(d2).inDays;
    return difference >= 0 && difference <= 6;
  }

  static bool isInSameMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static bool isInSameYear(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year;
  }

  static String getWeekDayLetter(DateTime date) {
    const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    return days[date.weekday - 1];
  }

  static String getWeekDayName(DateTime date) {
    const days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return days[date.weekday - 1];
  }

  //
  // TIME OF DAY
  //
  static String timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static TimeOfDay addTimeOfDay(TimeOfDay a, TimeOfDay b) {
    final int minutosA = a.hour * 60 + a.minute;
    final int minutosB = b.hour * 60 + b.minute;

    final int total = minutosA + minutosB;

    final int horas = (total ~/ 60) % 24;
    final int minutos = total % 60;

    return TimeOfDay(hour: horas, minute: minutos);
  }

  static TimeOfDay durationToTimeOfDay(Duration d) {
    final int totalMin = d.inMinutes;
    final int hour = (totalMin ~/ 60) % 24;
    final int minute = totalMin % 60;

    return TimeOfDay(hour: hour, minute: minute);
  }

  //
  // DURATION
  //
  static String durationToString(
    Duration duration, {
    bool showSeconds = true,
    bool showZeroHour = false,
  }) {
    final hh = duration.inHours;
    final mm = duration.inMinutes % 60;
    final ss = duration.inSeconds % 60;
    return '${hh > 0 || showZeroHour ? '${hh.toString().padLeft(2, '0')}:' : ''}${mm.toString().padLeft(2, '0')}${showSeconds ? ':${ss.toString().padLeft(2, '0')}' : ''}';
    // return '${hh.toString().padLeft(2, '0')}:${mm.toString().padLeft(2, '0')}${showSeconds ? ':${ss.toString().padLeft(2, '0')}' : ''}';
  }

  static String minutesDurationToString(Duration duration) {
    final mm = duration.inMinutes;
    return mm.toString().padLeft(2, '0');
  }

  static String secondsDurationToString(Duration duration) {
    final ss = duration.inSeconds % 60;
    return ss.toString().padLeft(2, '0');
  }

  static int secondsDuration(Duration duration) {
    final ss = duration.inSeconds % 60;
    return ss;
  }

  //
  // CONNECTION
  //
  static bool isConnected = false;
  static Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('www.google.es');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
        return true;
      } else {
        isConnected = false;
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
