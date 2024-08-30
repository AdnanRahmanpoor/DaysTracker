import 'package:DaysTracker/date_picker_page.dart';
import 'package:flutter/material.dart';
import 'date_entry.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isDarkMode = await ThemeManager.getThemeMode();
  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;

  MyApp({required this.isDarkMode});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme(bool isDarkMode) async {
    await ThemeManager.setThemeMode(isDarkMode);
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeManager.getDarkTheme() : ThemeManager.getLightTheme(),
      home: HomePage(
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  HomePage({required this.isDarkMode, required this.onThemeChanged});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DateEntry> dateEntries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    dateEntries = await DateEntryManager.loadEntries();
    setState(() {});
  }

  void _addEntry(DateEntry entry) {
    setState(() {
      dateEntries.add(entry);
    });
    DateEntryManager.saveEntries(dateEntries);
  }

  void _deleteEntry(int index) {
    setState(() {
      dateEntries.removeAt(index);
    });
    DateEntryManager.saveEntries(dateEntries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Days Tracker'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              widget.onThemeChanged(!widget.isDarkMode);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dateEntries.length,
        itemBuilder: (context, index) {
          final dateEntry = dateEntries[index];
          final now = DateTime.now();
          final difference = dateEntry.date.difference(now).inDays;
          final isFuture = difference >= 0;
          final displayText = isFuture
              ? '$difference days until ${dateEntry.date.toLocal().toString().split(' ')[0]}'
              : '${-difference} days since ${dateEntry.date.toLocal().toString().split(' ')[0]}';

          return Card(
            child: ListTile(
              title: Text(displayText),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteEntry(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pickedDate = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DatePickerPage()),
          );
          if (pickedDate != null) {
            _addEntry(DateEntry(date: pickedDate));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
