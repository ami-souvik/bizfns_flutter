import 'dart:developer';

import 'package:bizfns/features/Settings/widget/weekly_calender.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import '../../core/utils/Utils.dart';
import '../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../Admin/Staff/provider/staff_provider.dart';
import '../Admin/model/get_staff_details_model.dart';
import 'job_list.dart';
import 'model/time_sheet_by_billno_staff_model.dart';

class TimeSheetBill extends StatefulWidget {
  final StaffDetailsData data;
  const TimeSheetBill({super.key, required this.data});

  @override
  State<TimeSheetBill> createState() => _TimeSheetBillState();
}

class _TimeSheetBillState extends State<TimeSheetBill> {
  List<DateTime> selectedWeekDates = [];
  final List<String> status = ['Open', 'Closed'];
  List<List<TextEditingController>> hourControllers =
      []; // Controllers for hour textfields
  List<List<TextEditingController>> overtimeControllers = [];

  // List<List<List<int>>> jobEvents = [];
  var selectedStatus;
  bool isExempt = false;
  double totalHour = 0.00;
  double totalOverTimeHour = 0.0;
  double totalHourTimeCost = 0.0;
  double totalOverTimeCost = 0.0;
  double overTimeChargeRate = 0.0;
  var blueShadedColors = [
    const Color(0xffEAF6FF),
    const Color(0xffDCEEFC),
    const Color(0xffC8E4FB),
    const Color(0xffBCE1FB),
    const Color(0xffB3DBFB),
    const Color(0xffA7D7FB)
  ];

  void addFieldsForDate(int index) {
    setState(() {
      // Ensure the sublist exists for this date
      if (hourControllers.length <= index) {
        hourControllers.add([]); // Add empty list if not present
      }
      if (overtimeControllers.length <= index) {
        overtimeControllers.add([]); // Same for overtime
      }

      // Add a new controller for regular and overtime hours
      hourControllers[index].add(TextEditingController());
      overtimeControllers[index].add(TextEditingController());

      // Initialize jobEvents for this index
      Provider.of<StaffProvider>(context, listen: false)
          .jobEvents[index]
          .add([]);
    });
  }

  void addOvertimeListeners() {
    for (var overtimeRow in overtimeControllers) {
      for (var controller in overtimeRow) {
        controller.addListener(() {
          // Call the total overtime calculation function whenever a value changes
          updateTotalOvertime();
        });
      }
    }
  }

  void addHourListeners() {
    for (var timeRow in hourControllers) {
      for (var controller in timeRow) {
        controller.addListener(() {
          // Call the total hour calculation function whenever a value changes
          updateTotalTime();
        });
      }
    }
  }

  void updateTotalOvertime() {
    setState(() {
      totalOverTimeHour = calculateTotalOvertime();
      totalOverTimeCost = totalOverTimeHour * overTimeChargeRate;
    });
  }

  void updateTotalTime() {
    setState(() {
      totalHour = calculateTime();
      totalHourTimeCost = totalHour * widget.data.chargerate!;
    });
  }

  double calculateTotalOvertime() {
    double total = 0.0;

    for (var overtimeRow in overtimeControllers) {
      for (var controller in overtimeRow) {
        if (controller.text.isNotEmpty &&
            double.tryParse(controller.text) != null) {
          total += double.tryParse(controller.text) ?? 0.0;
        }
      }
    }
    log("TOTAL OVERTIME: ${total}");
    return total;
  }

  double calculateTime() {
    double total = 0.00;
    for (var timeRow in hourControllers) {
      for (var controller in timeRow) {
        if (controller.text.isNotEmpty &&
            double.tryParse(controller.text) != null) {
          total += double.tryParse(controller.text) ?? 0.0;
        }
      }
    }
    log("TOTAL TIME : ${total}");
    return total;
  }

  // Function to open calendar in a dialog
  Future<void> _openCalendarDialog(BuildContext context) async {
    List<DateTime>? result = await showDialog(
      context: context,
      builder: (context) {
        return CalendarDialog(initialSelectedDates: selectedWeekDates);
      },
    );

    if (result != null) {
      setState(() {
        hourControllers.clear();
        overtimeControllers.clear();
        Provider.of<StaffProvider>(context, listen: false).jobEvents.clear();
        selectedWeekDates = result;
        for (var i = 0; i < selectedWeekDates.length; i++) {
          hourControllers.add([]); // Initialize empty controllers for hours
          overtimeControllers.add([]);
          Provider.of<StaffProvider>(context, listen: false).jobEvents.add([]);
          addFieldsForDate(i);
          setState(() {});
        }
        Provider.of<StaffProvider>(context, listen: false)
            .getTimeSheetByBillNoId(
                billNo: generateDynamicString(
                    selectedWeekDates, '${widget.data.stafflastname}'),
                staffId: widget.data.staffid.toString())
            .then((value) {
          if (Provider.of<StaffProvider>(context, listen: false)
              .timeSheetData
              .isNotEmpty) {
            populateTimeSheetData();
          }

          // if (Provider.of<StaffProvider>(context, listen: false)
          //     .timeSheetData
          //     .isNotEmpty) {
          //   log("Selected weekDates length : ${selectedWeekDates.length}");
          //   log("timeSheetData length : ${Provider.of<StaffProvider>(context, listen: false).timeSheetData.length}");
          //   log("hourcontroller length : ${hourControllers.length}");

          //   for (var i = 0; i < selectedWeekDates.length; i++) {
          //     // if (DateFormat('yyyy-MM-dd').format(selectedWeekDates[i]) ==
          //     //     '') {}
          //     log("Formatted Date : ${DateFormat('yyyy-MM-dd').format(selectedWeekDates[i])}");
          //     hourControllers[i][0].text = Provider.of<StaffProvider>(context, listen: false).timeSheetData[i].regularHour.toString();

          //     // for (var j = 0; i < count; i++) {

          //     // }

          //     // if (DateFormat('yyyy-MM-dd').format(selectedWeekDates[i]) ==
          //     //     Provider.of<StaffProvider>(context, listen: false)
          //     //         .timeSheetData[i]
          //     //         .dateOfWeek) {
          //     //   log("YES");
          //     //   for (var j = 0;
          //     //       j <
          //     //           hourControllers
          //     //               .length-1;
          //     //       j++) {
          //     //     hourControllers[i][j].text =
          //     //         Provider.of<StaffProvider>(context, listen: false)
          //     //             .timeSheetData[j]
          //     //             .regularHour
          //     //             .toString();
          //     //   }
          //     // } else {
          //     //   log("No");
          //     // }
          //   }

          //   // for (var i = 0; i < selectedWeekDates.length; i++) {
          //   //   for (var i = 0;
          //   //     i <
          //   //         Provider.of<StaffProvider>(context, listen: false)
          //   //             .timeSheetData
          //   //             .length;
          //   //     i++) {
          //   //   log("timeSheetData : ${Provider.of<StaffProvider>(context, listen: false).timeSheetData[i].dateOfWeek}");
          //   //   for (var j = 0; j < selectedWeekDates.length; j++) {
          //   //     hourControllers[i][j].text =
          //   //         Provider.of<StaffProvider>(context, listen: false)
          //   //             .timeSheetData[i]
          //   //             .regularHour
          //   //             .toString();
          //   //   }
          //   // }
          //   // }

          //   // for (var i = 0; i < selectedWeekDates.length; i++) {
          //   //   hourControllers.add([]); // Initialize empty controllers for hours
          //   //   overtimeControllers.add([]);
          //   //   Provider.of<StaffProvider>(context, listen: false)
          //   //       .jobEvents
          //   //       .add([]);
          //   //   addFieldsForDate(i);
          //   //   setState(() {});
          //   // }
          // }
          setState(() {});
        });

        ;
      });
    }
  }

  void populateTimeSheetData() {
    // Clear previous controllers if necessary
    hourControllers.clear();
    overtimeControllers.clear();
    Provider.of<StaffProvider>(context, listen: false).jobEvents.clear();

    // Iterate over selected week dates
    for (var i = 0; i < selectedWeekDates.length; i++) {
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedWeekDates[i]);

      // Get all entries for the current date
      List<TimeSheetData> matchingEntries =
          Provider.of<StaffProvider>(context, listen: false)
              .timeSheetData
              .where((entry) => entry.dateOfWeek == formattedDate)
              .toList();

      // Initialize controllers for each entry (if any)
      if (matchingEntries.isNotEmpty) {
        // Initialize the controllers for this date if not already done
        hourControllers.add([]);
        overtimeControllers.add([]);
        Provider.of<StaffProvider>(context, listen: false).jobEvents.add([]);

        // Add controllers and populate data for each matching entry
        for (var entry in matchingEntries) {
          hourControllers[i].add(
              TextEditingController(text: entry.regularHour?.toString() ?? ''));
          overtimeControllers[i].add(TextEditingController(
              text: entry.overtimeHour?.toString() ?? ''));

          // Add jobEvents if necessary (just an example, update accordingly)
          Provider.of<StaffProvider>(context, listen: false).jobEvents[i].add(
              entry.jobEvents != null && entry.jobEvents!.isNotEmpty
                  ? entry.jobEvents!
                      .split(',')
                      .map((e) => int.tryParse(e))
                      .whereType<int>()
                      .toList()
                  : []);
        }
      } else {
        // Add empty controllers if no matching entry for the date
        hourControllers.add([TextEditingController()]);
        overtimeControllers.add([TextEditingController()]);
      }
    }
  }

  int getWeekNumber(DateTime date) {
    DateTime startOfYear = DateTime(date.year, 1, 1);
    int dayOfYear = date.difference(startOfYear).inDays + 1;
    return ((dayOfYear - 1) ~/ 7) + 1;
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String generateDynamicString(
      List<DateTime> selectedWeekDates, String customerSurname) {
    DateTime dateToUse;

    if (selectedWeekDates.isNotEmpty) {
      // Use the first day of the selected week
      dateToUse = selectedWeekDates[0];
    } else {
      // Use the current date
      dateToUse = DateTime.now();
    }

    // Extract year, month, and day
    String year = DateFormat('yy').format(dateToUse);
    String month = DateFormat('MM').format(dateToUse);
    String day = DateFormat('dd').format(dateToUse);

    // Construct the string
    String dynamicString =
        'TS-${customerSurname.toUpperCase()}-$year$month$day';

    return dynamicString;
  }

  @override
  void initState() {
    addOvertimeListeners();
    addHourListeners();
    // Provider.of<StaffProvider>(context, listen: false)
    //     .getStaffRateForStaffLogin(
    //         context: context, id: (widget.data.chargefrequency!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return CalendarPopupExample();
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Time-Sheet Bill No : ",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    Text(generateDynamicString(
                        selectedWeekDates, '${widget.data.stafflastname}'))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Status : ",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 2.0,
                      ),
                      child: Container(
                        height: 30,
                        width: 100,
                        child: DropdownButtonFormField2(
                          value: selectedStatus,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            //Add more decoration as you want here
                            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                          hint: const Text(
                            'Status',
                            style: TextStyle(fontSize: 14),
                          ),
                          isExpanded: true,
                          // hint: const Text(
                          //   'Select Your Gender',
                          //   style: TextStyle(fontSize: 14),
                          // ),
                          items: status
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          /*validator: (value) {
                                      if (value == null) {
                                        return 'Please select gender.';
                                      }
                                      return null;
                                    },*/
                          onChanged: (value) {
                            selectedStatus = value;
                            setState(() {});
                          },
                          // onSaved: (value) {
                          //
                          //   selectedValue = value.toString();
                          //   print("onsaved value ====>$selectedValue");
                          // },
                          // buttonStyleData: const ButtonStyleData(
                          //   height: 60,
                          //   padding: EdgeInsets.only(left: 20, right: 10),
                          // ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 20,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "Week ${getWeekNumber(selectedWeekDates.isNotEmpty ? selectedWeekDates.first : DateTime.now())}"),
                Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: selectedWeekDates.isNotEmpty
                              ? Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(selectedWeekDates[0]),
                                )
                              : Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()),
                                ),
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('To'),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: selectedWeekDates.isNotEmpty
                              ? Text(
                                  DateFormat('yyyy-MM-dd').format(
                                      selectedWeekDates[
                                          selectedWeekDates.length - 1]),
                                )
                              : Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()),
                                ),
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                        onTap: () {
                          _openCalendarDialog(context);
                        },
                        child: const Icon(Icons.calendar_month))
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Staff Details',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                    Row(
                      children: [
                        const Text("Name :"),
                        Text(
                            "${capitalizeFirstLetter(widget.data.stafffirstname ?? "")} ${capitalizeFirstLetter(widget.data.stafflastname ?? "")}")
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Mobile ID :"),
                        Text('${widget.data.staffmobile ?? "N/A"}')
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Email :"),
                        Text('${widget.data.staffemail ?? "N/A"}')
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cost Rate',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                    Row(
                      children: [
                        const Text("Regular :"),
                        Text(
                            "${widget.data.chargerate}/${Provider.of<StaffProvider>(context, listen: false).costRateBy}")
                      ],
                    ),
                    const Row(
                      children: [Text("Over Time :"), Text("N/A")],
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(''),
                Row(
                  children: [
                    const Text(
                      'Exempt',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 8),
                    FlutterSwitch(
                      width: 40.0, // Adjust width to match design
                      height: 20.0, // Adjust height to match design
                      toggleSize: 20.0, // Adjust toggle size to match design
                      value: isExempt,
                      borderRadius: 30.0, // Rounded edges
                      padding: 2.0, // Padding to match the design
                      activeColor: Colors.green, // Green background when active
                      inactiveColor:
                          Colors.transparent, // Grey background when inactive
                      activeToggleColor:
                          Colors.white, // White toggle when active
                      inactiveToggleColor:
                          Colors.white, // White toggle when inactive
                      switchBorder: Border.all(
                        color: Colors.black, // Border around the switch
                        width: 1.0,
                      ),
                      toggleBorder: Border.all(
                        color:
                            Colors.green.shade300, // Border around the toggle
                        width: 3.0,
                      ),
                      onToggle: (value) {
                        setState(() {
                          isExempt = value;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              children: [
                Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Day of week",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ))),
                Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("Job Events",
                            style: TextStyle(fontWeight: FontWeight.w700)))),
                Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("Regular Hour",
                            style: TextStyle(fontWeight: FontWeight.w700)))),
                Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("Over Time Hour",
                            style: TextStyle(fontWeight: FontWeight.w700)))),
                Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Align(alignment: Alignment.center, child: Text("")))
              ],
            ),
          ),
          selectedWeekDates.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 100.0),
                  child: Center(child: Text("No Data")),
                )
              : Container(
                  child: Column(
                      children: selectedWeekDates.asMap().entries.map((e) {
                    // Initialize empty controllers for overtime
                    // addFieldsForDate(e.key);
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      color: blueShadedColors[e.key],
                      child: Row(
                        children: [
                          Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${DateFormat.EEEE().format(selectedWeekDates[e.key]).substring(0, 3)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ))),
                          Flexible(
                              flex: 5,
                              fit: FlexFit.tight,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Column(
                                      children: hourControllers[e.key]
                                          .asMap()
                                          .entries
                                          .map((e2) {
                                        return
                                            //  Text(
                                            //     '${hourControllers[e.key][e2.key].text.isEmpty ?? "data"}');
                                            Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: InkWell(
                                            onTap: () {
                                              // print(
                                              //     "tapped on container : ${}");
                                              context
                                                  .read<StaffProvider>()
                                                  .getJobNumberByDate(
                                                      date: DateFormat(
                                                              'yyyy-MM-dd')
                                                          .format(
                                                              selectedWeekDates[
                                                                  e.key]),
                                                      context: context)
                                                  .then((value) {
                                                //-------------------//
                                                if (Provider.of<StaffProvider>(
                                                        context,
                                                        listen: false)
                                                    .jobDetailsData
                                                    .isNotEmpty) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        child: StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                            return JobList(
                                                              date: DateFormat(
                                                                      'yyyy-MM-dd')
                                                                  .format(
                                                                      selectedWeekDates[
                                                                          e.key]),
                                                              jobDetailsData: Provider.of<
                                                                          StaffProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .jobDetailsData,
                                                              preSelectedIndex: Provider.of<
                                                                          StaffProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .jobEvents[e.key][e2.key],
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) {
                                                    // ignore: unnecessary_brace_in_string_interps
                                                    print(
                                                        "After pop showdialog val : ${value}");
                                                    print(
                                                        "selected jobs : ${Provider.of<StaffProvider>(context, listen: false).selectedJobs}");
                                                    if (value == true) {
                                                      Provider.of<StaffProvider>(
                                                              context,
                                                              listen: false)
                                                          .jobEvents[e.key]
                                                              [e2.key]
                                                          .clear();
                                                      Provider.of<StaffProvider>(
                                                              context,
                                                              listen: false)
                                                          .jobEvents[e.key]
                                                              [e2.key]
                                                          .addAll(Provider.of<
                                                                      StaffProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .selectedJobs);
                                                      setState(() {});
                                                    }
                                                  });
                                                } else {
                                                  Utils().ShowWarningSnackBar(
                                                      context,
                                                      'Job Not Assigned',
                                                      'msg');
                                                }
                                                //------------------//
                                                log(".then calling");
                                                setState(() {});
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 5.0,
                                                  vertical: 5.0),
                                              // key: ValueKey(value),
                                              height: 40,
                                              // width: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ListView.builder(
                                                      itemCount: Provider.of<
                                                                  StaffProvider>(
                                                              context,
                                                              listen: false)
                                                          .jobEvents[e.key]
                                                              [e2.key]
                                                          .length,
                                                      itemBuilder:
                                                          (context, idx) {
                                                        return Text(
                                                            '${Provider.of<StaffProvider>(context, listen: false).jobEvents[e.key][e2.key][idx]}',
                                                            style: const TextStyle(
                                                              color: Colors
                                                                  .blue, // Set text color to blue
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline, // Add underline
                                                            ));
                                                      },
                                                    ),
                                                  ),
                                                  const Icon(Icons.search)
                                                ],
                                              )
                                              //  Text(
                                              //     '${Provider.of<StaffProvider>(context, listen: false).jobEvents[e.key][e2.key]}')
                                              ,
                                              // child: ,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ))),
                          Flexible(
                              flex: 3,
                              fit: FlexFit.tight,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Column(
                                      children: hourControllers[e.key]
                                          .asMap()
                                          .entries
                                          .map((e2) {
                                        return
                                            //  Text(
                                            //     '${hourControllers[e.key][e2.key].text.isEmpty ?? "data"}');
                                            Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 2.0),
                                          child: Container(
                                            color: Colors.white,
                                            height: 40,
                                            // width: 40,
                                            child: TextField(
                                              onTapOutside: (event) {
                                                if (hourControllers[e.key]
                                                            [e2.key]
                                                        .text
                                                        .isNotEmpty &&
                                                    int.tryParse(
                                                            hourControllers[
                                                                        e.key]
                                                                    [e2.key]
                                                                .text) !=
                                                        null) {
                                                  setState(() {
                                                    hourControllers[e.key]
                                                                [e2.key]
                                                            .text =
                                                        '${hourControllers[e.key][e2.key].text}.0';
                                                    hourControllers[e.key]
                                                                [e2.key]
                                                            .selection =
                                                        TextSelection
                                                            .fromPosition(
                                                      TextPosition(
                                                          offset:
                                                              hourControllers[
                                                                          e.key]
                                                                      [e2.key]
                                                                  .text
                                                                  .length),
                                                    );
                                                  });
                                                }
                                                updateTotalTime();
                                              },
                                              onChanged: (value) {
                                                updateTotalTime();
                                              },
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                  RegExp(
                                                      r'^\d*\.?\d*'), // Regular expression to allow only numbers and one decimal point
                                                ),
                                              ],
                                              controller: hourControllers[e.key]
                                                  [e2.key],
                                              decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 5.0,
                                                          horizontal: 10.0),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  hintText: 'Hours'),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ))),
                          Flexible(
                              flex: 3,
                              fit: FlexFit.tight,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Column(
                                      children: overtimeControllers[e.key]
                                          .asMap()
                                          .entries
                                          .map((e2) {
                                        return
                                            //  Text(
                                            //     '${hourControllers[e.key][e2.key].text.isEmpty ?? "data"}');
                                            Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Container(
                                            color: Colors.white,
                                            height: 40,
                                            child: TextField(
                                              onTapOutside: (event) {
                                                if (overtimeControllers[e.key]
                                                            [e2.key]
                                                        .text
                                                        .isNotEmpty &&
                                                    int.tryParse(
                                                            overtimeControllers[
                                                                        e.key]
                                                                    [e2.key]
                                                                .text) !=
                                                        null) {
                                                  setState(() {
                                                    overtimeControllers[e.key]
                                                                [e2.key]
                                                            .text =
                                                        '${overtimeControllers[e.key][e2.key].text}.0';
                                                    overtimeControllers[e.key]
                                                                [e2.key]
                                                            .selection =
                                                        TextSelection
                                                            .fromPosition(
                                                      TextPosition(
                                                          offset:
                                                              overtimeControllers[
                                                                          e.key]
                                                                      [e2.key]
                                                                  .text
                                                                  .length),
                                                    );
                                                  });
                                                }
                                                updateTotalOvertime();
                                              },
                                              onChanged: (value) {
                                                updateTotalOvertime();
                                              },
                                              controller:
                                                  overtimeControllers[e.key]
                                                      [e2.key],
                                              decoration: const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 5.0,
                                                          horizontal: 10.0),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  hintText: 'Hours'),
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                  RegExp(
                                                      r'^\d*\.?\d*'), // Regular expression to allow only numbers and one decimal point
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ))),
                          Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: InkWell(
                                      onTap: () {
                                        addFieldsForDate(e.key);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: CircleAvatar(
                                          backgroundColor: Colors
                                              .black, // Background color of the circle
                                          radius: 24,
                                          child: Icon(
                                            Icons.add,
                                            size: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )))),
                        ],
                      ),
                    );
                  }).toList()),
                ),
          Visibility(
            visible: selectedWeekDates.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                children: [
                  const Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ))),
                  const Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("Total Hour :",
                              style: TextStyle(fontWeight: FontWeight.w700)))),
                  Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(child: Text('${totalHour}')),
                            ),
                          ))),
                  Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5)),
                              child:
                                  Center(child: Text('${totalOverTimeHour}')),
                            ),
                          ))),
                  const Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child:
                          Align(alignment: Alignment.center, child: Text("")))
                ],
              ),
            ),
          ),
          Visibility(
            visible: selectedWeekDates.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                children: [
                  const Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ))),
                  const Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("Cost Breakup :",
                              style: TextStyle(fontWeight: FontWeight.w700)))),
                  Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Text(
                                      '${totalHourTimeCost.toStringAsFixed(2)}')),
                            ),
                          ))),
                  Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Text(
                                      '${totalOverTimeCost.toStringAsFixed(2)}')),
                            ),
                          ))),
                  const Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child:
                          Align(alignment: Alignment.center, child: Text("")))
                ],
              ),
            ),
          ),
          Visibility(
            visible: selectedWeekDates.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                children: [
                  const Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ))),
                  const Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("Total Cost :",
                              style: TextStyle(fontWeight: FontWeight.w700)))),
                  Flexible(
                      flex: 6,
                      fit: FlexFit.tight,
                      child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: Text(
                                      '${(totalHourTimeCost + totalOverTimeCost).toStringAsFixed(2)}')),
                            ),
                          ))),
                  // Flexible(
                  //     flex: 3,
                  //     fit: FlexFit.tight,
                  //     child: Align(
                  //         alignment: Alignment.center,
                  //         child: Padding(
                  //           padding: EdgeInsets.symmetric(horizontal: 10.0),
                  //           child: Container(
                  //             height: 30,
                  //             decoration: BoxDecoration(
                  //                 border: Border.all(color: Colors.black),
                  //                 borderRadius: BorderRadius.circular(5)),
                  //             child: Center(
                  //                 child: Text(
                  //                     '${totalOverTimeCost.toStringAsFixed(2)}')),
                  //           ),
                  //         ))),
                  const Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child:
                          Align(alignment: Alignment.center, child: Text("")))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Visibility(
            visible: selectedWeekDates.isNotEmpty,
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Provider.of<StaffProvider>(context, listen: false)
                        .submitTimeSheetBill(
                      selectedWeekDates: selectedWeekDates,
                      hourControllers: hourControllers,
                      overtimeControllers: overtimeControllers,
                      weekStartDate:
                          DateFormat('yyyy-MM-dd').format(selectedWeekDates[0]),
                      weekEndDate: DateFormat('yyyy-MM-dd').format(
                          selectedWeekDates[selectedWeekDates.length - 1]),
                      weekNumber: getWeekNumber(selectedWeekDates.isNotEmpty
                          ? selectedWeekDates.first
                          : DateTime.now()),
                      timesheetBillNo: generateDynamicString(
                          selectedWeekDates, '${widget.data.stafflastname}'),
                      staffId: widget.data.staffid!,
                      isExempt: isExempt,
                      timeSheetStatus: 'active',
                      totalRegularHour: totalHour,
                      totalOvertimeHour: totalOverTimeHour,
                      totalRegularCost: totalHourTimeCost,
                      context: context,
                    );
                  },
                  child: const CustomButton(
                    title: 'Save',
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: const CustomButton(
                    title: 'Cancel',
                  ),
                ))
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Visibility(
            visible: selectedWeekDates.isNotEmpty,
            child: const Row(
              children: [
                Expanded(
                    child: CustomButton(
                  btnColor: Colors.green,
                  title: 'Submit',
                )),
                Expanded(
                    child: CustomDeleteButton(
                  title: 'Delete',
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
