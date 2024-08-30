import 'package:flutter/material.dart';


class DatePickerPage extends StatefulWidget {
  @override
  DatePickerPageState createState() => DatePickerPageState();
}

class DatePickerPageState extends State<DatePickerPage> {
    DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a Date'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }},
              child: Text('Select date'),
            ),
            if (selectedDate != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Selected date: ${selectedDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedDate);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
