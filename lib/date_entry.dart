import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DateEntry {
  DateTime date;

  DateEntry({required this.date});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
      };

  factory DateEntry.fromJson(Map<String, dynamic> json) {
    return DateEntry(date: DateTime.parse(json['date']));
  }
}

class DateEntryManager {
  static const String _storageKey = 'date_entries';

  static Future<void> saveEntries(List<DateEntry> entries) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonEntries =
        entries.map((entry) => jsonEncode(entry.toJson())).toList();
    prefs.setStringList(_storageKey, jsonEntries);
  }

  static Future<List<DateEntry>> loadEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonEntries = prefs.getStringList(_storageKey);
    if (jsonEntries != null) {
      return jsonEntries
          .map((jsonEntry) => DateEntry.fromJson(jsonDecode(jsonEntry)))
          .toList();
    } else {
      return [];
    }
  }
}
