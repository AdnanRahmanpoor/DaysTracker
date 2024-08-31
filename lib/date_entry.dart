import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DateEntry {
  DateTime date;
  String title;
  String displayOption;

  DateEntry({required this.date, required this.title, required this.displayOption});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'title': title,
        'displayOption': displayOption,
      };

  factory DateEntry.fromJson(Map<String, dynamic> json) {
    return DateEntry(
        date: DateTime.parse(json['date']),
        title: json['title'],
        displayOption: json['displayOption']);
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
