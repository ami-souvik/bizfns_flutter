import 'package:bizfns/provider/job_schedule_controller.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/route/RouteConstants.dart';
import '../../../core/utils/colour_constants.dart';
import '../../../core/widgets/HeaderJobPageWidget/header_jon_page_widget.dart';

class DateSelect extends StatefulWidget {
  const DateSelect({Key? key}) : super(key: key);

  @override
  State<DateSelect> createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final kToday = DateTime.now();
    final kFirstDay = kToday.subtract(
      Duration(days: 2000),
    );
    final kLastDay = DateTime(kToday.year, kToday.month + 48, kToday.day);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        // appBar: AppBar(
        //     backgroundColor: AppColor.APP_BAR_COLOUR,
        //     elevation: 0,
        //     centerTitle: true,
        //     title: const Text(
        //       "",
        //       style: TextStyle(color: Colors.black, fontSize: 16),
        //     ),
        //     leading: GestureDetector(
        //       onTap: () {
        //         GoRouter.of(context).goNamed('schedule');
        //         // Navigator.pop(context);
        //         //context.go(SCHEDULE_PAGE);
        //         // Fluttertoast.showToast(msg: "back");
        //       },
        //       child: const Icon(Icons.arrow_back, color: Colors.white),
        //     )),
        body: Column(
          children: [
            HeaderJobPage(
                isShow: false,
                provider: Provider.of<JobScheduleProvider>(context)),
            TableCalendar(
              // weekNumbersVisible: false,
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false, titleCentered: true),
              selectedDayPredicate: (day) {
                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                print(selectedDay.toString());
                var day = DateFormat('EE').format(selectedDay);
                Provider.of<JobScheduleProvider>(context, listen: false)
                    .changeData(selectedDay.toString());
                Provider.of<JobScheduleProvider>(context, listen: false)
                    .changeDay(day);
                Provider.of<JobScheduleProvider>(context, listen: false)
                    .generateDateList();

                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  // Fluttertoast.showToast(msg: "$selectedDay");
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  Provider.of<JobScheduleProvider>(context, listen: false)
                      .getScheduleList(context);

                  Navigator.pop(context, selectedDay);
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),
          ],
        ),
      ),
    );
  }
}
