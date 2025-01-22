import 'dart:convert';
import 'dart:developer';
import 'dart:io';
//if git pull works this remains unchange.....
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:bizfns/core/utils/Utils.dart';
import 'package:bizfns/core/utils/api_constants.dart';
import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/core/utils/image_controller.dart';
import 'package:bizfns/core/utils/route_function.dart';
import 'package:bizfns/features/Admin/Create%20Job/history_record_page.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/JobScheduleModel/schedule_list_response_model.dart';
import 'package:bizfns/provider/job_schedule_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizing/sizing.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../core/route/RouteConstants.dart';
import '../../../core/shared_pref/shared_pref.dart';
import '../../../core/utils/bizfns_layout_widget.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_field.dart';
import '../../../core/widgets/common_text.dart';
import '../Material/provider/material_provider.dart';
import '../Service/provider/service_provider.dart';
import '../Staff/provider/staff_provider.dart';
import 'ScheduleJobPages/View Customer/view_customer.dart';
import 'ScheduleJobPages/add_customer_for_invoice.dart';
import 'ScheduleJobPages/add_material.dart';
import 'ScheduleJobPages/add_service.dart';
import 'ScheduleJobPages/add_staff_In_job.dart';
import 'ScheduleJobPages/add_start_end.dart';
import 'ScheduleJobPages/location.dart';
import 'ScheduleJobPages/payment.dart';
import 'ScheduleJobPages/service_entity.dart';
import 'ScheduleJobPages/write_note.dart';
import 'all_customers.dart';
import 'api-client/schedule_api_client_implementation.dart';
import 'model/JobScheduleModel/job_schedule_response_model.dart';
import 'model/add_schedule_model.dart';

class ScheduleJob extends StatefulWidget {
  final String time;

  // final int timeIndex;
  // final int jobIndex;

  const ScheduleJob({
    Key? key,
    required this.time,
    // required this.timeIndex,
    // required this.jobIndex
  }) : super(key: key);

  @override
  State<ScheduleJob> createState() => _ScheduleJobState();
}

class _ScheduleJobState extends State<ScheduleJob> {
  AddScheduleModel? addScheduleModel = AddScheduleModel.addSchedule;

  TextEditingController _dropDownTextController = TextEditingController();

  int dropDownValue = 0;
  var initialDropDownValue = '';

  ScrollController _scrollController = ScrollController();

  int jobStatus = 0;

  bool showDates = false;

  // bool canEdit = true;

  bool _isDropDownVisible = false;

  String invoiceNo = '';

  AddScheduleModel currentState = AddScheduleModel.addSchedule;

  late JobScheduleProvider timeScheduleController;

  bool _isRefreshing = false;

  bool? hasService;

  // List<String> temporaryImageIdList = [];

  // final ScrollController _controller = ScrollController();

  @override
  void initState() {
    Provider.of<JobScheduleProvider>(context, listen: false)
        .historyList
        .clear();
    timeScheduleController =
        Provider.of<JobScheduleProvider>(context, listen: false);

    dropDownValue == 0;
    addScheduleModel!.jobStatus == null
        ? Provider.of<JobScheduleProvider>(context, listen: false).isEdit = true
        : Provider.of<JobScheduleProvider>(context, listen: false).isEdit =
            false;

    dropDownValue = addScheduleModel!.jobStatus ?? 0;

    if (model.jobId != null &&
        model.customer != null &&
        model.customer!.isNotEmpty) {
      List<Map<String, dynamic>> arrayOfObjects = addScheduleModel!.customer!
          .map((e) => {"customerId": int.parse(e.customerId.toString())})
          .toList();
      Provider.of<JobScheduleProvider>(context, listen: false)
          .getCustomerServiceHistory(
              customerId: arrayOfObjects, context: context);
    }

    _scrollController.addListener(() {
      setState(() {
        _isDropDownVisible =
            _scrollController.offset > 20; // adjust the threshold as needed
      });
    });

    Provider.of<JobScheduleProvider>(context, listen: false).isInvoiced = false;
    log("isInvoiced : ${Provider.of<JobScheduleProvider>(context, listen: false).isInvoiced}");
    super.initState();
  }

  String convertTimeFormatWhileAdding(String timeString) {
    log("convertTimeFormatWhileAdding calling");
    log("Getting timeString : ${timeString}");
    log("isEdit WhileAdding: ${addScheduleModel!.isEdit}");
    // Parse the input time string
    DateTime parsedTime;

    // Check if the time string contains seconds
    if (timeString.contains(':00:00')) {
      // Parse the input time string with seconds
      parsedTime = DateFormat('hh:mm:ss a').parseLoose(timeString);
    } else {
      // Parse the input time string without seconds
      parsedTime = DateFormat('hh:mm a').parseLoose(timeString);
    }

    // Format the time as 'HH:mm' (24-hour format)
    String formattedTime = DateFormat('HH:mm').format(parsedTime);

    return formattedTime;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  AddScheduleModel model = AddScheduleModel.addSchedule;

  AddScheduleModel loadPrevData(BuildContext context) {
    ScheduleModel schedule = timeScheduleController
            .items[Provider.of<JobScheduleProvider>(context, listen: false)
                .timeIndex]
            .schedule![
        Provider.of<JobScheduleProvider>(context, listen: false).jobIndex];

    model.location = schedule.jOBLOCATION;
    model.isAdding = false;
    model.jobId = schedule.pKJOBID;
    model.note = schedule.jOBNOTES;
    model.startTime = schedule.jOBSTARTTIME;
    // model.startDate = schedule.s
    model.endTime = schedule.jOBENDTIME;

    model.custInvoiceCreatedIds = schedule.custInvoiceCreatedIds;

    model.jobStatus = int.parse(schedule.jOBSTATUS ?? "0");

    model.customer = schedule.customersList !=
                null &&
            schedule.customersList!.isNotEmpty
        ? schedule.customersList!
            .asMap()
            .entries
            .map((e) => CustomerData(
                index: e.key,
                customerId: e.value.pKCUSTOMERID.toString(),
                customerName:
                    '${e.value.cUSTOMERFIRSTNAME} ${e.value.cUSTOMERLASTNAME}',
                serviceEntityId: e.value.serviceEntityList!
                    .map((e) => e.pKSERVICEENTITY.toString())
                    .toList(),
                serviceEntityName: e.value.serviceEntityList!
                    .map((e) => e.sERVICEENTITYNAME.toString())
                    .toList()))
            .toList()
        : [];
    model.staffList = schedule.staffList != null &&
            schedule.staffList!.isNotEmpty
        ? schedule.staffList!
            .asMap()
            .entries
            .map((e) => StaffID(
                index: e.key,
                id: e.value.pKUSERID.toString(),
                staffName: '${e.value.uSERFIRSTNAME} ${e.value.uSERLASTNAME}'))
            .toList()
        : [];

    ///todo: load staff
    ///
    ///
    // if (Provider.of<StaffProvider>(context, listen: false).loading == false &&
    //     schedule.staffList != null) {
    //   Utils().printMessage('Not loading');
    //   if (Provider.of<StaffProvider>(context, listen: false)
    //       .staffList!
    //       .isNotEmpty) {
    //     Utils().printMessage('Not Empty');
    //
    //     ///todo load all staffs
    //     ///
    //     List<int> staffIDs =
    //         schedule.staffList!.map((e) => e.pKUSERID ?? 0).toList();
    //     List<int> staffIDList =
    //         Provider.of<StaffProvider>(context, listen: false)
    //             .staffList!
    //             .map((e) => int.parse(e.staffId))
    //             .toList();
    //     List<String> staffNames = Provider.of<StaffProvider>(context,
    //             listen: false)
    //         .staffList!
    //         .map((e) =>
    //             '${e.staffFirstName.capitalizeFirst} ${e.staffLastName.capitalizeFirst}')
    //         .toList();
    //
    //     List<StaffID> staffList = [];
    //
    //     for (var element in staffIDs) {
    //       staffList.add(StaffID(
    //         index: staffIDList.indexOf(element),
    //         id: element.toString(),
    //         staffName: staffNames[staffIDList.indexOf(element)],
    //       ));
    //     }
    //
    //     model.staffList = staffList;
    //
    //     setState(() {});
    //   } else {
    //     Utils().printMessage('Empty');
    //   }
    // } else {
    //   Utils().printMessage('loading');
    // }

    ///todo: load materials
    ///
    ///
    if (Provider.of<MaterialProvider>(context, listen: false).loading ==
            false &&
        schedule.jOBMATERIAL!.isNotEmpty) {
      Utils().printMessage('Not loading');
      if (Provider.of<MaterialProvider>(context, listen: false)
              .materialList
              .isNotEmpty &&
          schedule.jOBMATERIAL != null) {
        Utils().printMessage('Not Empty');

        List<int> materialIDs = [];
        schedule.jOBMATERIAL == null && schedule.jOBMATERIAL!.isEmpty
            ? materialIDs = []
            : materialIDs = (schedule.jOBMATERIAL!
                .map((e) => int.parse(e.pKMATERIALID!.toString()))
                .toList());

        List<int> materialIDList =
            Provider.of<MaterialProvider>(context, listen: false)
                .materialList
                .map((e) => e.materialId!)
                .toList();

        List<String> materialNames =
            Provider.of<MaterialProvider>(context, listen: false)
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

        model!.materialList = materialList;
        model!.newMaterialList = schedule.jOBMATERIAL!;

        setState(() {});
      } else {
        model!.materialList = [];
        Utils().printMessage('Material Empty');
      }
    } else {
      Utils().printMessage('loading');
    }

    ///todo: load images///
    List<String> allImageList =
        schedule.imageList!.map((e) => e.fILENAME.toString() ?? '').toList();

    model.allImageList = schedule.imageList!.map((e) => e).toList();

    ///todo: load services
    ///
    ///
    if (Provider.of<ServiceProvider>(context, listen: false).loading == false) {
      Utils().printMessage('Not loading');
      if (Provider.of<ServiceProvider>(context, listen: false)
          .allServiceList!
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

        model!.serviceList = serviceList;

        setState(() {});
      } else {
        Utils().printMessage(' Service Empty');
      }
    } else {
      Utils().printMessage('loading');
    }

    return model;
  }

  cancelChanges() {
    print("cancel changes called");
    loadPrevData(context);
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

  scrollToTop(bool? isShowSnakBar) {
    // showSnackBar(BuildContext context) {
    const snackBarWithWidth = SnackBar(
      duration: Duration(seconds: 2),
      content: Center(
        child: Text(
          "Now Start Modify",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black54,
      behavior: SnackBarBehavior.floating,
      width: 200,
    );
    var snackWithTop = SnackBar(
      // width: ,
      // width: 100.00,
      content: Container(
        width: 100,
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: 100,
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            decoration: const BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30.0),
                right: Radius.circular(30.0),
              ),
            ),
            child: const Center(
              child: Text(
                "Now Start Modify",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.black.withOpacity(0.8),
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 550),
    );
    setState(() {
      _isRefreshing = true;
    });
    _scrollController
        .animateTo(
      0.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    )
        .then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isRefreshing = false;
        });
        isShowSnakBar == true
            ? ScaffoldMessenger.of(context).showSnackBar(snackBarWithWidth)
            : null;
      });
    });
  }

  dropDownSwitchCase(String val) {
    if (val == '0') {
      _dropDownTextController.text = "OPEN";
    } else if (val == "1") {
      _dropDownTextController.text = "COMPLETED";
    } else if (val == "2") {
      _dropDownTextController.text = "ATTEMPTED";
    } else if (val == "3") {
      _dropDownTextController.text = "WIP";
    } else {
      _dropDownTextController.text = "CLOSED-NA";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // dropDownValue = addScheduleModel!.jobStatus ?? 0;

    return WillPopScope(
      onWillPop: () async {
        Provider.of<JobScheduleProvider>(context, listen: false)
            .clearAllPayment();
        model.allImageList!.clear();
        model.allImageList!.addAll(model!.copyImages!);
        //----------clearing recur value-----------//
        Provider.of<JobScheduleProvider>(context, listen: false)
            .reccurrDateList
            .clear();
        addScheduleModel!.duration = null;
        addScheduleModel!.totalJobs = null;
        //-----------------------------------------//
        GoRouter.of(context).pop();
        // Provider.of<JobScheduleProvider>(context, listen: false)
        //     .getScheduleList(context);

        return true;
      },
      child: _isRefreshing == true
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              backgroundColor: Colors.grey.withOpacity(0.05),
              body: addScheduleModel == null
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///todo: show this item
                        ///todo: when job is saved
                        ///todo: then it's status can be changed and modification is possible
                        Offstage(
                          offstage: addScheduleModel!.jobId == null ||
                              _isDropDownVisible ||
                              Provider.of<JobScheduleProvider>(context)
                                      .isEdit ==
                                  true,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 18,
                              top: 20,
                              bottom: 10,
                              right: 18,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DropdownMenu(
                                  onSelected: (val) async {
                                    bool? result;
                                    await showCupertinoDialog(
                                      context: context,
                                      builder: (_) {
                                        return CupertinoAlertDialog(
                                          content: const Text(
                                            'Are you sure, you want to change the job status ?',
                                            style: TextStyle(
                                              color: Color(0xff093d52),
                                              fontSize: 17,
                                            ),
                                          ),
                                          actions: [
                                            CupertinoButton(
                                              child: const Text(
                                                'Yes, Change',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ),
                                              onPressed: () {
                                                // _dropDownTextController.text =
                                                //     val.toString();
                                                dropDownSwitchCase(
                                                    val.toString());

                                                //hit the jobStatusChange Api
                                                Provider.of<JobScheduleProvider>(
                                                        context,
                                                        listen: false)
                                                    .saveJobStatus(
                                                        jobId: model.jobId
                                                            .toString(),
                                                        jobStatus:
                                                            val.toString(),
                                                        context: context);

                                                context.pop();
                                                setState(() {});
                                              },
                                            ),
                                            CupertinoButton(
                                              child: const Text(
                                                'No',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () {
                                                dropDownSwitchCase(
                                                    addScheduleModel!.jobStatus
                                                            .toString() ??
                                                        '0');

                                                context.pop();
                                                setState(() {});
                                                setState(() {});
                                                // addScheduleModel!.jobStatus =
                                                //     null;
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  label: const Text(
                                    'Job Status',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColor.APP_BAR_COLOUR),
                                  ),
                                  controller: _dropDownTextController,
                                  textStyle: const TextStyle(
                                    color: AppColor.APP_BAR_COLOUR,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  inputDecorationTheme:
                                      const InputDecorationTheme(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: AppColor.APP_BAR_COLOUR,
                                      width: 2,
                                    )),
                                  ),
                                  initialSelection:
                                      addScheduleModel!.jobStatus ?? 0,
                                  dropdownMenuEntries: const [
                                    DropdownMenuEntry(
                                      value: 0,
                                      label: 'OPEN',
                                    ),
                                    DropdownMenuEntry(
                                      value: 2,
                                      label: 'ATTEMPTED',
                                    ),
                                    DropdownMenuEntry(
                                      value: 3,
                                      label: 'WIP',
                                    ),
                                    DropdownMenuEntry(
                                      value: 1,
                                      label: 'COMPLETED',
                                    ),
                                    DropdownMenuEntry(
                                      value: 4,
                                      label: 'CLOSED-NA',
                                    )
                                  ],
                                ),
                                Visibility(
                                  visible: (model.custInvoiceCreatedIds !=
                                          null) ||
                                      Provider.of<JobScheduleProvider>(context,
                                                  listen: false)
                                              .isInvoiced ==
                                          true,
                                  child: GestureDetector(
                                    onTap: () async {
                                      Provider.of<JobScheduleProvider>(context,
                                              listen: false)
                                          .getInvoicedCustomerData(
                                              context: context,
                                              jobId: model.jobId!);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          border: Border.all(
                                              color: Colors.grey.shade300)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        child: Text(
                                          'Invoices',
                                          style: TextStyle(
                                              color: AppColor.APP_BAR_COLOUR,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ListView(
                            controller: _scrollController,
                            shrinkWrap: true,
                            children: [
                              const Gap(15),
                              GestureDetector(
                                onTap: () async {
                                  // Utils().printMessage(
                                  //     "Time=====>>>>>>>>" + widget.time);
                                  showMyDialog('add_stat_end',
                                      addScheduleModel!.startTime);
                                },
                                child: CustomField(
                                  svgPath:
                                      addScheduleModel!.jobStatus == null ||
                                              Provider.of<JobScheduleProvider>(
                                                          context,
                                                          listen: false)
                                                      .isEdit ==
                                                  true
                                          ? 'assets/images/Pencil.svg'
                                          : 'assets/images/grid 1.svg',
                                  title: 'Start-End',
                                  isDone: false,
                                ),
                              ),
                              if (addScheduleModel!.startDate != null)
                                CustomDetailsField(
                                    data:
                                        'Start : ${getDateFormat(addScheduleModel!.startDate!.split(' ')[0])}  at: ${getTime(addScheduleModel!.startTime!)}'),
                              if (addScheduleModel!.endDate != null)
                                CustomDetailsField(
                                    data:
                                        'End : ${getDateFormat(addScheduleModel!.endDate!.split(' ')[0])}  at: ${getTime(addScheduleModel!.endTime!)}'),
                              if (addScheduleModel!.duration != null)
                                CustomDetailsField(
                                    data:
                                        'Duration  : ${addScheduleModel!.recurrType!}'),
                              if (addScheduleModel!.duration != null)
                                CustomDetailsField(
                                    data:
                                        'No of Jobs  : ${addScheduleModel!.totalJobs!}'),
                              if (Provider.of<JobScheduleProvider>(context)
                                  .reccurrDateList
                                  .isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    showDates = !showDates;
                                    setState(() {});
                                  },
                                  child: CustomField(
                                    svgPath: addScheduleModel!.jobStatus ==
                                                null ||
                                            Provider.of<JobScheduleProvider>(
                                                        context,
                                                        listen: false)
                                                    .isEdit ==
                                                true
                                        ? 'assets/images/down_arrow.svg'
                                        : 'assets/images/grid 1.svg',
                                    title: 'Your Dates for the recurring job',
                                    isDone: false,
                                  ),
                                ),
                              Gap(10.ss),
                              if (Provider.of<JobScheduleProvider>(context)
                                  .reccurrDateList
                                  .isNotEmpty)
                                Offstage(
                                  offstage: !showDates,
                                  child: Column(
                                    children: [
                                      ...Provider.of<JobScheduleProvider>(
                                              context)
                                          .reccurrDateList
                                          .map(
                                            (e) => CustomDetailsField(
                                              data:
                                                  'From : ${getRecurrDateTimeFormat(e.startTime ?? '')}\nTo      : ${getRecurrDateTimeFormat(e.endTime ?? '')}',
                                            ),
                                          )
                                          .toList(),
                                    ],
                                  ),
                                ),

                              Gap(10.ss),
                              GestureDetector(
                                onTap: () => showMyDialog('service'),
                                child: CustomField(
                                  hasData:
                                      hasService == null ? true : hasService!,
                                  svgPath:
                                      addScheduleModel!.jobStatus == null ||
                                              Provider.of<JobScheduleProvider>(
                                                          context,
                                                          listen: false)
                                                      .isEdit ==
                                                  true
                                          ? 'assets/images/Pencil.svg'
                                          : 'assets/images/grid 1.svg',
                                  title: 'Service',
                                  isDone: false,
                                  ifMandatory: true,
                                ),
                              ),
                              if (addScheduleModel!.serviceList != null)
                                if (addScheduleModel!.serviceList!.isNotEmpty)
                                  CustomDetailsField(
                                      data: addScheduleModel!.serviceList!
                                          .map((e) => e.serviceName!)
                                          .toList()
                                          .join(', ')),
                              // Gap(10.ss),
                              Gap(10.ss),
                              GestureDetector(
                                onTap: () => showMyDialog('staff'),
                                child: CustomField(
                                  svgPath:
                                      addScheduleModel!.jobStatus == null ||
                                              Provider.of<JobScheduleProvider>(
                                                          context,
                                                          listen: false)
                                                      .isEdit ==
                                                  true
                                          ? 'assets/images/Pencil.svg'
                                          : 'assets/images/grid 1.svg',
                                  title: 'Staff',
                                  isDone: false,
                                  ifMandatory: false,
                                ),
                              ),
                              if (addScheduleModel!.staffList != null)
                                if (addScheduleModel!.staffList!.isNotEmpty)
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: CustomDetailsField(
                                      data: addScheduleModel!.staffList!
                                          .map((e) => e.staffName)
                                          .toList()
                                          .join(', '),
                                    ),
                                  ),
                              Gap(10.ss),

                              GestureDetector(
                                onTap: () {
                                  showMyDialog('customer');
                                },
                                //showMyDialog('customer'),
                                child: CustomField(
                                  svgPath:
                                      addScheduleModel!.jobStatus == null ||
                                              Provider.of<JobScheduleProvider>(
                                                          context,
                                                          listen: false)
                                                      .isEdit ==
                                                  true
                                          ? 'assets/images/Pencil.svg'
                                          : 'assets/images/grid 1.svg',
                                  title: 'Customer',
                                  isDone: false,
                                ),
                              ),
                              Gap(2.ss),
                              if (addScheduleModel!.customer != null &&
                                  addScheduleModel!.customer!.isNotEmpty)
                                CustomDetailsField(
                                  data: List.generate(
                                      addScheduleModel!.customer!.length,
                                      (index) {
                                    return '${addScheduleModel!.customer![index].customerName}: ${addScheduleModel!.customer![index].serviceEntityName!.join(', ')}';
                                  }).join('\n'),
                                ),
                              // Row(
                              //   children: List.generate(
                              //       addScheduleModel!.customer!.length,
                              //       (index) => Expanded(
                              //             child: CustomDetailsField(
                              //               data:
                              //                   'Cust: ${addScheduleModel!.customer![index].customerName} Service Object: ${addScheduleModel!.customer![index].serviceEntityId!.join(', ')}',
                              //             ),
                              //           )),
                              // ),
                              // Expanded(
                              //   child: ListView.builder(
                              //     itemCount:
                              //         addScheduleModel!.customer!.length,
                              //     itemBuilder:
                              //         (BuildContext context, int index) {
                              //       var customer =
                              //           addScheduleModel!.customer![index];
                              //       return Text(
                              //         'Cust: ${customer.customerName} Service Object: ${customer.serviceEntityId!.join(', ')}',
                              //       );
                              //     },
                              //   ),
                              // ),
                              // CustomDetailsField(
                              //     data:
                              //         '${addScheduleModel!.customer!.map((e) => Text(
                              //               'Cust: ${e.customerName} Service Object: ${e.serviceEntityId!.join(',')}',
                              //               style:
                              //                   TextStyle(color: Colors.red),
                              //             ))}'),
                              Gap(10.ss),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: () => showMyDialog('location'),
                                      child: CustomField(
                                        svgPath: addScheduleModel!.jobStatus ==
                                                    null ||
                                                Provider.of<JobScheduleProvider>(
                                                            context,
                                                            listen: false)
                                                        .isEdit ==
                                                    true
                                            ? 'assets/images/Pencil.svg'
                                            : 'assets/images/grid 1.svg',
                                        title: 'Location',
                                        isDone: false,
                                      ),
                                    ),
                                  ),
                                  if (addScheduleModel!.location != null)
                                    if (addScheduleModel!.location!.isNotEmpty)
                                      if (addScheduleModel!.location! !=
                                          "Customer-Site")
                                        if (addScheduleModel!.location! !=
                                            "On-Site")
                                          GestureDetector(
                                            onTap: () async {
                                              await Provider.of<
                                                          JobScheduleProvider>(
                                                      context,
                                                      listen: false)
                                                  .getLocationFromAddress(
                                                      (addScheduleModel!
                                                          .location!
                                                          .toString()));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15.0),
                                              child: Container(
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.0),
                                                    child: SvgPicture.asset(
                                                      'assets/images/map-color-icon.svg',
                                                      width: 30.ss,
                                                    ),
                                                  )),
                                            ),
                                          )
                                ],
                              ),
                              if (addScheduleModel!.location != null)
                                if (addScheduleModel!.location!.isNotEmpty)
                                  CustomDetailsField(
                                      data: addScheduleModel!.location!),
                              // Gap(10.ss),

                              Gap(10.ss),
                              GestureDetector(
                                onTap: () => showMyDialog('material'),
                                child: CustomField(
                                  svgPath:
                                      addScheduleModel!.jobStatus == null ||
                                              Provider.of<JobScheduleProvider>(
                                                          context,
                                                          listen: false)
                                                      .isEdit ==
                                                  true
                                          ? 'assets/images/Pencil.svg'
                                          : 'assets/images/grid 1.svg',
                                  title: 'Material',
                                  isDone: false,
                                ),
                              ),
                              if (addScheduleModel!.materialList != null)
                                if (addScheduleModel!.materialList!.isNotEmpty)
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: CustomDetailsField(
                                      data: addScheduleModel!.materialList!
                                          .map((e) => e.materialName!)
                                          .toList()
                                          .join(', '),
                                    ),
                                  ),
                              Gap(10.ss),
                              CustomField(
                                svgPath: addScheduleModel!.jobStatus == null ||
                                        Provider.of<JobScheduleProvider>(
                                                    context,
                                                    listen: false)
                                                .isEdit ==
                                            true
                                    ? 'assets/images/Pencil.svg'
                                    : 'assets/images/grid 1.svg',
                                title: 'History Record',
                                isDone: false,
                              ),
                              // if (model.note != null && model.note!.isNotEmpty)
                              model.customer != null &&
                                      Provider.of<JobScheduleProvider>(context,
                                              listen: false)
                                          .historyList
                                          .isNotEmpty
                                  ? Row(
                                      children: [
                                        const Expanded(
                                            child: CustomDetailsField(
                                                data:
                                                    'See All The History Notes')),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: TextButton(
                                              onPressed: () {
                                                showMyDialog('historyRecord');
                                              },
                                              child:
                                                  const Text('Read more...')),
                                        )
                                      ],
                                    )
                                  : Visibility(
                                      visible: model.customer != null,
                                      child: CustomDetailsField(
                                          data: 'No History notes available'),
                                    ),

                              Gap(10.ss),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => showMyDialog('write_note'),
                                      child: CustomField(
                                        svgPath: addScheduleModel!.jobStatus ==
                                                    null ||
                                                Provider.of<JobScheduleProvider>(
                                                            context,
                                                            listen: false)
                                                        .isEdit ==
                                                    true
                                            ? 'assets/images/Pencil.svg'
                                            : 'assets/images/grid 1.svg',
                                        title: 'Write / Download Notes',
                                        isDone: false,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (Provider.of<JobScheduleProvider>(
                                                  context,
                                                  listen: false)
                                              .isEdit ==
                                          true) {
                                        await getImage();
                                      } else {
                                        Utils().ShowWarningSnackBar(
                                            context,
                                            'Restricted',
                                            'For any changes please click modify to continue');
                                      }
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: Container(
                                          height: 60,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              size: 35,
                                            ),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                              Gap(10.ss),
                              if (addScheduleModel!.note != null)
                                if (addScheduleModel!.note!.isNotEmpty)
                                  if (addScheduleModel!.note! != "null")
                                    CustomDetailsField(
                                        data: addScheduleModel!.note!),

                              (AddScheduleModel.addSchedule.images != null ||
                                      AddScheduleModel
                                                  .addSchedule.allImageList !=
                                              null &&
                                          AddScheduleModel.addSchedule
                                              .allImageList!.isNotEmpty)
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: SizedBox(
                                          height: 120,
                                          child: ListView(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              if (AddScheduleModel.addSchedule
                                                      .allImageList !=
                                                  null)
                                                ...AddScheduleModel
                                                    .addSchedule.allImageList!
                                                    .asMap()
                                                    .entries
                                                    .map(
                                                      (e) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Stack(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Dialog(
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context); // Close the dialog when tapped
                                                                        },
                                                                        child: Image
                                                                            .network(
                                                                          '${Urls.MEDIA_URL}${e.value.fILENAME!}',
                                                                          fit: BoxFit
                                                                              .contain, // Fit the image within the dialog
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child:
                                                                  Image.network(
                                                                // 'http://182.156.196.67:8085/api/users/downloadMediafile/${e.value.fILENAME!}',
                                                                '${Urls.MEDIA_URL}${e.value.fILENAME!}',
                                                                height: 100,
                                                                width: 80,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                            Positioned(
                                                                top: 1,
                                                                right: 1,
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    if (Provider.of<JobScheduleProvider>(context,
                                                                                listen: false)
                                                                            .isEdit ==
                                                                        true) {
                                                                      print(
                                                                          "zzzImageId--->${e.value.iMAGEID}");
                                                                      model.allImageList!.removeWhere((el) =>
                                                                          el.iMAGEID ==
                                                                          e.value
                                                                              .iMAGEID);
                                                                      List<String>
                                                                          imageIds =
                                                                          model!
                                                                              .imageId
                                                                              .split(',');
                                                                      imageIds.removeWhere((element) =>
                                                                          element ==
                                                                          e.value
                                                                              .iMAGEID);
                                                                      model.imageId =
                                                                          imageIds
                                                                              .join(',');
                                                                      setState(
                                                                          () {});
                                                                      // for (var i =
                                                                      //         0;
                                                                      //     i < model.allImageList!.length;
                                                                      //     i++) {
                                                                      //   print(
                                                                      //       "model.imageLIst--->${model.allImageList![i].iMAGEID}");
                                                                      // }
                                                                      // model.allImageList!.removeWhere((element) =>
                                                                      //     element
                                                                      //         .iMAGEID ==
                                                                      //     e.value
                                                                      //         .iMAGEID);
                                                                      print(
                                                                          "model.allImageList----->${model.allImageList}");
                                                                      print(
                                                                          "model.mainImageList----->${model.copyImages}");
                                                                      //
                                                                      // setState(() {
                                                                      //
                                                                      // });

                                                                      // print('Delete');
                                                                      //
                                                                      // if(!Provider.of<JobScheduleProvider>(
                                                                      //     context,
                                                                      //     listen:
                                                                      //     false)
                                                                      //     .temporaryImageIdList.contains(e.value.iMAGEID)){
                                                                      //   Provider.of<JobScheduleProvider>(
                                                                      //       context,
                                                                      //       listen:
                                                                      //       false)
                                                                      //       .temporaryImageIdList
                                                                      //       .add(e
                                                                      //       .value
                                                                      //       .iMAGEID
                                                                      //       .toString());
                                                                      // }
                                                                      //
                                                                      // Provider.of<JobScheduleProvider>(
                                                                      //     context,
                                                                      //     listen:
                                                                      //     false)
                                                                      //     .temporaryImageIdList.forEach((element) {
                                                                      //    print(element);
                                                                      // });
                                                                      //
                                                                      //
                                                                      // Provider.of<JobScheduleProvider>(
                                                                      //         context,
                                                                      //         listen:
                                                                      //             false)
                                                                      //     .temporaryImageIdList
                                                                      //     .add(e
                                                                      //         .value
                                                                      //         .iMAGEID
                                                                      //         .toString());
                                                                      // AddScheduleModel
                                                                      //     .addSchedule
                                                                      //     .allImageList!
                                                                      //     .removeAt(
                                                                      //         e.key);
                                                                      // setState(
                                                                      //     () {});
                                                                    } else {
                                                                      Utils().ShowWarningSnackBar(
                                                                          context,
                                                                          'Restricted',
                                                                          'For any changes please click modify to continue');
                                                                    }
                                                                  },
                                                                  child:
                                                                      ClipOval(
                                                                    child:
                                                                        Material(
                                                                      color: Colors
                                                                          .red,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              if (AddScheduleModel
                                                      .addSchedule.images !=
                                                  null)
                                                ...AddScheduleModel
                                                    .addSchedule.images!
                                                    .asMap()
                                                    .entries
                                                    .map(
                                                      (e) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Stack(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Dialog(
                                                                      child:
                                                                          GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context); // Close the dialog when tapped
                                                                        },
                                                                        child: Image
                                                                            .file(
                                                                          File(
                                                                            e.value.path,
                                                                          ),
                                                                          // height:
                                                                          //     400,
                                                                          // width:
                                                                          //     80,
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              child: Image.file(
                                                                File(
                                                                  e.value.path,
                                                                ),
                                                                height: 100,
                                                                width: 80,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                            Positioned(
                                                                top: 1,
                                                                right: 1,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    if (Provider.of<JobScheduleProvider>(context,
                                                                                listen: false)
                                                                            .isEdit ==
                                                                        true) {
                                                                      AddScheduleModel
                                                                          .addSchedule
                                                                          .images!
                                                                          .removeAt(
                                                                              e.key);
                                                                      setState(
                                                                          () {});
                                                                    } else {
                                                                      Utils().ShowWarningSnackBar(
                                                                          context,
                                                                          'Restricted',
                                                                          'For any changes please click modify to continue');
                                                                    }
                                                                  },
                                                                  child:
                                                                      ClipOval(
                                                                    child:
                                                                        Material(
                                                                      color: Colors
                                                                          .red,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .close,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                            ],
                                          )),
                                    )
                                  : SizedBox(),

                              // Gap(10.ss),

                              Gap(10.ss),
                              Offstage(
                                offstage:
                                    !AddScheduleModel.addSchedule.isAdding,
                                child: GestureDetector(
                                  onTap: () => showMyDialog('payment'),
                                  child: CustomField(
                                    svgPath: addScheduleModel!.jobStatus ==
                                                null ||
                                            Provider.of<JobScheduleProvider>(
                                                        context,
                                                        listen: false)
                                                    .isEdit ==
                                                true
                                        ? 'assets/images/Pencil.svg'
                                        : 'assets/images/grid 1.svg',
                                    title: 'Payment Terms',
                                    isDone: false,
                                  ),
                                ),
                              ),
                              if (Provider.of<JobScheduleProvider>(context)
                                          .isPaymentDone ==
                                      true &&
                                  Provider.of<JobScheduleProvider>(context,
                                              listen: false)
                                          .selectedValue !=
                                      null)
                                CustomDetailsField(
                                  data: (() {
                                    final jobScheduleProvider =
                                        Provider.of<JobScheduleProvider>(
                                            context);
                                    if (jobScheduleProvider.selectedValue ==
                                        'PayLater') {
                                      return 'PayLater,  Dur: ${jobScheduleProvider.selectedPayLetterDurationValue},  Deposit: \$${jobScheduleProvider.depositAmount ?? '0'}';
                                    } else {
                                      return '${jobScheduleProvider.selectedValue}, Deposit: \$${jobScheduleProvider.depositAmount ?? '0'}';
                                    }
                                  })(),
                                ),
                              const Gap(20),

                              const Gap(10),

                              Row(
                                children: [
                                  // if (dropDownValue == 0)
                                  Provider.of<JobScheduleProvider>(context)
                                              .isEdit ==
                                          true
                                      ? Expanded(
                                          child: GestureDetector(
                                              onTap: () async {
                                                log("model.imageId----->${addScheduleModel!.imageId}");
                                                log("model.allImageList------>${addScheduleModel!.allImageList}");
                                                log("model.copyImageList------>${addScheduleModel!.copyImages}");

                                                if (addScheduleModel!
                                                        .serviceList ==
                                                    null) {
                                                  hasService = false;
                                                }

                                                // log("")
                                                AddScheduleModel model =
                                                    AddScheduleModel
                                                        .addSchedule;
                                                // for (var i = 0;
                                                //     i < model.images!.length;
                                                //     i++) {
                                                //   print('obj1');
                                                //   ScheduleAPIClientImpl()
                                                //       .addImage(
                                                //           image:
                                                //               model.images![i]);
                                                // }

                                                // String date = Provider.of<
                                                //             JobScheduleProvider>(
                                                //         context,
                                                //         listen: false)
                                                //     .date;

                                                // String date0 = date.length > 10
                                                //     ? date.split(' ')[0]
                                                //     : date;
                                                print("model----->$model");
                                                if (model.validateServiceEntry(
                                                    context)) {
                                                  setState(() {});
                                                  GoRouter.of(context)
                                                      .pushNamed(
                                                    'preview',
                                                  );

                                                  addScheduleModel!.jobStatus !=
                                                          null
                                                      ? Provider.of<
                                                                  JobScheduleProvider>(
                                                              context,
                                                              listen: false)
                                                          .changeEdit(false)
                                                      : null;
                                                } else {
                                                  _scrollController.animateTo(
                                                    0.0,
                                                    duration: const Duration(
                                                        milliseconds: 800),
                                                    curve: Curves.easeInOut,
                                                  );
                                                }
                                              },
                                              child: const CustomButton(
                                                  title: 'Preview')))
                                      : Expanded(
                                          child: GestureDetector(
                                              onTap: () async {
                                                setState(() {});
                                                Provider.of<JobScheduleProvider>(
                                                        context,
                                                        listen: false)
                                                    .changeEdit(true);
                                                setState(() {
                                                  // canEdit = true;
                                                  addScheduleModel!.isAdding =
                                                      false;
                                                  addScheduleModel!.isEdit =
                                                      true;
                                                  // storePrevValue();
                                                  // _prevDataModel = addScheduleModel;
                                                });

                                                await scrollToTop(true);
                                              },
                                              child: const CustomButton(
                                                  title: 'Modify'))),

                                  Expanded(
                                      child: GestureDetector(
                                          onTap: () {
                                            if (model.allImageList != null) {
                                              model.allImageList!.clear();
                                              model.allImageList!
                                                  .addAll(model!.copyImages!);
                                            }

                                            Provider.of<JobScheduleProvider>(
                                                    context,
                                                    listen: false)
                                                .clearAllPayment();
                                            //----------clearing recur state-----------//
                                            // Provider.of<JobScheduleProvider>(
                                            //         context,
                                            //         listen: false)
                                            //     .reccurrDateList
                                            //     .clear();
                                            // addScheduleModel!.duration = null;
                                            // addScheduleModel!.totalJobs = null;
                                            //-----------------------------------------//

                                            if (Provider.of<JobScheduleProvider>(
                                                        context,
                                                        listen: false)
                                                    .isEdit ==
                                                false) {
                                              addScheduleModel!.images = null;
                                              if (model.images != null) {
                                                model.images!.clear();
                                              }
                                              //---------clearing recur value-----------//
                                              Provider.of<JobScheduleProvider>(
                                                      context,
                                                      listen: false)
                                                  .reccurrDateList
                                                  .clear();
                                              addScheduleModel!.duration = null;
                                              addScheduleModel!.totalJobs =
                                                  null;
                                              //---------------------------------------//
                                              GoRouter.of(context).pop();
                                            } else if (addScheduleModel!
                                                    .jobStatus ==
                                                null) {
                                              print(
                                                  "this function calling because of addScheduleModel!.jobStatus ==null condition");

                                              GoRouter.of(context).pop();
                                            } else {
                                              print(
                                                  "this function calling because of remaining else condition");
                                              cancelChanges();
                                              print(
                                                  "isEditValue========>${Provider.of<JobScheduleProvider>(context, listen: false).isEdit}");
                                              Provider.of<JobScheduleProvider>(
                                                      context,
                                                      listen: false)
                                                  .changeEdit(false);
                                              // Provider.of<JobScheduleProvider>(
                                              //         context,
                                              //         listen: false)
                                              //     .temporaryPkMediaIdList
                                              //     .clear();

                                              scrollToTop(false);
                                              setState(() {});
                                            }
                                          },
                                          child: const CustomButton(
                                              title: 'Cancel'))),
                                ],
                              ),
                              const Gap(20),
                              addScheduleModel!.isAdding == false
                                  ? Visibility(
                                      visible:
                                          // addScheduleModel!.jobStatus != null
                                          Provider.of<JobScheduleProvider>(
                                                context,
                                              ).isEdit ==
                                              false,
                                      child: Row(
                                        children: [
                                          // if (dropDownValue == 1 ||
                                          //     addScheduleModel!.jobStatus == 1)
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                Provider.of<JobScheduleProvider>(
                                                        context,
                                                        listen: false)
                                                    .getJobStatus(
                                                        jobId: model.jobId
                                                            .toString());
                                                log("model.customer : ${model.customer!.length}");
                                                log("model.staff : ${model.staffList!.length}");
                                                if (model
                                                        .customer!.isNotEmpty &&
                                                    model.staffList!
                                                        .isNotEmpty) {
                                                  showCupertinoDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return CupertinoAlertDialog(
                                                        content: RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              const TextSpan(
                                                                text:
                                                                    'Current Job Status: ',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xff093d52),
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                              // TextSpan(
                                                              //     text:
                                                              //         '${model!.jobStatus.runtimeType},',
                                                              //     style: TextStyle(
                                                              //         color: Colors
                                                              //             .black)),
                                                              TextSpan(
                                                                text: model!.jobStatus !=
                                                                        null
                                                                    ? model!.jobStatus ==
                                                                            0
                                                                        ? 'OPEN'
                                                                        : model!.jobStatus ==
                                                                                1
                                                                            ? 'COMPLETED'
                                                                            : model!.jobStatus == 2
                                                                                ? 'ATTEMPTED'
                                                                                : model!.jobStatus == 3
                                                                                    ? 'WIP'
                                                                                    : 'CLOSED-NA'
                                                                    : '',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 17,
                                                                  color: addScheduleModel!
                                                                              .jobStatus !=
                                                                          null
                                                                      ? addScheduleModel!.jobStatus ==
                                                                              0
                                                                          ? Colors
                                                                              .red // Change color to red for OPEN
                                                                          : addScheduleModel!.jobStatus ==
                                                                                  1
                                                                              ? Colors
                                                                                  .green // Change color to green for COMPLETED
                                                                              : const Color(
                                                                                  0xff093d52) // Default color
                                                                      : const Color(
                                                                          0xff093d52), // Default color
                                                                ),
                                                              ),
                                                              const TextSpan(
                                                                text:
                                                                    '\nAre you sure, you want create Invoice ?',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xff093d52),
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: [
                                                          CupertinoButton(
                                                            child: const Text(
                                                              'Yes, Create',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              //-------------new implementation of invoice--------------//
                                                              // Provider.of<JobScheduleProvider>(
                                                              //         context,
                                                              //         listen:
                                                              //             false)
                                                              //     .isEdit = true;
                                                              // Provider.of<JobScheduleProvider>(
                                                              //         context,
                                                              //         listen:
                                                              //             false)
                                                              //     .generateInvocie(
                                                              //         context);
                                                              // setState(() {
                                                              //   dropDownValue =
                                                              //       addScheduleModel!
                                                              //           .jobStatus!;
                                                              // });
                                                              // setState(() {});
                                                              context.pop();
                                                              // showMyDialog(
                                                              //     'selectCustomer');
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return Dialog(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12.0),
                                                                    ),
                                                                    child:
                                                                        StatefulBuilder(
                                                                      builder:
                                                                          (context,
                                                                              setState) {
                                                                        return AddCustomerForInvoice(
                                                                          addScheduleModel:
                                                                              addScheduleModel!,
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          ),
                                                          CupertinoButton(
                                                            child: const Text(
                                                              'No',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            onPressed: () {
                                                              context.pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else if (model
                                                        .customer!.isEmpty &&
                                                    model.staffList!.isEmpty) {
                                                  Utils().ShowWarningSnackBar(
                                                      context,
                                                      'Validation',
                                                      'Please Add Customer & Staff');
                                                } else if (model
                                                    .customer!.isEmpty) {
                                                  Utils().ShowWarningSnackBar(
                                                      context,
                                                      'Validation',
                                                      'Please Add Customer');
                                                } else {
                                                  Utils().ShowWarningSnackBar(
                                                      context,
                                                      'Validation',
                                                      'Please Add Staff');
                                                }

                                                // context.go();
                                              },
                                              child:
                                                  Provider.of<JobScheduleProvider>(
                                                              context)
                                                          .loading
                                                      ? const SizedBox(
                                                          width: 30,
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                  'Getting your invoice ready'),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              LinearProgressIndicator(),
                                                            ],
                                                          ))
                                                      : const CustomButton(
                                                          title:
                                                              'Create Invoice'),
                                            ),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                showCupertinoDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return CupertinoAlertDialog(
                                                      content: const Text(
                                                        'Are you sure, you want to delete this job ?',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff093d52),
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                      actions: [
                                                        CupertinoButton(
                                                          child: const Text(
                                                            'Yes, Delete',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            context.pop();
                                                            Provider.of<JobScheduleProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .deleteSchedule(
                                                              context,
                                                              addScheduleModel!
                                                                  .jobId!,
                                                            );
                                                          },
                                                        ),
                                                        CupertinoButton(
                                                          child:
                                                              const Text('No'),
                                                          onPressed: () {
                                                            context.pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: const CustomDeleteButton(
                                                title: 'Delete Job',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              const Gap(15),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  Future<dynamic> statusChangeConfimDialouge(
    BuildContext context,
    int val,
  ) async {
    var result = showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          content: const Text(
            'Are you sure, you want to change the job status ?',
            style: TextStyle(
              color: Color(0xff093d52),
              fontSize: 17,
            ),
          ),
          actions: [
            CupertinoButton(
              child: const Text('Yes'),
              onPressed: () {
                context.pop('Yes');
              },
            ),
            CupertinoButton(
              child: const Text('No'),
              onPressed: () {
                context.pop('No');
              },
            ),
          ],
        );
      },
    );

    return result;
  }

  Future<dynamic> createInvoiceConfimDialouge(
      BuildContext context, String title, String description) async {
    var result = showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text(
            title ?? '',
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Color(0xff093d52),
                fontSize: 17,
                fontWeight: FontWeight.w500),
          ),
          content: Text(
            description,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color(0xff093d52),
              fontSize: 15,
            ),
          ),
          actions: [
            CupertinoButton(
              child: const Text('Yes'),
              onPressed: () {
                context.pop('Yes');
              },
            ),
            CupertinoButton(
              child: const Text('No'),
              onPressed: () {
                context.pop('No');
              },
            ),
          ],
        );
      },
    );

    return result;
  }

  getDateFormat(String date) {
    int day = int.parse(date.split('-')[2]);
    int month = int.parse(date.split('-')[1]);
    int year = int.parse(date.split('-')[0]);

    return DateFormat.yMMMd().format(DateTime(year, month, day)).toString();
  }

  // getTimeFormat(String value) {
  //   String time = value.split(" ")[0];

  //   String hour = int.parse(time.split(":")[0]) > 12
  //       ? '${int.parse(time.split(":")[0]) - 12}'
  //       : time.split(":")[0];

  //   String minute = time.split(":")[1];

  //   String timeOfDay = int.parse(time.split(":")[0]) >= 12 ? "PM" : "AM";

  //   String resHour = hour.length < 2 ? '0$hour' : hour;
  //   String resMinute = minute.length < 2 ? '0$minute' : minute;

  //   String resTime = '$resHour:$resMinute $timeOfDay';

  //   return resTime;
  // }

  String getRecurrDateTimeFormat(String value) {
    String date = value.split(" ")[0];
    String time = value.split(" ")[1];

    int day = int.parse(date.split('-')[2]);
    int month = int.parse(date.split('-')[1]);
    int year = int.parse(date.split('-')[0]);

    String hour = int.parse(time.split(":")[0]) > 12
        ? '${int.parse(time.split(":")[0]) - 12}'
        : time.split(":")[0];

    String minute = time.split(":")[1];

    String timeOfDay = int.parse(time.split(":")[0]) >= 12 ? "PM" : "AM";

    String resHour = hour.length < 2 ? '0$hour' : hour;
    String resMinute = minute.length < 2 ? '0$minute' : minute;

    String resTime = '$resHour:$resMinute $timeOfDay';

    return ' ${DateFormat.yMMMd().format(DateTime(year, month, day))}, $resTime';
  }

  bool createJobStatus() {
    print('In create');
    String startDate = addScheduleModel!.startDate!;
    String startTime = "${addScheduleModel!.startTime!}  Time";

    print(startDate);
    print(startTime);

    String dayValue = startDate.split('-')[2];
    int day = dayValue.contains(" ")
        ? int.parse(dayValue.split(" ")[0])
        : int.parse(dayValue);

    DateTime startDateTime = DateTime(
      int.parse(startDate.split('-')[0]),
      int.parse(startDate.split('-')[1]),
      day,
      int.parse(startTime.split(' ')[0].toString().split(':')[0]),
      int.parse(startTime.split(' ')[0].toString().split(':')[1]),
    );

    DateTime now = DateTime.now();

    print('here at drop down');

    if (now.isBefore(startDateTime)) {
      ///todo: job is created
      ///
      /// todo: no complete option
      ///
      return true;
    } else {
      ///todo: job is ongoing or done
      ///
      /// todo: complete button will be enabled
      ///
      ///
      return false;
    }
  }

  bool checkCustomerModificationStatus() {
    String startDate = addScheduleModel!.startDate!;
    String startTime = addScheduleModel!.startTime!;
    String endDate = addScheduleModel!.endDate!;
    String endTime = addScheduleModel!.endTime!;

    String dayValue = startDate.split('-')[2];
    int day = dayValue.contains(" ")
        ? int.parse(dayValue.split(" ")[0])
        : int.parse(dayValue);

    DateTime startDateTime = DateTime(
      int.parse(startDate.split('-')[0]),
      int.parse(startDate.split('-')[1]),
      day,
      int.parse(startTime.split(' ')[0].toString().split(':')[0]),
      int.parse(startTime.split(' ')[0].toString().split(':')[1]),
    );

    DateTime endDateTime = DateTime(
      int.parse(endDate.split('-')[0]),
      int.parse(endDate.split('-')[1]),
      day,
      int.parse(endTime.split(' ')[0].toString().split(':')[0]),
      int.parse(endTime.split(' ')[0].toString().split(':')[1]),
    );

    DateTime now = DateTime.now();

    print(now);

    if (now.isBefore(startDateTime) && now.isBefore(endDateTime)) {
      print('check permission true');

      ///todo: job is created
      ///
      /// todo: customer modification enabled
      ///
      return true;
    } else {
      print('check permission else');

      ///todo: job is ongoing or done
      ///
      /// todo: customer modification disabled
      ///
      ///
      return false;
    }
  }

  void showMyDialog(String str, [String? time]) {
    print('Dropdown vlaue: $dropDownValue');
    print(
        'Editable: ${Provider.of<JobScheduleProvider>(context, listen: false).isEdit}');

    if (Provider.of<JobScheduleProvider>(context, listen: false).isEdit ==
        true) {
      Provider.of<TitleProvider>(context, listen: false).changeTitle('');

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
              return str == "add_stat_end"
                  ? ChangeNotifierProvider(
                      create: (_) => RecurringNotifier(),
                      child: const AddStartEnd(),
                    )
                  : str == "customer"
                      ? CustomerViewPage(
                          onCustomerAdd: (val) {
                            context.pop();
                            GoRouter.of(context)
                                .pushNamed('job-add-customer')
                                .then((value) {
                              showMyDialog("customer");
                            });
                          },
                        )
                      : str == "service"
                          ? AddService(
                              onServiceAdd: (val) {
                                context.pop();
                                GoRouter.of(context)
                                    .pushNamed('job-add-service')
                                    .then((value) {
                                  showMyDialog("service");
                                });
                                if (addScheduleModel!.serviceList != null) {
                                  setState(() {
                                    hasService = true;
                                  });
                                }
                              },
                            )
                          : str == "location"
                              ? ChangeNotifierProvider(
                                  create: (_) => LocationNotifier(),
                                  child: const LocationScreen(),
                                )
                              : str == "staff"
                                  ? AddStaffInJob(
                                      onStaffAdd: (val) {
                                        context.pop();
                                        GoRouter.of(context)
                                            .pushNamed('job-add-staff')
                                            .then((value) {
                                          showMyDialog("staff");
                                        });
                                      },
                                    )
                                  : str == "material"
                                      ? AddMaterial(
                                          onMaterialAdd: (val) {
                                            context.pop();
                                            GoRouter.of(context)
                                                .pushNamed('job-add-material')
                                                .then((value) {
                                              showMyDialog("material");
                                            });
                                          },
                                        )
                                      : str == "write_note"
                                          ? const WriteNote()
                                          : str == "payment"
                                              ? const Payment()
                                              : str == "historyRecord"
                                                  ? HistoryRecordPage()
                                                  : Container();
            }),
          );
        },
      ).then((value) async {
        print(value);

        if (value == 'reload-cust') {
          showMyDialog('customer');
        }

        if (value == true) {
          Provider.of<JobScheduleProvider>(context, listen: false)
              .getRecurrDate(context);
        } else if (value == "staff") {
          List recurDateList;
          if (Provider.of<JobScheduleProvider>(context, listen: false)
              .reccurrDateList
              .isNotEmpty) {
            recurDateList =
                Provider.of<JobScheduleProvider>(context, listen: false)
                    .reccurrDateList
                    .map((e) {
              print("ro------->${e.startTime}");
              return {"startTime": e.startTime, "endTime": e.endTime};
            }).toList();
          } else {
            String startDate = addScheduleModel!.startDate!.split(' ')[0];

            int day = int.parse(startDate.split('-')[2]);
            String sDay = day < 10 ? "0$day" : day.toString();

            String sDate =
                '${startDate.split('-')[0]}-${startDate.split('-')[1]}-$sDay';

            String endDate = addScheduleModel!.endDate!.split(' ')[0];

            int day1 = int.parse(endDate.split('-')[2]);
            String eDay = day1 < 10 ? "0$day1" : day1.toString();

            String eDate =
                '${endDate.split('-')[0]}-${endDate.split('-')[1]}-$eDay';

            recurDateList = [
              {
                "startTime":
                    '$sDate ${convertTimeFormatWhileAdding(addScheduleModel!.startTime!)}',
                "endTime":
                    '$eDate ${convertTimeFormatWhileAdding(addScheduleModel!.endTime!)}'
              }
            ];

            // print(
            //     "recurDateList----->${recurDateList}");
          }

          if (addScheduleModel!.staffList != null ||
              addScheduleModel!.staffList!.isNotEmpty) {
            print("addScheduleModel!.jobId-------->${addScheduleModel!.jobId}");
            // if (addScheduleModel!.jobId == null) {
            print("This operation hits");
            Provider.of<JobScheduleProvider>(context, listen: false)
                .getStaffValidation(context, recurDateList);
            // }

            // ------------this is staff validation dont remove-------------//
          }
          setState(() {});
        } else if (value == "edit-staff") {
          List recurDateList = Provider.of<JobScheduleProvider>(context,
                      listen: false)
                  .reccurrDateList
                  .isNotEmpty
              ? Provider.of<JobScheduleProvider>(context, listen: false)
                  .reccurrDateList
                  .map((e) => {"startTime": e.startTime, "endTime": e.endTime})
                  .toList()
              : [
                  {
                    "startTime":
                        '${addScheduleModel!.startDate!.split(' ')[0]} ${convertTimeFormatWhileAdding(addScheduleModel!.startTime!)}',
                    "endTime":
                        '${addScheduleModel!.endDate!.split(' ')[0]} ${convertTimeFormatWhileAdding(addScheduleModel!.endTime!)}'
                  }
                ];

          if (addScheduleModel!.staffList != null ||
              addScheduleModel!.staffList!.isNotEmpty) {
            Provider.of<JobScheduleProvider>(context, listen: false)
                .getStaffValidation(context, recurDateList);
          }
          setState(() {});
        } else if (value == 'check-recur-with-staff') {
          print("check-recur-with-staff calling");
          await Provider.of<JobScheduleProvider>(context, listen: false)
              .getRecurrDate(context);

          await Future.delayed(Duration(seconds: 2));

          print(
              'Check Recurrd Date List: ${Provider.of<JobScheduleProvider>(context, listen: false).reccurrDateList}');

          List recurDateList = Provider.of<JobScheduleProvider>(context,
                      listen: false)
                  .reccurrDateList
                  .isNotEmpty
              ? Provider.of<JobScheduleProvider>(context, listen: false)
                  .reccurrDateList
                  .map((e) => {"startTime": e.startTime, "endTime": e.endTime})
                  .toList()
              : [
                  {
                    "startTime":
                        '${addScheduleModel!.startDate!.split(' ')[0]} ${addScheduleModel!.startTime!.split(" ")[0].split(":").take(2).join(":")}',
                    "endTime":
                        '${addScheduleModel!.endDate!.split(' ')[0]} ${addScheduleModel!.endTime!.split(' ')[0].split(":").take(2).join(":")}'
                  }
                ];

          Provider.of<JobScheduleProvider>(context, listen: false)
              .getStaffValidationOnDate(context, recurDateList);
          setState(() {});
        }
        setState(() {});
      });
    } else {
      Utils().ShowWarningSnackBar(context, 'Restricted',
          'For any changes please click modify to continue');
    }

    setState(() {});
  }

  getImage() async {
    String date = addScheduleModel!.startDate!;
    String slot =
        '${addScheduleModel!.startTime!}${addScheduleModel!.endTime!}';

    await showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () async {
              await ImageController().getImageFromCamera(date, slot);
              setState(() {});
              GoRouter.of(context).pop();
            },
            child: const Text('Open Camera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              await ImageController().getImageFromGallery(date, slot);
              setState(() {});
              GoRouter.of(context).pop();
            },
            child: const Text('Select from gallery'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          /// This parameter indicates the action would perform
          /// a destructive action such as delete or exit and turns
          /// the action's text color to red.
          isDestructiveAction: true,
          onPressed: () {
            GoRouter.of(context).pop();
            // Navigator.pop(context);
          },
          child: const Text('Cancel'), //(152) 635-2475  pA8k1EXo
        ),
      ),
    );
  }
}
