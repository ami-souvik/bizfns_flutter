import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPopupExample extends StatefulWidget {
  @override
  _CalendarPopupExampleState createState() => _CalendarPopupExampleState();
}

class _CalendarPopupExampleState extends State<CalendarPopupExample> {
  List<DateTime> selectedWeekDates = [];

  // Function to open calendar in a dialog
  Future<void> _openCalendarDialog(BuildContext context) async {
    List<DateTime>? result = await showDialog(
      context: context,
      builder: (context) {
        return CalendarDialog();
      },
    );

    if (result != null) {
      setState(() {
        selectedWeekDates = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar Popup Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _openCalendarDialog(context);
            },
            child: Text('Open Calendar'),
          ),
          if (selectedWeekDates.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Selected Week Dates:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedWeekDates.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          DateFormat('EEEE, dd MMM yyyy')
                              .format(selectedWeekDates[index]),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class CalendarDialog extends StatefulWidget {
  final List<DateTime>? initialSelectedDates;

  const CalendarDialog({super.key, this.initialSelectedDates});
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
    // selectedWeekDates =
    //     getWeekDates(focusedDay); // Initialize with the current week
    if (widget.initialSelectedDates != null &&
        widget.initialSelectedDates!.isNotEmpty) {
      focusedDay = widget.initialSelectedDates!.first;
      selectedWeekDates = widget.initialSelectedDates!;
    } else {
      // Initialize to the current week if no initial dates are provided
      focusedDay = DateTime.now();
      selectedWeekDates = getWeekDates(focusedDay);
    }
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
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: selectPreviousWeek,
                ),
                Text(
                  '${dateFormatter.format(selectedWeekDates.first)} - ${dateFormatter.format(selectedWeekDates.last)}',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
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
            headerVisible:
                false, // Hide the default header to replace it with week navigation
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // Close dialog without selecting dates
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context,
                        selectedWeekDates); // Return the selected dates
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
