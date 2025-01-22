import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDialog extends StatefulWidget {
  @override
  _CalendarDialogState createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  DateTime focusedDay = DateTime.now();
  List<DateTime> selectedWeekDates = [];

  // Get the start of the week (Monday)
  DateTime getStartOfWeek(DateTime date) {
    int currentWeekday = date.weekday;
    return date.subtract(Duration(days: currentWeekday - 1)); // Monday as start
  }

  // Get the list of dates from Monday to Saturday
  List<DateTime> getWeekDates(DateTime date) {
    DateTime startOfWeek = getStartOfWeek(date);
    return List.generate(6, (index) => startOfWeek.add(Duration(days: index)));
  }

  @override
  void initState() {
    super.initState();
    selectedWeekDates = getWeekDates(focusedDay); // Initialize with the current week
  }

  // Function to select the previous week
  void selectPreviousWeek() {
    setState(() {
      focusedDay = focusedDay.subtract(Duration(days: 7));
      selectedWeekDates = getWeekDates(focusedDay);
    });
  }

  // Function to select the next week
  void selectNextWeek() {
    setState(() {
      focusedDay = focusedDay.add(Duration(days: 7));
      selectedWeekDates = getWeekDates(focusedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormatter = DateFormat('dd MMM yyyy');

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: selectPreviousWeek,
                ),
                Text(
                  '${dateFormatter.format(selectedWeekDates.first)} - ${dateFormatter.format(selectedWeekDates.last)}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: selectNextWeek,
                ),
              ],
            ),
          ),
          TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) {
              return selectedWeekDates.contains(day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.focusedDay = focusedDay;
                this.selectedWeekDates = getWeekDates(focusedDay);
              });
            },
            headerVisible: false, // Hide the default header to replace it with week navigation
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog without selecting dates
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, selectedWeekDates); // Return the selected dates
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}