import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KuselDateUtils {
  static late bool is24HourFormat;

  /// Initialize the utility with context to detect system time format (12/24 hr)
  static void init(BuildContext context) {
    is24HourFormat = MediaQuery.of(context).alwaysUse24HourFormat;
  }

  /// Converts a UTC time string (like '14:30') to system-local time format.
  static String getSystemFormattedTimeFromUTC(String utcTime) {
    final DateTime now = DateTime.now().toUtc();
    final String year = now.year.toString();
    final String month = now.month.toString().padLeft(2, '0');
    final String day = now.day.toString().padLeft(2, '0');

    // Construct ISO 8601 compliant UTC time string
    final String fullUtcTime = "$year-$month-$day" "T$utcTime:00Z";

    final DateTime utcDateTime = DateTime.parse(fullUtcTime).toUtc();
    final DateTime localDateTime = utcDateTime.toLocal();

    final String formattedTime = is24HourFormat
        ? DateFormat('HH:mm').format(localDateTime)
        : DateFormat('hh:mm a').format(localDateTime);

    return formattedTime;
  }

  /// Formats a DateTime object into 'dd.MM.yyyy' format
  static String formatDate(String inputDate) {
    try {
      final DateTime parsedDate = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd.MM.yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      return inputDate;
    }
  }

  /// Formats a DateTime object into 'dd.MM.yyyy' format
  static String formatDateInFormatYYYYMMDD(String inputDate) {
    try {
      final DateTime parsedDate = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(parsedDate);
    } catch (e) {
      return inputDate;
    }
  }

  // Add this new method for UI display
  static String formatDateInFormatDDMMYYYY(String inputDate) {
    try {
      final DateTime parsedDate = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      return inputDate;
    }
  }

  static String formatDateTime(String inputDate) {
    try {
      final DateTime parsedDate = DateTime.parse(inputDate);
      final DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm');
      return formatter.format(parsedDate);
    } catch (e) {
      return inputDate;
    }
  }

  static String formatTime(String? time) {
    if (time == null || time.isEmpty) return '';
    try {
      final dateTime = DateFormat.Hms().parse(time);
      return DateFormat.Hm().format(dateTime);
    } catch (e) {
      return time;
    }
  }

  static bool checkDatesAreSame(DateTime date1, DateTime date2) {
    if (date1.isBefore(date2)) {
      return false;
    } else if (date1.isAfter(date2)) {
      return false;
    } else {
      return true;
    }
  }
}
