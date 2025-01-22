import 'dart:developer';

import 'package:bizfns/core/utils/Utils.dart';
import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/JobScheduleModel/schedule_list_response_model.dart';
import 'package:bizfns/features/Admin/Material/provider/material_provider.dart';
import 'package:bizfns/features/Admin/Service/provider/service_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../../features/Admin/Create Job/model/JobScheduleModel/job_schedule_model.dart';
import '../../../features/Admin/Create Job/model/JobScheduleModel/job_schedule_response_model.dart';
import '../../../features/Admin/Create Job/model/add_schedule_model.dart';
import '../../../features/Admin/Staff/provider/staff_provider.dart';
import '../../../provider/job_schedule_controller.dart';
import '../../route/RouteConstants.dart';
import '../../utils/route_function.dart';
import '../HeaderJobPageWidget/header_jon_page_widget.dart';

class TimeJobScheduleList extends StatefulWidget {

  const TimeJobScheduleList({Key? key}) : super(key: key);

  @override
  State<TimeJobScheduleList> createState() => _TimeJobScheduleListState();
}

class _TimeJobScheduleListState extends State<TimeJobScheduleList> {
  String? selectedValue;

  // double containerHeight = 0.0;
  int itemIndex = -1;

  List<double> _containerHeight = [];
  late JobScheduleProvider timeScheduleController;

  AddScheduleModel model = AddScheduleModel.addSchedule;

  bool isDrag = false;

  @override
  void initState() {
    print('At init');

    model.clearData();

    timeScheduleController =
        Provider.of<JobScheduleProvider>(context, listen: false);

    context.read<JobScheduleProvider>().getScheduleList(context);

    ///todo: get staff list
    ///
    ///
    context.read<StaffProvider>().getStaffList(context);

    ///todo: get material list
    ///
    ///
    context.read<MaterialProvider>().getMaterialListApi(context);

    ///todo: get service list
    ///
    ///
    context.read<ServiceProvider>().getServiceList(context);
    super.initState();
  }

  String simplifyTime(String time) {
    // Split the time string into parts (e.g., ["07:00:00", "AM"])
    List<String> parts = time.split(' ');

    // Extract the hour and minute parts
    String hour = parts[0].split(':')[0];
    String minute = parts[0].split(':')[1];

    // Get the period (AM/PM)
    String period = parts[1];

    // Return the simplified time in the desired format (e.g., "07:00 AM")
    return '$hour:$minute $period';
  }

  var controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return context
        .watch<JobScheduleProvider>()
        .loading || isDrag
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : context
        .watch<JobScheduleProvider>()
        .items
        .isEmpty
        ? const Center(
      child: Text('Can not load result.....'),
    )
        : GestureDetector(
      onHorizontalDragEnd: (dragDetails) {
        int dragValue = dragDetails.primaryVelocity!.toInt();

        String dateSelected = Provider
            .of<JobScheduleProvider>(
            context,
            listen: false)
            .date;
        DateTime selectedDateTime = dateSelected.length <= 10
            ? DateTime.now()
            : DateTime.parse(dateSelected);

        if (dragValue < 0) {
          ///todo moving right
          ///todo increase day by 1
          ///


          DateTime date =
          selectedDateTime.add(Duration(days: 1));


          Provider
              .of<JobScheduleProvider>(context,
              listen: false)
              .date = date.toString();

          Provider.of<JobScheduleProvider>(context,
              listen: false)
              .changeData(date.toString());

          Provider.of<JobScheduleProvider>(context, listen: false)
              .getScheduleList(context, dragValue: 1);
        } else if (dragValue > 0) {
          ///todo moving left
          ///todo reduce day by 1
          ///
          DateTime date =
          selectedDateTime.subtract(Duration(days: 1));

          Provider
              .of<JobScheduleProvider>(context,
              listen: false)
              .date = date.toString();

          Provider.of<JobScheduleProvider>(context,
              listen: false)
              .changeData(date.toString());

          Provider.of<JobScheduleProvider>(context, listen: false)
              .getScheduleList(context, dragValue: -1);
        }

        ///todo load data
        ///
        ///
      },
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: timeScheduleController.items.length,
        controller: controller,
        itemBuilder: (context, timeIndex) {
          return Column(
            key: timeScheduleController.keys[timeIndex],
            children: [
              const Gap(10),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      simplifyTime(timeScheduleController
                          .items[timeIndex].time!),
                      style: TextStyle(
                          color: isAfter(
                              timeScheduleController.date,
                              timeScheduleController
                                  .items[timeIndex].time!)
                              ? Colors.black
                              : Colors.black.withOpacity(0.4)),
                    ),
                    const Gap(0.2),
                    GestureDetector(
                      onTap: () {
                        print('Time Index: $timeIndex');

                        ///todo list of  times available
                        ///
                        ///
                        List<String?> timeList =
                        timeScheduleController.items!.map((e) => e.time)
                            .toList()
                            .where((element) =>
                            isAfter(
                                timeScheduleController.date, element!))
                            .toList();

                        timeList.forEach((element) {
                          print('Time Available: $element');
                        });

                        String time = timeScheduleController
                            .items[timeIndex].time ??
                            "";

                        Utils().printMessage(
                            "==============>>>> Here in TimeJobScheduleList.dart with date: ${timeScheduleController
                                .date} Time: $time");
                        Utils().printMessage(
                            "==============>>>> ${timeScheduleController
                                .date}");

                        Provider
                            .of<ServiceProvider>(context,
                            listen: false)
                            .selectedIndex
                            .clear();
                        Provider
                            .of<StaffProvider>(context,
                            listen: false)
                            .selectedIndex
                            .clear();
                        Provider
                            .of<MaterialProvider>(context,
                            listen: false)
                            .selectedIndex
                            .clear();
                        AddScheduleModel model =
                            AddScheduleModel.addSchedule;

                        model.clearData();

                        model.startDate =
                            timeScheduleController.date;

                        model.startTime = getTime(
                            timeScheduleController
                                .items[timeIndex].time!);

                        int duration = getDuration(
                            timeScheduleController.items);

                        model.endDate =
                            timeScheduleController.date;

                        model.endTime = endTime(
                            timeScheduleController
                                .items[timeIndex].time!,
                            duration);

                        if (isAfter(timeScheduleController.date,
                            time)) {
                          model.isAdding = true;

                          var dayCount =
                              timeScheduleController.dayCount;

                          if (dayCount == 0 || dayCount == 6) {
                            ///todo: show a dialogue if the company
                            ///todo: want to create job on holiday
                            ///
                            ///
                            showCupertinoDialog(
                              context: context,
                              builder: (_) {
                                return CupertinoAlertDialog(
                                  content: const Text(
                                    'Are you sure, you want to schedule job on holiday ?',
                                    style: TextStyle(
                                      // color: Color(0xff093d52),
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                  actions: [
                                    CupertinoButton(
                                      child: const Text(
                                        'Yes, I will',
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      onPressed: () {
                                        print(
                                            "timeIndex====>$timeIndex");
                                        context.pop();
                                        Provider
                                            .of<ServiceProvider>(
                                            context,
                                            listen: false)
                                            .selectedIndex
                                            .clear();
                                        Provider
                                            .of<StaffProvider>(
                                            context,
                                            listen: false)
                                            .selectedIndex
                                            .clear();
                                        Provider
                                            .of<MaterialProvider>(
                                            context,
                                            listen: false)
                                            .selectedIndex
                                            .clear();

                                        model.startDate =
                                            timeScheduleController
                                                .date;

                                        model.endDate =
                                            timeScheduleController
                                                .date;

                                        Provider.of<JobScheduleProvider>(
                                            context,
                                            listen: false)
                                            .deleteRecurrDate(
                                            context);

                                        GoRouter.of(context)
                                            .pushNamed(
                                            'create-schedule',
                                            extra: {
                                              'time': getTime(
                                                  timeScheduleController
                                                      .items[
                                                  timeIndex]
                                                      .time!),
                                            }).whenComplete(() {
                                          log("awww yeahhhh 03");
                                          initState();
                                        });
                                        /*Navigate(context, SCHEDULE_JOB,
                                                params: {
                                                  'time': getTime(
                                                      timeScheduleController
                                                          .items[0]
                                                          .jobList![timeIndex]
                                                          .time!),
                                                });*/
                                      },
                                    ),
                                    CupertinoButton(
                                      child: const Text(
                                        'No, Thanks for notifying',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () {
                                        context.pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            model.startDate =
                                timeScheduleController.date;
                            model.endDate =
                                timeScheduleController.date;

                            log("model.startdate : ${model.startDate}");
                            log("model.enddate : ${model.endDate}");
                            log("model.starttime : ${model.startTime}");
                            log("model.endtime : ${model.endTime}");

                            Provider.of<JobScheduleProvider>(
                                context,
                                listen: false)
                                .deleteRecurrDate(context);

                            GoRouter.of(context).pushNamed(
                                'create-schedule',
                                extra: {
                                  'time': getTime(
                                      timeScheduleController
                                          .items[timeIndex]
                                          .time!),
                                }).whenComplete(() {
                              log("awww yeahhhh 02");
                              initState();
                            });

                            /*Navigate(context, SCHEDULE_JOB, params: {
                                  'time': getTime(timeScheduleController
                                      .items[0].jobList![timeIndex].time!),
                                });*/
                          }
                        } else {}
                      },
                      child: isAfter(
                          timeScheduleController.date,
                          timeScheduleController
                              .items[timeIndex].time!)
                          ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: getColor(timeScheduleController
                              .items[timeIndex].schedule!.length),
                          size: 24,
                        ),
                      )
                          : const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.grey,
                          size: 24,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        height: 0.5,
                        color: isAfter(
                            timeScheduleController.date,
                            timeScheduleController
                                .items[timeIndex].time!)
                            ? AppColor.APP_BAR_COLOUR
                            : AppColor.APP_BAR_COLOUR
                            .withOpacity(0.4),
                      ),
                    )
                  ],
                ),
              ),
              itemIndex == timeIndex
                  ? Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Container(
                    height: 20,
                    width: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.green.shade400,
                        borderRadius:
                        BorderRadius.circular(5)),
                  ))
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(left: 100),
                child: scheduleTiles(context, timeIndex),
              ),
              const Gap(5),
            ],
          );
        },
      ),
    );
  }

  AddScheduleModel loadData(BuildContext context, ScheduleModel schedule) {
    model.allImageList = null;
    model.copyImages = null;
    model.imageId = '';
    model.images = null;
    model.isAdding = false;
    model.jobId = schedule.pKJOBID;
    model.location = schedule.jOBLOCATION;
    model.note = schedule.jOBNOTES;
    if (model.imageId != null && schedule.imageId != null) {
      model.imageId = schedule.imageId!;
    }

    //
    model.startTime = schedule.jOBSTARTTIME;

    model.endTime = schedule.jOBENDTIME;

    model.custInvoiceCreatedIds = schedule.custInvoiceCreatedIds;

    model.jobStatus = int.parse(schedule.jOBSTATUS ?? "0");

    model.deposit = schedule.paymentDeposit;
    model.paymentDuration = schedule.paymentDuration;

    model.customer = schedule.customersList != null &&
        schedule.customersList!.isNotEmpty
        ? schedule.customersList!
        .map((e) =>
        CustomerData(
          customerId: e.pKCUSTOMERID.toString(),
          customerName: '${e.cUSTOMERFIRSTNAME} ${e.cUSTOMERLASTNAME}',
          serviceEntityId: e.serviceEntityList!
              .map((e) => e.pKSERVICEENTITY.toString())
              .toList(),
          serviceEntityName: e.serviceEntityList!
              .map((e) => e.sERVICEENTITYNAME.toString())
              .toList(),
        ))
        .toList()
        : [];

    model.allImageList = schedule.imageList!.map((e) => e).toSet().toList();
    // print("allImageList Length=======>${model.allImageList!.length}");
    model.copyImages = schedule.imageList!.map((e) => e).toList();

    ///todo: load staff
    ///
    ///
    if (Provider
        .of<StaffProvider>(context, listen: false)
        .loading == false) {
      Utils().printMessage('Not loading');
      if (Provider
          .of<StaffProvider>(context, listen: false)
          .staffList!
          .isNotEmpty &&
          schedule.staffList != null) {
        Utils().printMessage('Not Empty');

        ///todo load all staffs
        ///
        //
        // schedule.staffList!=null?
        List<int> staffIDs =
        schedule.staffList!.map((e) => e.pKUSERID ?? 0).toList();
        List<int> staffIDList =
        Provider
            .of<StaffProvider>(context, listen: false)
            .staffList!
            .map((e) => int.parse(e.staffId))
            .toList();
        List<String> staffNames = Provider
            .of<StaffProvider>(context,
            listen: false)
            .staffList!
            .map((e) =>
        '${e.staffFirstName.capitalizeFirst} ${e.staffLastName
            .capitalizeFirst}')
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
        model.staffList = [];
        Utils().printMessage('Empty');
      }
    } else {
      Utils().printMessage('loading');
    }

    ///todo: load materials
    ///
    ///
    if (Provider
        .of<MaterialProvider>(context, listen: false)
        .loading ==
        false) {
      Utils().printMessage('Not loading');
      if (Provider
          .of<MaterialProvider>(context, listen: false)
          .materialList
          .isNotEmpty &&
          schedule.jOBMATERIAL != null) {
        Utils().printMessage('Not Empty');

        List<int> materialIDs = schedule.jOBMATERIAL == null
            ? []
            : schedule.jOBMATERIAL!.isEmpty
            ? []
            : schedule.jOBMATERIAL!
            .map((e) => int.parse(e.pKMATERIALID!.toString()))
            .toList();

        List<int> materialIDList =
        Provider
            .of<MaterialProvider>(context, listen: false)
            .materialList
            .map((e) => e.materialId!)
            .toList();

        List<String> materialNames =
        Provider
            .of<MaterialProvider>(context, listen: false)
            .materialList!
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

        model.newMaterialList = schedule.jOBMATERIAL;

        Provider.of<JobScheduleProvider>(context, listen: false)
            .getJobStatus(jobId: model!.jobId.toString());

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
    if (Provider
        .of<ServiceProvider>(context, listen: false)
        .loading == false) {
      Utils().printMessage('Not loading');
      if (Provider
          .of<ServiceProvider>(context, listen: false)
          .allServiceList!
          .isNotEmpty) {
        Utils().printMessage('Not Empty');

        ///todo get service from schedule model
        ///
        List<int> serviceIDs =
        schedule.serviceList!.map((e) => e.iD ?? 0).toList();
        List<int> serviceIDList =
        Provider
            .of<ServiceProvider>(context, listen: false)
            .allServiceList
            .map((e) => e.serviceId!)
            .toList();

        List<String> serviceNames =
        Provider
            .of<ServiceProvider>(context, listen: false)
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
        model.newServiceList = schedule.serviceList!;

        setState(() {});
      } else {
        Utils().printMessage(' Service Empty');
      }
    } else {
      Utils().printMessage('loading');
    }

    return model;
  }

  String getDay(int val) {
    int dayVal = val % 7;

    return dayVal == 0
        ? "Sun"
        : dayVal == 1
        ? "Mon"
        : dayVal == 2
        ? "Tue"
        : dayVal == 3
        ? "Wed"
        : dayVal == 4
        ? "Thu"
        : dayVal == 5
        ? "Fri"
        : "Sat";
  }

  Widget scheduleTiles(BuildContext context, int timeIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: DragTarget(
        builder: (BuildContext context, List<Object?> candidateData,
            List<dynamic> rejectedData) {
          return timeScheduleController.items[timeIndex].schedule!.isEmpty
              ? const SizedBox()
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
            timeScheduleController.items[timeIndex].schedule!.length,
            itemBuilder: (context, jobIndex) {
              return InkWell(
                onTap: () {
                  EasyLoading.show(
                    status: "Processing all the details",
                    indicator: const CircularProgressIndicator(),
                  );
                  Provider
                      .of<ServiceProvider>(context, listen: false)
                      .selectedIndex
                      .clear();
                  Provider
                      .of<StaffProvider>(context, listen: false)
                      .selectedIndex
                      .clear();
                  Provider
                      .of<MaterialProvider>(context, listen: false)
                      .selectedIndex
                      .clear();

                  ScheduleModel schedule = timeScheduleController
                      .items[timeIndex].schedule![jobIndex];

                  Provider.of<JobScheduleProvider>(context, listen: false)
                      .addPrevData(schedule);

                  AddScheduleModel model = loadData(context, schedule);

                  //todo: change here
                  //todo: model.serviceEntityID = schedule.serviceEntityID;

                  /*todo: Implement later context
                            .read<JobScheduleProvider>()
                            .getServiceEntityDetail(
                              context,
                              schedule.customer![0].customerId!,
                              model.serviceEntityID!,
                            );*/

                  if (model.staffList != null &&
                      model.serviceList != null &&
                      model.materialList != null) {
                    model.isAdding = false;

                    EasyLoading.dismiss();
                    print(
                        "checking time-------->${timeScheduleController.date}");
                    model.startDate = timeScheduleController.date!;
                    model.endDate = timeScheduleController.date!;

                    Provider.of<JobScheduleProvider>(context,
                        listen: false)
                        .updateTimeIndex(timeIndex, jobIndex);

                    Provider.of<JobScheduleProvider>(context,
                        listen: false)
                        .deleteRecurrDate(context);

                    Provider.of<JobScheduleProvider>(context,
                        listen: false)
                        .addPrevData(schedule);

                    GoRouter.of(context)
                        .pushNamed('create-schedule', extra: {
                      'time': getTime(
                          timeScheduleController.items[timeIndex].time!),
                      'timeIndex': timeIndex,
                      'jobIndex': jobIndex
                    }).whenComplete(() {
                      initState();
                      setState(() {});
                    });
                  }
                },
                child: LongPressDraggable(
                  data: timeScheduleController
                      .items[timeIndex].schedule![jobIndex],
                  onDragStarted: () {
                    // itemIndex = 0;
                    getContainerCoordinates();
                  },
                  onDragEnd: (details) async {
                    // setState(() {
                    // print(
                    //     "End At Time Slot: ${timeScheduleController.items[0].jobList![itemIndex].time!} Job ID: ${timeScheduleController.items[0].jobList![timeIndex].schedule![jobIndex].jobId!}");

                    timeScheduleController.items[timeIndex].schedule!.add(
                      ScheduleModel(
                        pKJOBID: timeScheduleController
                            .items[timeIndex].schedule![jobIndex].pKJOBID,
                        // jobNo: timeScheduleController
                        //     .items[0]
                        //     .jobList![timeIndex]
                        //     .schedule![jobIndex]
                        //     .jobNo,
                        staffList: timeScheduleController.items[timeIndex]
                            .schedule![jobIndex].staffList,
                        customersList: timeScheduleController
                            .items[timeIndex]
                            .schedule![jobIndex]
                            .customersList,
                      ),
                    );

                    int duration =
                    getDuration(timeScheduleController.items);
                    model.endTime = endTime(
                        timeScheduleController.items[timeIndex].time!,
                        duration);

                    await Provider.of<JobScheduleProvider>(context,
                        listen: false)
                        .reScheduleJob(context,
                        jobID: timeScheduleController.items[timeIndex]
                            .schedule![jobIndex].pKJOBID!,
                        startTime: timeScheduleController
                            .items[itemIndex].time!,
                        endTime: endTime2(
                            timeScheduleController
                                .items[itemIndex].time!,
                            duration));

                    timeScheduleController.items[timeIndex].schedule!
                        .removeAt(jobIndex);

                    setState(() {
                      itemIndex = -1;
                    });

                    // context
                    //     .read<JobScheduleProvider>()
                    //     .getScheduleList(context);

                    ///todo: get staff list
                  },
                  onDragUpdate: (DragUpdateDetails details) {
                    // setState(() {
                    //   isDrag = true;
                    // });
                    double cursorPosition = details.globalPosition.dy;

                    double position = details.localPosition.dy;

                    print('Position: $position');

                    if (position > 400) {
                      controller.animateTo(controller.position.maxScrollExtent +
                          600, duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    } else {
                      controller.animateTo(controller.position.minScrollExtent -
                          600, duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    }

                    //print('key position: ${timeScheduleController.keys[timeIndex].currentContext!.size!.height}');

                    for (int i = 0;
                    i < timeScheduleController.items.length;
                    i++) {
                      // if (_containerHeight.length ==
                      //     timeScheduleController.items.length) {
                      if (cursorPosition >= _containerHeight[i]) {
                        setState(() {
                          itemIndex = i;
                        });
                        print('Item index: $itemIndex');
                      } else {
                        print('Going lower');
                      }
                    }
                  },
                  // delay: const Duration(milliseconds: 500),
                  feedback: Material(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xffcceef7),
                            borderRadius: BorderRadius.circular(5)),
                        child: showScheduleInfo(
                            schedule: timeScheduleController
                                .items[timeIndex].schedule![jobIndex],
                            customer: timeScheduleController
                                .items[timeIndex]
                                .schedule![jobIndex]
                                .customersList !=
                                null &&
                                timeScheduleController
                                    .items[timeIndex]
                                    .schedule![jobIndex]
                                    .customersList!
                                    .isNotEmpty
                                ? timeScheduleController
                                .items[timeIndex]
                                .schedule![jobIndex]
                                .customersList ??
                                []
                                : [],
                            staffs: timeScheduleController
                                .items[timeIndex]
                                .schedule![jobIndex]
                                .staffList ??
                                [],
                            services: timeScheduleController
                                .items[timeIndex]
                                .schedule![jobIndex]
                                .serviceList ??
                                []),
                      ),
                    ),
                  ),
                  childWhenDragging: Visibility(
                    visible: itemIndex != timeIndex,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: const Color(0xffcceef7),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color(0xffcceef7),
                          borderRadius: BorderRadius.circular(5)),
                      child: showScheduleInfo(
                        schedule: timeScheduleController
                            .items[timeIndex].schedule![jobIndex],
                        customer: timeScheduleController.items[timeIndex]
                            .schedule![jobIndex].customersList ??
                            [],
                        staffs: timeScheduleController.items[timeIndex]
                            .schedule![jobIndex].staffList ??
                            [],
                        services: timeScheduleController.items[timeIndex]
                            .schedule![jobIndex].serviceList ??
                            [],
                      ),
                    ),
                  ),
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 6,
                crossAxisSpacing: 5,
                mainAxisSpacing: 4),
          );
        },
      ),
    );
  }

  void showMyDialog(BuildContext context, List<JobScheduleModel> items,
      Jobs jobList) {
    print("ITEMS->${timeScheduleController.items}");
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                height: 200,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Copy to",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const Gap(15),
                      DropdownButtonFormField2(
                        hint: const Text(
                          "Select Time",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        decoration: InputDecoration(
                          //Add isDense true and zero Padding.
                          //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          //Add more decoration as you want here
                          //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                        ),
                        isExpanded: true,
                        // hint: const Text(
                        //   'Select Your Gender',
                        //   style: TextStyle(fontSize: 14),
                        // ),
                        items: items
                            .map((item) =>
                            DropdownMenuItem<JobScheduleModel>(
                              value: item,
                              child: Text(
                                item.time,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                            .toList(),
                        /*validator: (value) {
                                      if (value == null) {
                                        return 'Please select time.';
                                      }
                                      return null;
                                    },*/
                        onChanged: (value) {
                          //Do something when changing the item if you want.
                          print("value=>${value!.time}");
                          selectedValue = value.time.toString();
                        },
                        onSaved: (value) {
                          // selectedValue = value.toString();
                        },
                        buttonStyleData: const ButtonStyleData(
                          height: 60,
                          padding: EdgeInsets.only(left: 20, right: 10),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const Gap(25),
                      Align(
                          alignment: AlignmentDirectional.bottomEnd,
                          child: ElevatedButton(
                              onPressed: () {
                                final int index = items.indexWhere(
                                    ((times) => times.time == selectedValue));
                                print("selectedValue->$selectedValue");
                                print("Index->$index");

                                //todo:

                                /*setState(() {
                                  timeScheduleController.items[index].jobList.add(
                                      Jobs(
                                          id: jobList.id,
                                          jobNo: jobList.jobNo,
                                          staffNo: jobList.staffNo,
                                          custNo: jobList.custNo));
                                });*/
                              },
                              child: const Text(
                                "Copy",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )))
                    ],
                  ),
                ),
              );
            }));
      },
    );
  }

  void getContainerCoordinates() {
    _containerHeight.clear();
    print(
        "timeScheduleController length---->${timeScheduleController.keys
            .length}");
    for (int i = 0; i < timeScheduleController.keys.length; i++) {
      if (timeScheduleController.keys[i].currentContext != null) {
        RenderBox containerBox = timeScheduleController.keys[i].currentContext!
            .findRenderObject() as RenderBox;
        Offset position = containerBox.localToGlobal(Offset.zero);
        double y = position.dy;
        _containerHeight.add(y);
      }
    }
  }


  String generateString(List<String> services, List<String> customers,
      List<String> staff) {
    List<String> result = [];

    void addNameChunks(List<String> names, {bool isCustomerOrStaff = false}) {
      for (var name in names) {
        if (result
            .join(',')
            .length + name.length + 3 <= 35) {
          if (isCustomerOrStaff) {
            var splitName = name.split(' ');
            var lastName = splitName.length > 1 ? splitName.last : splitName
                .first;
            var chunk = lastName.length > 3
                ? '${lastName.substring(0, 3)}..'
                : '$lastName..';
            result.add(chunk);
          } else {
            var chunk = name.length > 3 ? '${name.substring(0, 3)}..' : '$name..';
            result.add(chunk);
          }
        }
      }
    }

    if (services.isNotEmpty) {
      addNameChunks(services);
    }

    if (customers.isNotEmpty) {
      addNameChunks(customers, isCustomerOrStaff: true);
    }

    if (staff.isNotEmpty) {
      addNameChunks(staff, isCustomerOrStaff: true);
    }
    // Ensure the total length of the result is exactly 35 characters
    String joinedResult = result.join(',');
    if (joinedResult.length > 35) {
      joinedResult = joinedResult.substring(0, 35);
    } else if (joinedResult.length < 35) {
      joinedResult = joinedResult.padRight(35, ' ');
    }

    return joinedResult;
  }

  Widget showScheduleInfo({required ScheduleModel schedule,
    required List<StaffList> staffs,
    required List<CustomersList> customer,
    required List<Services> services}) {
    // String customerName = "Cust: ";
    String customerName = "";


    /*if (customer.isNotEmpty) {
      customer.forEach((element) {
        // customerName +=
        //     "${element.cUSTOMERFIRSTNAME!.substring(0, 3)} ${element.cUSTOMERLASTNAME!.substring(0, 3)} ,";
        String lastNameSubstring = element.cUSTOMERLASTNAME!
            .substring(0, element.cUSTOMERLASTNAME!.length.clamp(0, 3));
        customerName += "${lastNameSubstring}...,";
      });
      customerName = customerName.substring(0, customerName.length - 1);
    } else {}

    String staffName = '';

    for (var staff in staffs) {

      String lastName = staff.uSERLASTNAME!.capitalizeFirst ?? "";

      String total = '${lastName.substring(0, lastName.length.clamp(0, 6))}...';

      staffName += total;
    }

    String serviceName = '';

    for (var service in services) {
      String name = service.sERVICENAME!.capitalizeFirst!;

      serviceName += '${name.substring(0, name.length.clamp(0, 6))}...';
    }

    String updatedJobDetails =  "$serviceName,$staffName,$customerName"; */

    String updatedJobDetails = generateString(
        services.map((e) => e.sERVICENAME!).toList(),
        customer.map((e) => e.cUSTOMERLASTNAME!).toList(),
        staffs.map((e) => e.uSERFIRSTNAME!).toList());

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(updatedJobDetails.length > 40
          ? '${updatedJobDetails.substring(0, 40)}...'
          : updatedJobDetails),
    );
  }

  bool isAfter(String date, String time) {
    // Parse the date string and format it to a consistent YYYY-MM-DD format
    String _date = date.length >= 10
        ? '${DateTime
        .parse(date)
        .year}-${DateTime
        .parse(date)
        .month
        .toString()
        .padLeft(2, '0')}-${DateTime
        .parse(date)
        .day
        .toString()
        .padLeft(2, '0')}'
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

  int getDuration(List<ScheduleData> schedule) {
    if (schedule.length == 1) {
      return 1;
    } else {
      int _hour = int.parse(schedule[0].time!.split(':')[0]);
      int _nextHour = int.parse(schedule[1].time!.split(':')[0]);

      print('Hour: $_hour Next Hour: $_nextHour');

      return _nextHour - _hour;
    }
  }
}

Color getColor(int jobCount) {

  int maxJobCount = 14;

  int percentage50 = (maxJobCount*0.5).toInt();

  int percentage75 = (maxJobCount*0.75).toInt();

  if(jobCount <= percentage50){
    return Colors.green;
  }else if(jobCount > percentage50 && jobCount <= percentage75){
    return Colors.amber;
  }else if(jobCount > percentage75 && jobCount < maxJobCount){
    return Colors.deepOrange;
  }else if(jobCount == maxJobCount){
    return Colors.red;
  }

  return AppColor.APP_BAR_COLOUR
      .withOpacity(0.4);
}

String getTime(String timeData) {
  // Split timeData by space to separate time and AM/PM
  List<String> parts = timeData.split(' ');

  // Extract the time part (e.g., 02:00:00) and the AM/PM part (if present)
  String timePart = parts[0];
  String amPmPart = parts.length > 1 ? parts[1] : '';

  // Split the time part to extract hours and minutes
  int _hour = int.parse(timePart.split(':')[0]);
  int _minute = int.parse(timePart.split(':')[1]);

  // Format hours and minutes with leading zeros if needed
  String hour = _hour < 10 ? "0$_hour" : _hour.toString();
  String minute = _minute < 10 ? "0$_minute" : _minute.toString();

  // Use the existing AM/PM part if provided; otherwise, determine it based on the hour
  String timeOfDay =
  amPmPart.isNotEmpty ? amPmPart : (_hour >= 12 ? "PM" : "AM");

  // Return the formatted time with the correct AM/PM designation
  return '$hour:$minute $timeOfDay';
}

// String endTime(String timeData, int duraiton) {
//   log("duration : ${duraiton}");
//   int _hour = int.parse(timeData.split(':')[0]) + duraiton;
//   int _minute = int.parse(timeData.split(':')[1]);

//   String hour = _hour < 10 ? "0$_hour" : _hour.toString();
//   String minute = _minute < 10 ? "0$_minute" : _minute.toString();

//   String timeOfDay = int.parse(hour) >= 12 ? "PM" : "AM";
//   print("456123===========>$hour:$minute $timeOfDay");
//   return '$hour:$minute $timeOfDay';
// }

String endTime(String timeData, int duration) {
  // Split timeData by space to separate time and AM/PM
  List<String> parts = timeData.split(' ');

  // Extract the time part (e.g., 02:00:00) and the AM/PM part
  String timePart = parts[0];
  String amPmPart = parts.length > 1 ? parts[1] : '';

  // Split the time part to extract hours and minutes
  int _hour = int.parse(timePart.split(':')[0]);
  int _minute = int.parse(timePart.split(':')[1]);

  // Adjust the hour by adding the duration
  _hour += duration;

  // Determine if the hour is greater than 12 and adjust accordingly
  if (_hour >= 12) {
    if (_hour > 12) _hour -= 12; // Convert 13:00-23:59 to 01:00-11:59
    amPmPart = (amPmPart == 'AM') ? 'PM' : 'AM'; // Toggle AM/PM
  }

  // Handle hour overflow (24-hour wrap around)
  if (_hour == 0) _hour = 12;

  // Format hours and minutes with leading zeros if needed
  String hour = _hour < 10 ? "0$_hour" : _hour.toString();
  String minute = _minute < 10 ? "0$_minute" : _minute.toString();

  // Return the formatted time with the correct AM/PM designation
  return '$hour:$minute $amPmPart';
}

String endTime2(String timeData, int duration) {
  int _hour = int.parse(timeData.split(':')[0]) + duration;
  int _minute = int.parse(timeData.split(':')[1]);

  String hour = _hour < 10 ? "0$_hour" : _hour.toString();
  String minute = _minute < 10 ? "0$_minute" : _minute.toString();

  String timeOfDay = int.parse(hour) >= 12 ? "PM" : "AM";

  // Add seconds to the formatted time
  // String endTime = '$hour:$minute:00 $timeOfDay';
  String endTime = '$hour:$minute:00';

  print("456123===========>$endTime");
  return endTime;
}
