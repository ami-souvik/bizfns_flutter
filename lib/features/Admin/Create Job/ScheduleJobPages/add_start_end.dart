import 'dart:convert';
import 'dart:developer';

import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/core/widgets/TimeJobScheduleListWidget/time_job_schedule_list.dart';
import 'package:bizfns/features/Admin/Create%20Job/ScheduleJobPages/recurring.dart';
import 'package:bizfns/features/Admin/Service/provider/service_provider.dart';
import 'package:bizfns/provider/job_schedule_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../../../core/common/Status.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../Material/provider/material_provider.dart';
import '../../Staff/provider/staff_provider.dart';
import '../api-client/schedule_api_client_implementation.dart';
import '../model/JobScheduleModel/job_schedule_response_model.dart';
import '../model/JobScheduleModel/schedule_list_response_model.dart';
import '../model/add_schedule_model.dart';
import '../repo/schedule_repo_implementaiton.dart';

class AddStartEnd extends StatefulWidget {
  const AddStartEnd({
    Key? key,
  }) : super(key: key);

  @override
  State<AddStartEnd> createState() => _AddStartEndState();
}

class _AddStartEndState extends State<AddStartEnd> {
  /*var startDate = DateTime.now();
  var endDate = DateTime.now();*/
  DateTime? startDateTime, startDate, endDate;

  AddScheduleModel model = AddScheduleModel.addSchedule;

  // bool isRecurring = false;

  late JobScheduleProvider timeScheduleController;

  var _selectedStartTime;

  List<ScheduleData> scheduleList = [];

  int duration = 0;
  List xx = [];

  String? st;
  String? et;
  String? sd;
  String? ed;
  List<String?> timeList = [];

  int? interval;

  String addSecondsToTime(String timeWithoutSeconds) {
    // Parse the time without seconds
    DateTime parsedTime = DateFormat("hh:mm a").parse(timeWithoutSeconds);

    // Format the time to include seconds
    return DateFormat("hh:mm:ss a").format(parsedTime);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<TitleProvider>(context, listen: false).title =
        'Schedule New Modify';
    timeScheduleController =
        Provider.of<JobScheduleProvider>(context, listen: false);

    scheduleList = (timeScheduleController.items);
    timeList = timeScheduleController.items!
        .map((e) => e.time)
        .toList()
        .where((element) => isAfter(timeScheduleController.date, element!))
        .toList();

    interval = getInterval();

    duration = getDuration(timeScheduleController.items);
    st = model.startTime;
    et = model.endTime;
    sd = model.startDate;
    ed = model.endDate;
    if (model.totalJobs != null) {
      if (model.totalJobs!.isNotEmpty) {
        Provider.of<ServiceProvider>(context, listen: false).isRecurring = true;
      }
    }

    if (model.recurSelectedDate != null) {
      if (model.recurSelectedDate!.isNotEmpty) {
        Provider.of<ServiceProvider>(context, listen: false).isRecurring = true;
      }
    }
  }

  AddScheduleModel loadPrevData(BuildContext context) {
    ScheduleModel schedule = timeScheduleController
            .items[Provider.of<JobScheduleProvider>(context, listen: false)
                .timeIndex]
            .schedule![
        Provider.of<JobScheduleProvider>(context, listen: false).jobIndex];

    //Schedule? schedule = Provider.of<JobScheduleProvider>(context,listen: false).schedule;

    model.isAdding = false;
    model.jobId = schedule.pKJOBID;

    model.startTime = schedule.jOBSTARTTIME;
    model.endTime = schedule.jOBENDTIME;

    model.jobStatus = int.parse(schedule.jOBSTATUS ?? "0");

    //todo: Implement Later model.serviceEntityID = '2';

    model.customer = schedule.customersList!
        .map((e) => CustomerData(
            customerId: e.pKCUSTOMERID.toString(),
            customerName: '${e.cUSTOMERFIRSTNAME} ${e.cUSTOMERLASTNAME}',
            serviceEntityId: e.serviceEntityList!
                .map((e) => e.pKSERVICEENTITY.toString())
                .toList(),
            serviceEntityName: e.serviceEntityList!
                .map((e) => e.sERVICEENTITYNAME.toString())
                .toList()))
        .toList();

    ///todo: load staff
    ///
    ///
    if (Provider.of<StaffProvider>(context, listen: false).loading == false) {
      Utils().printMessage('Not loading');
      if (Provider.of<StaffProvider>(context, listen: false)
          .staffList!
          .isNotEmpty) {
        Utils().printMessage('Not Empty');

        ///todo load all staffs
        ///
        List<int> staffIDs =
            schedule.staffList!.map((e) => e.pKUSERID ?? 0).toList();
        List<int> staffIDList =
            Provider.of<StaffProvider>(context, listen: false)
                .staffList!
                .map((e) => int.parse(e.staffId))
                .toList();
        List<String> staffNames = Provider.of<StaffProvider>(context,
                listen: false)
            .staffList!
            .map((e) =>
                '${e.staffFirstName.capitalizeFirst} ${e.staffLastName.capitalizeFirst}')
            .toList();

        List<StaffID> staffList = [];

        for (var element in staffIDs) {
          staffList.add(StaffID(
            index: staffIDList.indexOf(element),
            id: element.toString(),
            staffName: staffNames[staffIDList.indexOf(element)],
          ));
        }

        model.staffList = staffList;

        setState(() {});
      } else {
        Utils().printMessage('Empty');
      }
    } else {
      Utils().printMessage('loading');
    }

    ///todo: load materials
    ///
    ///
    if (Provider.of<MaterialProvider>(context, listen: false).loading ==
        false) {
      Utils().printMessage('Not loading');
      if (Provider.of<MaterialProvider>(context, listen: false)
          .materialList
          .isNotEmpty) {
        Utils().printMessage('Not Empty');

        List<int> materialIDs =
            schedule.jOBMATERIAL == null || schedule.jOBMATERIAL!.isEmpty
                ? []
                : schedule.jOBMATERIAL!
                    .map((e) => int.parse(e.pKMATERIALID!.toString()))
                    .toList();

        List<int> materialIDList =
            Provider.of<MaterialProvider>(context, listen: false)
                .materialList
                .map((e) => e.materialId!)
                .toList();

        List<String> materialNames =
            Provider.of<MaterialProvider>(context, listen: false)
                .materialList
                .map((e) => e.materialName!.capitalizeFirst!)
                .toList();

        List<MaterialList> materialList = [];

        for (var element in materialIDs) {
          materialList.add(MaterialList(
            index: materialIDList.indexOf(element),
            materialID: element.toString(),
            materialName: materialNames[materialIDList.indexOf(element)],
          ));
        }

        model.materialList = materialList;

        setState(() {});
      } else {
        model.materialList = [];
        Utils().printMessage('Material Empty');
      }
    } else {
      Utils().printMessage('loading');
    }

    ///todo: load services
    ///
    ///
    if (Provider.of<ServiceProvider>(context, listen: false).loading == false) {
      Utils().printMessage('Not loading');
      if (Provider.of<ServiceProvider>(context, listen: false)
          .allServiceList
          .isNotEmpty) {
        Utils().printMessage('Not Empty');

        ///todo get service from schedule model
        ///
        List<int> serviceIDs =
            schedule.serviceList!.map((e) => e.iD ?? 0).toList();
        List<int> serviceIDList =
            Provider.of<ServiceProvider>(context, listen: false)
                .allServiceList
                .map((e) => e.serviceId!)
                .toList();

        List<String> serviceNames =
            Provider.of<ServiceProvider>(context, listen: false)
                .allServiceList
                .map((e) => e.serviceName!.capitalizeFirst!)
                .toList();

        List<ServiceList> serviceList = [];

        for (var element in serviceIDs) {
          serviceList.add(ServiceList(
            index: serviceIDList.indexOf(element),
            serviceID: element.toString(),
            serviceName: serviceNames[serviceIDList.indexOf(element)],
          ));
        }

        model.serviceList = serviceList;

        setState(() {});
      } else {
        Utils().printMessage(' Service Empty');
      }
    } else {
      Utils().printMessage('loading');
    }

    return model;
  }


  getInterval(){
    List<String?> items = timeScheduleController.items!
        .map((e) => e.time).toList();

    String? time1 = items[0];
    String? time2 = items[1];

    int min1 = int.tryParse(time1!.split(":")[0])! * 60 + int.tryParse(time1!.split(":")[1])!;

    int min2 = int.tryParse(time2!.split(":")[0])! * 60 + int.tryParse(time1!.split(":")[1])!;

    return min2 - min1;
  }

  String convertTo24HourFormat(String time) {
    try {
      // Ensure the time string is trimmed to remove any leading/trailing spaces
      time = time.trim();
      // log("addSchedule.startTime : ${addSchedule.startTime}");
      // Print input to debug
      log('Input time: $time');

      // Define the input and output formats
      DateFormat inputFormat = DateFormat("hh:mm a");
      DateFormat outputFormat = DateFormat("HH:mm");

      // Parse the time string using the input format
      DateTime parsedTime = inputFormat.parse(time);

      // Format the parsed DateTime object to 24-hour format
      String convertedTime = outputFormat.format(parsedTime);

      // Print output to debug
      print('Converted time: $convertedTime');

      return convertedTime;
    } catch (e) {
      // Handle errors by printing them and returning an error message
      print('Error: $e');
      return "Invalid time format";
    }
  }

  bool isAfter(String date, String time) {
    // Parse the date string and format it to a consistent YYYY-MM-DD format
    String _date = date.length >= 10
        ? '${DateTime.parse(date).year}-${DateTime.parse(date).month.toString().padLeft(2, '0')}-${DateTime.parse(date).day.toString().padLeft(2, '0')}'
        : date;

    // Extract year, month, and day from the formatted date string
    int year = int.parse(_date.split('-')[0]);
    int month = int.parse(_date.split('-')[1]);
    int day = int.parse(_date.split('-')[2]);

    // Split the time into hours, minutes, and period (AM/PM)
    List<String> timeParts = time.split(' ');
    List<String> hourMinuteParts = timeParts[0].split(':');
    String period = timeParts[1];

    // Convert the hour to 24-hour format if necessary
    int hour = int.parse(hourMinuteParts[0]);
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    // Extract minutes from the time string
    int minute = int.parse(hourMinuteParts[1]);

    // Create a DateTime object with the provided date and time
    DateTime selected = DateTime(year, month, day, hour, minute);

    // Compare the selected DateTime with the current DateTime
    return selected.isAfter(DateTime.now());
  }

  // String getTime(String timeData) {
  //   int _hour = int.parse(timeData.split(':')[0]);
  //   int _minute = int.parse(timeData.split(':')[1]);
  //
  //   String hour = _hour < 10 ? "0$_hour" : _hour.toString();
  //   String minute = _minute < 10 ? "0$_minute" : _minute.toString();
  //
  //   String timeOfDay = int.parse(hour) >= 12 ? "PM" : "AM";
  //
  //   return '$hour:$minute $timeOfDay';
  // }

  // getTimeFormat(String value) {
  //   String time = value.split(" ")[0];
  //
  //   String hour = int.parse(time.split(":")[0]) > 12
  //       ? '${int.parse(time.split(":")[0]) - 12}'
  //       : time.split(":")[0];
  //
  //   String minute = time.split(":")[1];
  //
  //   String timeOfDay = int.parse(time.split(":")[0]) >= 12 ? "PM" : "AM";
  //
  //   String resHour = hour.length < 2 ? '0$hour' : hour;
  //   String resMinute = minute.length < 2 ? '0$minute' : minute;
  //
  //   String resTime = '$resHour:$resMinute $timeOfDay';
  //
  //   return resTime;
  // }

  String endTime(String timeData, int duraiton) {
    // log("GEtting timeData : ${timeData}");
    // int _hour = int.parse(timeData.split(':')[0]) + duraiton;
    // int _minute = int.parse(timeData.split(':')[1]);

    // String hour = _hour < 10 ? "0$_hour" : _hour.toString();
    // String minute = _minute < 10 ? "0$_minute" : _minute.toString();

    // String timeOfDay = int.parse(hour) >= 12 ? "PM" : "AM";

    // return '$hour:$minute $timeOfDay';
    // Parse the time string using DateFormat
    DateTime parsedTime = DateFormat("hh:mm:ss a").parse(timeData);

    // Add the duration (in hours)
    DateTime newTime = parsedTime.add(Duration(hours: duration));

    // Format the time to the desired output without seconds
    String formattedTime = DateFormat("hh:mm a").format(newTime);

    return formattedTime;
  }

  int getDuration(List<ScheduleData> schedule) {
    print('Schedule length: ${schedule.length}');

    if (schedule.isEmpty) {
      return 1;
    } else if (schedule.length == 1) {
      return 1;
    } else {
      print('Schedule');
      print(schedule[0].time!);

      int _hour = int.parse(schedule[0].time!.split(':')[0]);
      int _nextHour = int.parse(schedule[1].time!.split(':')[0]);

      print('Hour: $_hour Next Hour: $_nextHour');

      return _nextHour - _hour;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String formattedDate = DateFormat('yyyy-MM-dd').format(getDateTime());
    print("abcvsf :$formattedDate");

    Utils().printMessage(Provider.of<RecurringNotifier>(context, listen: false)
        .value
        .toString());

    // List<String> end = widget.time.split(" ");
    // double.tryParse(end[0]);

    //Utils().printMessage("<><><>${(int.parse(end[0].split(":")[0]) + 1)}");

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        color: Color(0xFFFFFF),
      ),
      height: size.height / 2, //1.6
      width: size.width / 1.2,
      child: Column(
        children: [
          Container(
            // width: size.w,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 55,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              color: AppColor.APP_BAR_COLOUR,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Add Start-End",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // loadPrevData(context);
                    model.startTime = st;
                    model.endTime = et;
                    model.startDate = sd;
                    model.endDate = ed;
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 22,
                    width: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.clear_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Gap(15),
          Expanded(
              child: ListView(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            children: [
              /*const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "All Day",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              // Gap(10.ss),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    //hintText: 'Enter a search term',
                  ),
                ),
              ),*/
              const Gap(15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Start Day",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Gap(4.ss),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            await _selectDate(context);
                            //timeList!.clear();
                            setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 0.5), //(x,y)
                                    blurRadius: 0.2,
                                  ),
                                ],
                                color: Colors.white),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                DateFormat.yMMMEd()
                                    .format(startDateTime ?? getDateTime()),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Gap(10),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 0.5), //(x,y)
                                    blurRadius: 0.2,
                                  ),
                                ],
                                color: Colors.white),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: DropdownButton(
                                key: ValueKey(
                                    DateTime.now().microsecondsSinceEpoch),
                                underline: Text(''),
                                icon: Icon(Icons.keyboard_arrow_down),
                                hint: Text(
                                  '${getTimeFormat(model.startTime!)}',
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: TextStyle(
                                  color: Colors.white30,
                                ),
                                isExpanded: true,
                                value: _selectedStartTime,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedStartTime = newValue;
                                    print("type---->${_selectedStartTime}");
                                    // model.startTime = _selectedStartTime;
                                    model.startTime = _selectedStartTime;
                                    log("model.startTime---->${model.startTime}");
                                    model.endTime = addSecondsToTime(
                                        endTime(_selectedStartTime, duration));
                                    log("model.endtime -------> ${model.endTime}");
                                  });
                                },
                                items: timeList.map((val) {
                                  return DropdownMenuItem(
                                    value: val,
                                    child: Text(getTimeFormat(val.toString()),
                                        style: const TextStyle(
                                            color: Colors.black)),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                  ],
                ),
              ),
              const Gap(15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "End Day",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Gap(4.ss),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 0.5), //(x,y)
                                  blurRadius: 0.2,
                                ),
                              ],
                              color: Colors.white),
                          child: InkWell(
                            onTap: startDateTime == null
                                ? null
                                : () async {
                                    await _selectDate(context);
                                  },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                DateFormat.yMMMEd()
                                    .format(endDateTime ?? getDateTime()),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Gap(10),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 0.5), //(x,y)
                                    blurRadius: 0.2,
                                  ),
                                ],
                                color: Colors.white),
                            child: InkWell(
                              onTap: startDateTime == null
                                  ? null
                                  : () async {
                                      await _selectDate(context);
                                    },
                              child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text(
                                    getTimeFormat(model.endTime!),
                                    //"${(int.parse(end[0].split(":")[0])+1)}:00 AM",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    )
                        // Container(
                        //   alignment: Alignment.centerLeft,
                        //   height: 55,
                        //   // width: size.width / 1.7,
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(8),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey,
                        //           offset: Offset(0.0, 0.5), //(x,y)
                        //           blurRadius: 0.2,
                        //         ),
                        //       ],
                        //       color: Colors.white),
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 8.0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //       children: [
                        //         InkWell(
                        //           onTap: startDateTime == null
                        //               ? null
                        //               : () async {
                        //                   await _selectDate(context);
                        //                 },
                        //           child: Text(
                        //             DateFormat.yMMMEd()
                        //                 .format(endDateTime ?? getDateTime()),
                        //             style: const TextStyle(
                        //                 color: Colors.grey,
                        //                 fontWeight: FontWeight.bold),
                        //           ),
                        //         ),
                        //         Text(
                        //           getTimeFormat(model.endTime!),
                        //           //"${(int.parse(end[0].split(":")[0])+1)}:00 AM",
                        //           style: const TextStyle(
                        //               color: Colors.grey,
                        //               fontWeight: FontWeight.bold),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        ),
                    const Gap(5),
                    // GestureDetector(
                    //   onTap: startDateTime == null
                    //       ? null
                    //       : () async {
                    //           await _selectDate(context);
                    //         },
                    //   child: Container(
                    //       alignment: Alignment.center,
                    //       height: 55,
                    //       width: size.width / 7.0,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(8),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.grey,
                    //             offset: Offset(1.5, 1.5), //(x,y)
                    //             blurRadius: 01,
                    //           ),
                    //         ],
                    //         color: Colors.white,
                    //       ),
                    //       child: const Icon(
                    //         Icons.calendar_month_outlined,
                    //         color: Colors.black,
                    //         size: 30,
                    //       )),
                    // ),
                  ],
                ),
              ),
              const Gap(15),
              /*GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  showRecurringDialog();
                },
                child: const Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: CustomButton(
                      title: 'Recurring',
                    ),
                  ),
                ),
              ),*/
              // model.jobId == null
              //     ?
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Consumer<RecurringNotifier>(
                      builder: (context, recurringNotifier, child) {
                    return Row(
                      children: [
                        Text(
                          'Recurring: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        CupertinoSwitch(
                          activeColor: AppColor.APP_BAR_COLOUR,
                          thumbColor: Colors.white,
                          value: recurringNotifier.getValue,
                          onChanged: (val) {
                            recurringNotifier.setValue = val;
                            if (val) {
                              Provider.of<ServiceProvider>(context,
                                      listen: false)
                                  .isRecurring = true;
                            } else {
                              Provider.of<ServiceProvider>(context,
                                      listen: false)
                                  .isRecurring = false;

                              setState(() {});
                              //
                            }
                          },
                        ),
                      ],
                    );
                  })),
              // : SizedBox(),
              const Gap(10),
              GestureDetector(
                onTap: () {
                  // call save job api
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Consumer<RecurringNotifier>(
                      builder: (BuildContext context, recurringNotifier,
                          Widget? child) {
                        return InkWell(
                          child: CustomButton(
                            title: recurringNotifier.getValue
                                ? 'Recurring'
                                : 'Save',
                          ),
                          onTap: () {
                            if (!recurringNotifier.getValue) {
                              print("recurring hitting");
                              Provider.of<JobScheduleProvider>(context,
                                      listen: false)
                                  .deleteRecurrDate(context);
                              model.totalJobs = "1";
                              if (Provider.of<ServiceProvider>(context,
                                          listen: false)
                                      .isRecurring ==
                                  false) {
                                model.totalJobs = null;
                                model.duration = null;
                                model.recurrType = null;
                                model.recurSelectedDate = null;
                                model.isRecurSelectionIsFromCalender = null;
                              }

                              if (model.staffList != null) {
                                context.pop('edit-staff');
                              } else {
                                context.pop();
                              }
                            } else {
                              showRecurringDialog();
                            }
                            //context.pop();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              Gap(10.ss),
            ],
          )),
        ],
      ),
    );
  }

  void showRecurringDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child:
                StatefulBuilder(// You need this, notice the parameters below:
                    builder: (BuildContext context, StateSetter setState) {
              return const Recurring();
            }));
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          // text=value;
        });
      }
    });
  }

  DateTime? endDateTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        currentDate: DateTime.now(),
        initialDate: getDateTime(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));

    // print(picked!.day);

    if (picked != null) {
      setState(() {
        startDateTime = picked;
        endDateTime = picked;

        String day = picked.day < 10 ? '0${picked.day}' : picked.day.toString();

        DateFormat formatter = DateFormat('yyyy-MM-dd');
        model.startDate = formatter.format(picked);
        model.endDate = formatter.format(picked);
        log("Model.startDay : ${model.startDate}");
      });

      DateTime currentDate = DateTime.now();

      await getScheduleList(DateFormat('yyyy-MM-dd').format(picked));

      if (picked.year != currentDate.year ||
          picked.month != currentDate.month ||
          picked.day != currentDate.day) {
        //resetTiming();
      }

      setState(() {});
    }
  }

  final ScheduleRepoImplementation scheduleRepo =
      ScheduleRepoImplementation(apiClient: ScheduleAPIClientImpl());

  List<ScheduleData> items = [];

  getScheduleList(String date) async {
    Utils().printMessage("==get Schedule Api Call of Date gsl: $date==");
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    /*List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();*/
    String? companyId = await GlobalHandler.getCompanyId();
    Utils().printMessage("CompanyId ==>${companyId!}");
    print('Selected Date: $date');
    await scheduleRepo.getSchedule(date: date).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        try {
          if (value.data != null) {
            ScheduleListResponseModel resp =
                value.data as ScheduleListResponseModel;

            // try {
            List<ScheduleData> list = resp.data!;
            // if (list != null) {
            print('Length: ${list.length}');
            print('Response Length: ${resp.data!.length}');
            items.clear();
            for (int index = 0; index < list.length; index++) {
              print('Schedule Time: ${list[index].time}');
              if (list[index].time != null) {
                items.add(
                  ScheduleData(
                    time: list[index].time ?? "",
                    schedule: list[index].schedule ?? [],
                  ),
                );
              }
            }

            if (DateFormat('yyyy-MM-dd').format(DateTime.now()) == date) {
              timeList = items!
                  .map((e) => e.time)
                  .toList()
                  .where((element) =>
                      isAfter(timeScheduleController.date, element!))
                  .toList();
            } else {
              timeList = items.map((e) => e.time!).toList();
            }

            interval = getInterval();

            setState(() {});
          }
        } catch (e) {
          Utils().printMessage("STATUS Failure ==>>> " + e.toString());
        }
      } else {}
    }, onError: (err) {
      Utils().printMessage("STATUS ERROR-> $err");
    });
    EasyLoading.dismiss();

    print('Job Schedule has been fetched');

    // notifyListeners();
  }

  resetTiming() {
    timeList = timeScheduleController.items!.map((e) => e.time).toList();
    setState(() {});
  }

  DateTime getDateTime() {
    //String date = Provider.of<JobScheduleProvider>(context, listen: false).date;

    String date = model.startDate!;

    String _date = date.length > 10 ? date.split(" ")[0] : date;

    int year = int.parse(_date.split('-')[0]);
    int month = int.parse(_date.split('-')[1]);
    int day = int.parse(_date.split('-')[2]);

    setState(() {
      startDate = DateTime(year, month, day);
      endDate = DateTime(year, month, day);
    });

    return DateTime(year, month, day);
  }

  getTimeFormat(String value) {
    // print('Here: $value');

    // String time = value.split(" ")[0];

    // String hour = int.parse(time.split(":")[0]) > 12
    //     ? '${int.parse(time.split(":")[0]) - 12}'
    //     : time.split(":")[0];

    // String minute = time.split(":")[1];

    // String timeOfDay = int.parse(time.split(":")[0]) >= 12 ? "PM" : "AM";

    // String resHour = hour.length < 2 ? '0$hour' : hour;
    // String resMinute = minute.length < 2 ? '0$minute' : minute;

    // String resTime = '$resHour:$resMinute $timeOfDay';

    // return resTime;
    try {
      // Parse the time string using DateFormat
      DateTime parsedTime = DateFormat("hh:mm:ss a").parse(value);

      // Format the time to the desired output without seconds
      String formattedTime = DateFormat("hh:mm a").format(parsedTime);

      return formattedTime;
    } catch (e) {
      // Handle any parsing errors
      print('Error formatting time: $e');
      return value; // Return the original string if parsing fails
    }
  }
}

class RecurringNotifier extends ChangeNotifier {
  bool value = AddScheduleModel.addSchedule.totalJobs == null ||
          AddScheduleModel.addSchedule.totalJobs == ''
      ? false
      : int.parse(AddScheduleModel.addSchedule.totalJobs!) > 1;

  bool get getValue => value;

  set setValue(bool newValue) {
    value = newValue;
    notifyListeners();
  }
}
