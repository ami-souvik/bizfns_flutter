import 'dart:developer';

import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/add_schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../../provider/job_schedule_controller.dart';

class Recurring extends StatefulWidget {
  const Recurring({Key? key}) : super(key: key);

  @override
  State<Recurring> createState() => _RecurringState();
}

class _RecurringState extends State<Recurring> {
  List recurringData = [
    "Daily",
    "Weekly",
    "Monthly",
    "Yearly",
  ];

  List stopOnData = [
    "Date (Specific Stop Date)",
    "Number of Jobs (Repetition Limit)",
    "Never (Continuous)",
  ];

  List<String> weekDay = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
  ];

  List<String> weeks = [
    "1st",
    "2nd",
    "3rd",
    "4th",
  ];

  List<int> duration = [1, 7, 30, 90, 365];

  List selectData = [0];

  bool showSelection = false;

  String dropDownValue = "Daily";

  String spotOnDropDownValue = "Date (Specific Stop Date)";

  String weekValue = "1st";

  String dayValue = "Mon";

  AddScheduleModel model = AddScheduleModel.addSchedule;

  String selectedDate = '';

  DateTime? startDateTime, startDate, endDate;

  @override
  void initState() {
    Provider.of<TitleProvider>(context, listen: false).title =
        'Schedule New Modify';
    _jobController.text = model.totalJobs ?? "";
    _jobController.selection = TextSelection.fromPosition(
      TextPosition(offset: _jobController.text.length),
    );
    dropDownValue = model.recurrType ?? "Daily";
    weekValue = model.weekNumber == null
        ? "1st"
        : model.weekNumber == '0'
            ? '1st'
            : model.weekNumber == '1'
                ? '2nd'
                : model.weekNumber == '2'
                    ? '3rd'
                    : '4th';
    if (model.totalJobs != null) {
      model!.totalJobs!.isNotEmpty
          ? spotOnDropDownValue = "Number of Jobs (Repetition Limit)"
          : spotOnDropDownValue = "";
    }
    if (model.recurrType != null) {
      dropDownValue = model.recurrType!;
    }

    if (model.isRecurSelectionIsFromCalender != null) {
      if (model.isRecurSelectionIsFromCalender == true) {
        spotOnDropDownValue = "Date (Specific Stop Date)";
        selectedDate = model.recurSelectedDate!;
        _jobController.text = "0";
      }
    }

    setState(() {});
    super.initState();
  }

  String formatDate(String dateString) {
    // Parse the input date string to a DateTime object
    DateTime date = DateTime.parse(dateString);

    // Format the date using DateFormat
    String formattedDate = DateFormat.yMMMMd().format(date);

    return formattedDate;
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

  Future<void> _selectDate(BuildContext context) async {

    DateTime getInitialDate() {
    if (selectedDate != null && selectedDate.isNotEmpty) {
      // Parse the selectedDate string in the same format it is stored
      return DateFormat('MMM d, y').parse(selectedDate);
    } else {
      return getDateTime();
    }
  }
    
    final DateTime? picked = await showDatePicker(
        context: context,
        currentDate: DateTime.now(),
        initialDate: getInitialDate(),
        firstDate: DateTime.now(), //DateTime(2015, 8),
        lastDate: DateTime(2101));

    // print(picked!.day);
    String formatDate(DateTime picked) {
      String formattedDate = DateFormat('MMM d, y').format(picked);
      return formattedDate;
    }

    String formattedDateForModel(DateTime picked) {
      String formattedDateForModel = DateFormat('yyyy-MM-dd').format(picked);
      return formattedDateForModel;
    }

    if (picked != null) {
      setState(() {
        selectedDate = formatDate(picked);
        model.jobStopDate = formattedDateForModel(picked);
        print("jobStopDate======>${model.jobStopDate}");
      });
    }
  }

  TextEditingController _jobController = TextEditingController();

  @override
  void dispose() {
    _jobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var borderDecoration = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
      borderSide: BorderSide(
        color: AppColor.APP_BAR_COLOUR,
      ),
    );

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          // borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: Color(0xFFFFFF),
        ),
        // color: Color(0xFFFFFF),
        // height: size.height / 1.5,
        // width: size.width / 1.2,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Recurring",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _jobController.text = "";
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'Select Frequency',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.APP_BAR_COLOUR,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonFormField<String>(
                    value: dropDownValue,
                    decoration: InputDecoration(
                      enabled: true,
                      enabledBorder: borderDecoration,
                      focusedBorder: borderDecoration,
                      border: borderDecoration,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                    elevation: 16,
                    style: const TextStyle(color: AppColor.APP_BAR_COLOUR),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropDownValue = value!;
                        // model.recurrType = value;
                        // print(
                        //     "select Frequency dropdown val ===>${model.recurrType}");
                        // if (model.recurrType == "Daily" ||
                        //     model.recurrType == "Weekly") {
                        //   model.weekNumber = '0';
                        // }
                      });
                    },
                    items: recurringData.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                // Gap(10),
                Offstage(
                  offstage:
                      dropDownValue == "Daily" || dropDownValue == "Weekly",
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Week',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.APP_BAR_COLOUR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: DropdownButtonFormField<String>(
                              value: weekValue,
                              decoration: InputDecoration(
                                enabled: true,
                                enabledBorder: borderDecoration,
                                focusedBorder: borderDecoration,
                                border: borderDecoration,
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                              ),
                              elevation: 16,
                              style: const TextStyle(
                                  color: AppColor.APP_BAR_COLOUR),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  weekValue = value!;
                                });
                              },
                              items:
                                  weeks.map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          /*SizedBox(
                        width: 120,
                        child: DropdownButtonFormField<String>(
                          value: dayValue,
                          decoration: InputDecoration(
                            enabled: true,
                            enabledBorder: borderDecoration,
                            focusedBorder: borderDecoration,
                            border: borderDecoration,
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                          ),
                          elevation: 16,
                          style: const TextStyle(color: AppColor.APP_BAR_COLOUR),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dayValue = value!;
                            });
                          },
                          items: weekDay.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )*/
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(15),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Stop On',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.APP_BAR_COLOUR,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonFormField<String>(
                    value: spotOnDropDownValue,
                    decoration: InputDecoration(
                      enabled: true,
                      enabledBorder: borderDecoration,
                      focusedBorder: borderDecoration,
                      border: borderDecoration,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                    elevation: 16,
                    style: const TextStyle(color: AppColor.APP_BAR_COLOUR),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        spotOnDropDownValue = value!;
                        print("stopOnValue=====>$spotOnDropDownValue");

                        // model.recurrType = value;
                      });
                    },
                    items: stopOnData.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Gap(15),
                spotOnDropDownValue == "Date (Specific Stop Date)"
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Please select Date:",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColor.APP_BAR_COLOUR,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                  selectedDate,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await _selectDate(context);
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 55,
                                      width: size.width / 7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(1.5, 1.5), //(x,y)
                                            blurRadius: 01,
                                          ),
                                        ],
                                        color: Colors.white,
                                      ),
                                      child: const Icon(
                                        Icons.calendar_month_outlined,
                                        color: Colors.black,
                                        size: 30,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : spotOnDropDownValue == "Number of Jobs (Repetition Limit)"
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select No. of Jobs',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColor.APP_BAR_COLOUR,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(2),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _jobController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    signed: true,
                                    decimal: false,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'No of Jobs',
                                    border: borderDecoration,
                                    enabledBorder: borderDecoration,
                                    focusedBorder: borderDecoration,
                                    enabled: true,
                                  ),
                                  onChanged: (val) {
                                    setState(() {});
                                    // model.totalJobs = val;
                                  },
                                  validator: (value) {
                                    if (value == "0" ||
                                        value == ',' ||
                                        value == ".") {
                                      return "Select No of Jobs Should be Min 1";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        : Text(""),
                Gap(15),
                // Offstage(
                //   offstage: dropDownValue == "Daily" || dropDownValue == "Weekly",
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 10),
                //     child: SizedBox(
                //       height: 70,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             'Select Week',
                //             style: TextStyle(
                //               fontSize: 14,
                //               color: AppColor.APP_BAR_COLOUR,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           SizedBox(
                //             width: 120,
                //             child: DropdownButtonFormField<String>(
                //               value: weekValue,
                //               decoration: InputDecoration(
                //                 enabled: true,
                //                 enabledBorder: borderDecoration,
                //                 focusedBorder: borderDecoration,
                //                 border: borderDecoration,
                //               ),
                //               icon: const Icon(
                //                 Icons.keyboard_arrow_down,
                //               ),
                //               elevation: 16,
                //               style: const TextStyle(color: AppColor.APP_BAR_COLOUR),
                //               onChanged: (String? value) {
                //                 // This is called when the user selects an item.
                //                 setState(() {
                //                   weekValue = value!;
                //                   model.weekNumber = weeks.indexOf(value).toString();
                //                 });
                //               },
                //               items: weeks.map<DropdownMenuItem<String>>((value) {
                //                 return DropdownMenuItem<String>(
                //                   value: value,
                //                   child: Text(value),
                //                 );
                //               }).toList(),
                //             ),
                //           ),
                //           /*SizedBox(
                //             width: 120,
                //             child: DropdownButtonFormField<String>(
                //               value: dayValue,
                //               decoration: InputDecoration(
                //                 enabled: true,
                //                 enabledBorder: borderDecoration,
                //                 focusedBorder: borderDecoration,
                //                 border: borderDecoration,
                //               ),
                //               icon: const Icon(
                //                 Icons.keyboard_arrow_down,
                //               ),
                //               elevation: 16,
                //               style: const TextStyle(color: AppColor.APP_BAR_COLOUR),
                //               onChanged: (String? value) {
                //                 // This is called when the user selects an item.
                //                 setState(() {
                //                   dayValue = value!;
                //                 });
                //               },
                //               items: weekDay.map<DropdownMenuItem<String>>((value) {
                //                 return DropdownMenuItem<String>(
                //                   value: value,
                //                   child: Text(value),
                //                 );
                //               }).toList(),
                //             ),
                //           )*/
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                /*Expanded(
              flex: 2,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: recurringData.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectData[0] = index;
                      showSelection = !showSelection;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 6.0),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: selectData[0] == index
                            ? AppColor.APP_BAR_COLOUR
                            : const Color(0xFFCCEEF7),
                      ),
                      child: Text(
                        recurringData[index],
                        style: TextStyle(
                            color: selectData[0] == index
                                ? Colors.white
                                : Colors.black,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),*/
                const Gap(15),
                Expanded(
                  flex: showSelection ? 1 : 0,
                  child: Offstage(
                    offstage: !showSelection,
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                ),
                const Gap(10),
                GestureDetector(
                  onTap: () {
                    print("_jobController.text--->${_jobController.text}");
                    if (spotOnDropDownValue == "Date (Specific Stop Date)" &&
                            selectedDate.isNotEmpty ||
                        _jobController.text != "" &&
                            _jobController.text != "0" &&
                            _jobController.text != "." &&
                            _jobController.text != ",") {
                      if (spotOnDropDownValue == "Date (Specific Stop Date)" ||
                          spotOnDropDownValue == 'Never (Continuous)') {
                        _jobController.clear();
                        model.totalJobs = "1";
                      } else {
                        model.jobStopDate = "";
                      }
                      if (spotOnDropDownValue == "Date (Specific Stop Date)" &&
                          selectedDate != null &&
                          selectedDate.isNotEmpty) {
                        model.isRecurSelectionIsFromCalender = true;
                        model.recurSelectedDate = selectedDate;
                      } else {
                        model.isRecurSelectionIsFromCalender = null;
                        model.recurSelectedDate = null;
                      }
                      // spotOnDropDownValue == "Date (Specific Stop Date)" &&
                      //         selectedDate != null &&
                      //         selectedDate.isNotEmpty
                      //     ? model.isRecurSelectionIsFromCalender = true
                      //     : model.isRecurSelectionIsFromCalender = null;
                      model.recurrType = dropDownValue;
                      model.weekNumber = weeks.indexOf(weekValue).toString();
                      print(
                          "select Frequency dropdown val ===>${model.recurrType}");
                      if (model.recurrType == "Daily" ||
                          model.recurrType == "Weekly") {
                        model.weekNumber = '0';
                      }
                      int index = selectData[0];
                      model.duration = duration[index].toString();

                      // model.recurrType = model.recurrType ?? "Daily";

                      model.totalJobs = _jobController.text;

                      Provider.of<JobScheduleProvider>(context, listen: false)
                          .getRecurrDate(context);

                      if (model.staffList != null) {
                        Navigator.pop(context, 'check-recur-with-staff');
                        Navigator.pop(context, 'check-recur-with-staff');
                      } else {
                        Navigator.pop(context, true);
                        Navigator.pop(context, true);
                      }
                      setState(() {});
                    } else
                      null;
                  },
                  child: spotOnDropDownValue == "Date (Specific Stop Date)" &&
                              selectedDate.isNotEmpty ||
                          _jobController.text != "" &&
                              _jobController.text != "0" &&
                              _jobController.text != "." &&
                              _jobController.text != ","
                      ? const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: CustomButton(
                              title: 'Select',
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: CustomButton(
                              btnColor: Colors.grey,
                              title: 'Select',
                            ),
                          ),
                        ),
                ),
                const Gap(15),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
