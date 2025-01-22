import 'dart:developer';

import 'package:bizfns/features/Admin/Staff/provider/staff_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/utils/colour_constants.dart';
import 'model/get_job_number_by_date_model.dart';

class JobList extends StatefulWidget {
  final String date;
  final List<JobDetails> jobDetailsData;
  List<int>? preSelectedIndex;
  JobList(
      {super.key,
      required this.date,
      required this.jobDetailsData,
      this.preSelectedIndex});

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  List<int> selectedIndex = [];
  bool isSelectAll = false;

  void selectAll(bool select) {
    print("select : ${select}");
    if (select) {
      selectedIndex.clear();
      setState(() {
        widget.jobDetailsData.forEach((element) {
          selectedIndex.add(int.parse(element.jobNumber.toString()));
        });
      });
    } else {
      setState(() {
        selectedIndex.clear();
      });
    }
    setState(() {
      isSelectAll = select;
    });
  }

  String getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th'; // Special case for 11, 12, 13
    }
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  // Function to format a date string like '2024-10-30' into 'Mon 30th October'
  String formatDateString(String dateString) {
    DateTime date = DateTime.parse(dateString); // Parse the String to DateTime
    String weekday = DateFormat('EEE').format(date); // Mon, Tue, etc.
    String day = getDayWithSuffix(date.day); // 30th, 1st, etc.
    String month = DateFormat('MMMM').format(date); // October, November, etc.

    return '$weekday $day $month'; // e.g. Mon 30th October
  }

  @override
  void initState() {
    super.initState();
    log("PreSelected_Index : ${widget.preSelectedIndex}");
    if (widget.preSelectedIndex != null) {
      selectedIndex = widget.preSelectedIndex!.toSet().toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 1.5,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        color: Color(0xFFFFFF),
      ),
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
                Expanded(
                  child: Text(
                    "Job List ${formatDateString(widget.date)}", //Text(formatDateTime(selectedWeekDates[index])),
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Provider.of<ServiceProvider>(context, listen: false)
                    //     .selectedIndex
                    //     .clear();

                    // if (Provider.of<ServiceProvider>(context, listen: false)
                    //     .selectedIndex
                    //     .isEmpty) {
                    //   if (model.serviceList != null &&
                    //       model.serviceList!.isNotEmpty) {
                    //     model.serviceList!.clear();
                    //     Provider.of<ServiceProvider>(context, listen: false)
                    //         .selectedIndex
                    //         .clear();
                    //   }
                    // } else {
                    //   Provider.of<ServiceProvider>(context, listen: false)
                    //       .selectedIndex
                    //       .clear();
                    // }
                   context.pop(false);
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
          const Gap(10),
          Expanded(
              child: widget.jobDetailsData.isEmpty
                  ? const Center(
                      child: Text('No Customer Found'),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: TextField(
                            enabled: true,
                            // controller: _searchController,
                            cursorColor: AppColor.APP_BAR_COLOUR,
                            onChanged: (val) async {
                              setState(() {});
                              // if (val.length > 3) {
                              //   List<ServiceListData> allServiceList = [];
                              //   allServiceList = Provider.of<ServiceProvider>(
                              //           context,
                              //           listen: false)
                              //       .allServiceList;
                              //   int itemIndex1 = allServiceList.indexOf(
                              //       allServiceList.firstWhere((element) => element
                              //           .serviceName!
                              //           .toLowerCase()
                              //           .contains(val.toLowerCase())));

                              //   print('Item Index: $itemIndex1');

                              //   if (itemIndex1 != -1) {
                              //     itemScrollController.scrollTo(
                              //         index: itemIndex1,
                              //         duration: Duration(milliseconds: 200),
                              //         curve: Curves.easeInOut);
                              //   }
                              //   setState(() {});
                              // }
                            },
                            decoration: InputDecoration(
                              enabled: true,
                              contentPadding: EdgeInsets.only(
                                  left: 15, right: 15, bottom: 15),
                              hintText: "Search by customer name",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColor.APP_BAR_COLOUR, width: 1.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                color: Colors.grey,
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                        const Gap(8),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(''),
                              InkWell(
                                onTap: () {
                                  if (isSelectAll == true) {
                                    selectAll(false);
                                  } else {
                                    selectAll(true);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: isSelectAll
                                        ? Text(
                                            'Clear All',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0),
                                          )
                                        : Text(
                                            'Select All',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0),
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                            flex: 5,
                            child: ListView(
                              children: [
                                ...widget.jobDetailsData
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0),
                                    child: CheckboxListTile(
                                      fillColor:
                                          // e.value.activeStatus !=
                                          //         "0"
                                          //     ?
                                          MaterialStateProperty.all<Color>(
                                              AppColor.APP_BAR_COLOUR),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      title: Text(
                                        '${e.value.jobNumber}',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                                // e.value.activeStatus !=
                                                //         "0"
                                                //     ?
                                                Colors.black
                                            // : Colors.black26,
                                            ),
                                      ),
                                      value: selectedIndex.contains(int.parse(
                                          e.value.jobNumber.toString())),
                                      onChanged: (value) {
                                        if (selectedIndex.contains(int.parse(
                                            e.value.jobNumber.toString()))) {
                                          selectedIndex.remove(int.parse(
                                              e.value.jobNumber.toString()));
                                        } else {
                                          selectedIndex.add(int.parse(
                                              e.value.jobNumber.toString()));
                                        }
                                        setState(() {});
                                      },
                                    ),
                                  );
                                })
                              ],
                            ))
                      ],
                    )),
          Gap(10),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                  onPressed: selectedIndex.isNotEmpty
                      ? () {
                          Provider.of<StaffProvider>(context, listen: false)
                              .selectedJobs = selectedIndex;
                          setState(() {});
                          context.pop(true);
                        }
                      : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60.0),
                    child: Text('Select', style: TextStyle(fontSize: 14)),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    disabledBackgroundColor: Colors.grey,
                    backgroundColor: const Color(0xFF093E52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
