import 'dart:convert';

// import 'dart:html';
import 'package:bizfns/core/route/NavRouter.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:bizfns/core/utils/api_constants.dart';
import 'package:bizfns/features/Admin/Create%20Job/api-client/schedule_api_client_implementation.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/JobScheduleModel/schedule_list_response_model.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/all_pdf_list_model.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/service_entity_question_model.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/staff_validaiton_repsonse_model.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/tax_model.dart';
import 'package:bizfns/features/Admin/Create%20Job/repo/schedule_repo_implementaiton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/common/Status.dart';
import '../core/shared_pref/shared_pref.dart';
import '../core/utils/Utils.dart';
import '../core/utils/bizfns_layout_widget.dart';
import '../core/utils/const.dart';
import '../features/Admin/Create Job/ScheduleJobPages/preview_customer_invoice.dart';
import '../features/Admin/Create Job/ScheduleJobPages/view_all_created_invoices.dart';
import '../features/Admin/Create Job/model/JobScheduleModel/job_schedule_response_model.dart';
import '../features/Admin/Create Job/model/add_schedule_model.dart';
import '../features/Admin/Create Job/model/create_invoice_pdf_model.dart';
import '../features/Admin/Create Job/model/customer_service_history_model.dart';
import '../features/Admin/Create Job/model/get_edit_invoice_model.dart';
import '../features/Admin/Create Job/model/get_status_model.dart';
import '../features/Admin/Create Job/model/invoiced_customer_model.dart';
import '../features/Admin/Create Job/model/reccurr_date_model.dart';
import '../features/Admin/Create Job/model/save_status_model.dart';
import '../features/Admin/Customer/provider/customer_provider.dart';
import '../features/Admin/Material/provider/material_provider.dart';
import '../features/Admin/Service/provider/service_provider.dart';
import '../features/Admin/Staff/provider/staff_provider.dart';
import '../features/Settings/staff_permission_screen.dart';
import '../features/Settings/widget/max_job_task_widget.dart';
import '../features/Settings/widget/reminder_widget.dart';
import '../features/Settings/widget/time_interval_widget.dart';
import '../features/Settings/widget/working_hour_widget.dart';
import '../features/auth/Login/model/login_otp_verification_model.dart';

class JobScheduleProvider extends ChangeNotifier {
  bool loading = false;
  String? pdfUrl;

  int serviceEntityStatus = 0;

  final List<GlobalKey> keys = [];
  final List<Schedule> allSchedule = [];

  // List<String> temporaryPkMediaIdList = [];
  // List<String> temporaryImageIdList = [];
  final List<ReccurrData> reccurrDateList = [];

  // List<HistoryData> allHistoryData = [];
  List<TaxTable> taxList = [];
  List<InvoiceCustomerData> invoicedCustomerData = [];
  bool isInvoiced = false;

  String invNo = '';

  ScheduleModel? schedule;

  int timeIndex = 0;
  int jobIndex = 0;

  String? selectedValue;
  String? selectedPayLetterDurationValue;
  bool? isPaymentDone;
  int? depositAmount;
  bool? isPreview;
  String? newJobStatus;
  List<Hist> historyList = [];

  late JobScheduleProvider timeScheduleController;

  AddScheduleModel? addScheduleModel = AddScheduleModel.addSchedule;

  final ScheduleRepoImplementation scheduleRepo =
      ScheduleRepoImplementation(apiClient: ScheduleAPIClientImpl());

  // String date =
  //     "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

  //assigning date in new methid ->
  String date =
      "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
  String day = DateFormat('EE').format(DateTime.now());

  DateTime? dateTimeToSearch;

  TabController? tabController;

  bool isEdit = false;

  setPreview(bool val) {
    isPreview = true;
    notifyListeners();
  }

  Future<void> _launchUrl(double lat, double long) async {
    if (!await launchUrl(Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${lat},${long}'))) {
      throw Exception('Could not launch ');
    }
  }

  Future<List<Location>?> getLocationFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      print("locations========>$locations");
      double latitude = locations[0].latitude;
      double longitude = locations[0].longitude;
      // print("longitudeString========>$longitudeString");
      // print("longitude========>$longitude");
      _launchUrl(latitude, longitude);
      return locations;
    } catch (e) {
      print("Error getting location from address: $e");
      return null;
    }
  }

  selectedValueOnChange(val) {
    selectedValue = val;
    print("selected value====>$selectedValue");

    notifyListeners();
  }

  selectedPayLetterDurationValueOnChange(val) {
    selectedPayLetterDurationValue = val;
    print(
        "selectedPayLetterDurationValue value====>$selectedPayLetterDurationValue");

    notifyListeners();
  }

  doneYourPayment() {
    isPaymentDone = true;
    model.paymentModeId = selectedValue;
    print("Selected val : ${selectedValue}");
    print("Selected paylater duration val : ${selectedPayLetterDurationValue}");
    if (selectedPayLetterDurationValue != null) {
      model.paymentTypeId = "$selectedPayLetterDurationValue-\$$depositAmount";
      notifyListeners();
    } else {
      model.paymentTypeId = "\$$depositAmount";
      notifyListeners();
    }

    if (selectedValue == "OnReceipt") {
      model.paymentDuration = "1";
    }

    if (selectedPayLetterDurationValue == "Next 30 Days") {
      model.paymentDuration = "2";
    } else if (selectedPayLetterDurationValue == "Next 60 Days") {
      model.paymentDuration = "3";
    } else if (selectedPayLetterDurationValue == "Next 90 Days") {
      model.paymentDuration = "4";
    }

    model.deposit = depositAmount.toString();

    notifyListeners();
  }

  setDepositAmount(int amount) {
    depositAmount = amount;
    notifyListeners();
  }

  clearAllPayment() {
    isPaymentDone = false;
    depositAmount = 0;
    selectedValue = '';
    selectedPayLetterDurationValue = '';
    notifyListeners();
  }

  updateTimeIndex(int incomingTimeIndex, int incomingJobIndex) {
    timeIndex = incomingTimeIndex;
    jobIndex = incomingJobIndex;
    notifyListeners();
  }

  addPrevData(ScheduleModel data) {
    schedule = data;
    notifyListeners();
  }

  changeEdit(bool val) {
    print('Calling Change Edit $val');
    isEdit = val;
    notifyListeners();
  }

  changeData(String selectedDate) {
    date = selectedDate;
    print('Selected Date: $selectedDate');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  getDay() {
    Utils().printMessage('Getting date');
    day = day.isEmpty ? DateFormat('EE').format(DateTime.now()) : day;
    dayCount = getDayCount();
    generateDateList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  int dayCount = 0;

  int getDayCount() {
    if (day == "Sun") {
      return 0;
    } else if (day == "Mon") {
      return 1;
    } else if (day == "Tue") {
      return 2;
    } else if (day == "Wed") {
      return 3;
    } else if (day == "Thu") {
      return 4;
    } else if (day == "Fri") {
      return 5;
    } else if (day == "Sat") {
      return 6;
    } else {
      return 0;
    }
  }

  List<String> dates = [];

  generatePreviousWeek() {
    DateTime _date = DateTime(
      int.parse(date.split('-')[0]),
      int.parse(date.split('-')[1]),
      int.parse(date.length > 10
          ? date.split('-')[2].split(' ')[0]
          : date.split('-')[2]),
    );

    DateTime dateOfLastWeek =
        _date.subtract(Duration(days: dayCount == 0 ? 6 : 7));

    //todo change date
    date = dateOfLastWeek.toString();

    print('Date of Last Week: $date');
    //todo change dayCount

    generateDateList();

    notifyListeners();
  }

  generateNextWeek() {
    DateTime _date = DateTime(
      int.parse(date.split('-')[0]),
      int.parse(date.split('-')[1]),
      int.parse(date.length > 10
          ? date.split('-')[2].split(' ')[0]
          : date.split('-')[2]),
    );

    DateTime dateOfComingWeek = _date.add(const Duration(days: 7));

    //todo change date
    date = dateOfComingWeek.toString();

    print(date);
    //todo change dayCount

    generateDateList();

    notifyListeners();
  }

  generateDateList() {
    Utils().printMessage('Generating');

    dates.clear();

    Utils().printMessage('Generating Date list $dayCount $date');

    DateTime _date = DateTime(
      int.parse(date.split('-')[0]),
      int.parse(date.split('-')[1]),
      int.parse(date.length > 10
          ? date.split('-')[2].split(' ')[0]
          : date.split('-')[2]),
    );

    if (dayCount == 6) {
      Utils().printMessage('Case 1');

      ///todo: generate 6 previous dates
      ///
      ///
      ///

      List<String> _dates = List.generate(
        7,
        (index) => index == 6
            ? '${DateFormat('MMM').format(_date)} \n ${_date.day}'
            : '${DateFormat('MMM').format(_date.subtract(Duration(days: dayCount - index)))} \n ${_date.subtract(Duration(days: dayCount - index)).day}',
      );

      dates.addAll(_dates);
    } else if (dayCount == 0) {
      Utils().printMessage('Case 2');

      ///todo: generate 6 after dates
      ///
      ///

      List<String> _dates = List.generate(
        7,
        (index) => index == 0
            ? '${DateFormat('MMM').format(_date)} \n ${_date.day}'
            : '${DateFormat('MMM').format(_date.add(Duration(days: index - dayCount)))} \n ${_date.add(Duration(days: index - dayCount)).day}',
      );

      _dates.forEach((element) {
        print('Generated: $element');
      });

      dates.addAll(_dates);
    } else {
      Utils().printMessage('Case 3');

      //todo: get count of previous and next values and add

      List<String> _dates = List.generate(
          7,
          (index) => index == dayCount
              ? '${DateFormat('MMM').format(_date)} \n ${_date.day}'
              : index > dayCount
                  ? '${DateFormat('MMM').format(_date.add(Duration(days: index - dayCount)))} \n ${_date.add(Duration(days: index - dayCount)).day}'
                  : index < dayCount
                      ? '${DateFormat('MMM').format(_date.subtract(Duration(days: dayCount - index)))} \n ${_date.subtract(Duration(days: dayCount - index)).day}'
                      : '');

      _dates.remove('');

      dates.addAll(_dates);
    }

    Utils().printMessage('Date length: ${dates.length}');

    dates.forEach((element) {
      print(element);
    });

    notifyListeners();
  }

  changeDay(String selectedDay) {
    day = selectedDay;
    dayCount = getDayCount();
    print('Now Day: $dayCount');
    notifyListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  clearChanges() {
    DateTime dateTime = DateTime.now();
    date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
    day = DateFormat('EE').format(dateTime);
    notifyListeners();
  }

  List<ScheduleData> items = [];

  List<ServiceEntityItems> serviceEntityItems = [];

  String entityType = "";

  int swipeValue = 0;

  getScheduleList(BuildContext context, {int? dragValue}) async {
    Utils().printMessage("==get Schedule Api Call of Date gsl: $date==");
    swipeValue = 0;
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    /*List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();*/
    String? companyId = await GlobalHandler.getCompanyId();
    Utils().printMessage("CompanyId ==>${companyId!}");
    print('Selected Date: $date');
    scheduleRepo.getSchedule(date: date).then((value) async {
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
            keys.clear();
            for (int index = 0; index < list.length; index++) {
              print('Schedule Time: ${list[index].time}');
              if (list[index].time != null) {
                keys.add(GlobalKey(debugLabel: '$index'));
                items.add(
                  ScheduleData(
                    time: list[index].time ?? "",
                    schedule: list[index].schedule ?? [],
                  ),
                );
                //if(list[index].schedule!.isNotEmpty){
                //todo: [Implement Later]
                int totalJobs = 0;

                items.forEach((element) {
                  totalJobs += element.schedule!.length;
                });

                for (int i = 0; i < items.length; i++) {
                  // keys.add(GlobalKey(debugLabel: '$i'));
                }

                //}
              }
            }

            swipeValue = dragValue ?? 0;

            notifyListeners();
            // }
            // } catch (e, stackTrace) {
            //   print(stackTrace.toString());
            //   Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
            // }
          }

          loading = false;
          notifyListeners();
        } catch (e) {
          loading = false;
          Utils().printMessage("STATUS Failure ==>>> " + e.toString());
        }
        notifyListeners();
      } else {
        loading = false;
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        //notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();

    print('Job Schedule has been fetched');

    // notifyListeners();
  }

  AddScheduleModel model = AddScheduleModel.addSchedule;

  addSchedule(BuildContext context, Map<String, dynamic> jsonBody) async {
    Utils().printMessage("==Adding Schedule==");
    print("schedule value=====>$jsonBody");
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());

    // for (var i = 0; i < model.images!.length; i++) {
    //   print('obj1');
    //   await ScheduleAPIClientImpl().addImage(image: model.images![i]);
    //   await Future.delayed(Duration(milliseconds: 100));
    // }

    scheduleRepo.addSchedule(scheduleData: jsonBody).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        try {
          if (value.data != null) {
            print("Value data------------------->${value.data}");
            try {
              if (value.status == STATUS.SUCCESS) {
                Utils().ShowSuccessSnackBar(
                    context, "Success", 'Schedule has been added successfully');
                //getScheduleList(context);
                loading = false;
                model.clearData();
                Provider.of<ServiceProvider>(context, listen: false)
                    .selectedIndex
                    .clear();
                Provider.of<StaffProvider>(context, listen: false)
                    .selectedIndex
                    .clear();
                Provider.of<MaterialProvider>(context, listen: false)
                    .selectedIndex
                    .clear();
                // Navigator.popUntil(context, ModalRoute.withName('home'));
                //GoRouter.of(context).pushNamed('schedule');
                // while (GoRouter.of(context).canPop()) {
                // GoRouter.of(context).pop();
                // }

                await context
                    .read<JobScheduleProvider>()
                    .getScheduleList(context);

                ///todo: get staff list
                ///
                ///
                await context.read<StaffProvider>().getStaffList(context);

                ///todo: get material list
                ///
                ///
                await context
                    .read<MaterialProvider>()
                    .getMaterialListApi(context);

                ///todo: get service list
                ///
                ///
                await context.read<ServiceProvider>().getServiceList(context);
                // timeScheduleController = await Provider.of<JobScheduleProvider>(
                //     context,
                //     listen: false);
                // GoRouter.of(context).goNamed('create-schedule', extra: {
                //   'time': getTime(timeScheduleController
                //       .items[0]
                //       .jobList![Provider.of<JobScheduleProvider>(context,
                //               listen: false)
                //           .timeIndex]
                //       .time!),
                // });
                GoRouter.of(context).pop();
                GoRouter.of(context).goNamed('schedule');
                //Navigate.NavigatePushUntil(context, SCHEDULE_PAGE, params: {});
                notifyListeners();
              } else {
                Utils()
                    .ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
              }
            } catch (e) {
              print(e.toString());
              Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
            }
          }

          loading = false;
          notifyListeners();
        } catch (e) {
          loading = false;
          Utils().printMessage("STATUS Failure ==>>> " + e.toString());
        }
        notifyListeners();
      } else {
        loading = false;
        Utils().printMessage("STATUS FAILED");
        Utils().ShowErrorSnackBar(context, 'Error', 'Can not add schedule');
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();
    // notifyListeners();
  }

  // AddScheduleModel loadData(BuildContext context, ScheduleModel schedule) {
  //   model.isAdding = false;
  //   model.jobId = schedule.pKJOBID;
  //   model.location = schedule.jOBLOCATION;
  //   model.note = schedule.jOBNOTES;
  //   if (model.imageId != null && schedule.imageId != null) {
  //     model.imageId = schedule.imageId!;
  //   }

  //   //
  //   model.startTime = schedule.jOBSTARTTIME;

  //   model.endTime = schedule.jOBENDTIME;

  //   model.jobStatus = int.parse(schedule.jOBSTATUS ?? "0");

  //   model.customer = schedule.customersList != null &&
  //           schedule.customersList!.isNotEmpty
  //       ? schedule.customersList!
  //           .map((e) => CustomerData(
  //                 customerId: e.pKCUSTOMERID.toString(),
  //                 customerName: '${e.cUSTOMERFIRSTNAME} ${e.cUSTOMERLASTNAME}',
  //                 serviceEntityId: e.serviceEntityList!
  //                     .map((e) => e.pKSERVICEENTITY.toString())
  //                     .toList(),
  //                 serviceEntityName: e.serviceEntityList!
  //                     .map((e) => e.sERVICEENTITYNAME.toString())
  //                     .toList(),
  //               ))
  //           .toList()
  //       : [];

  //   model.allImageList = schedule.imageList!.map((e) => e).toList();
  //   // print("allImageList Length=======>${model.allImageList!.length}");

  //   ///todo: load staff
  //   ///
  //   ///
  //   if (Provider.of<StaffProvider>(context, listen: false).loading == false) {
  //     Utils().printMessage('Not loading');
  //     if (Provider.of<StaffProvider>(context, listen: false)
  //         .staffList!
  //         .isNotEmpty) {
  //       Utils().printMessage('Not Empty');

  //       ///todo load all staffs
  //       ///
  //       List<int> staffIDs =
  //           schedule.staffList!.map((e) => e.pKUSERID ?? 0).toList();
  //       List<int> staffIDList =
  //           Provider.of<StaffProvider>(context, listen: false)
  //               .staffList!
  //               .map((e) => int.parse(e.staffId))
  //               .toList();
  //       List<String> staffNames = Provider.of<StaffProvider>(context,
  //               listen: false)
  //           .staffList!
  //           .map((e) =>
  //               '${e.staffFirstName.capitalizeFirst} ${e.staffLastName.capitalizeFirst}')
  //           .toList();

  //       List<StaffID> staffList = [];

  //       for (var element in staffIDs) {
  //         staffList.add(StaffID(
  //           index: staffIDList.indexOf(element),
  //           id: element.toString(),
  //           staffName: staffNames[staffIDList.indexOf(element)],
  //         ));
  //       }

  //       model.staffList = staffList;

  //       // setState(() {});
  //       notifyListeners();
  //     } else {
  //       Utils().printMessage('Empty');
  //     }
  //   } else {
  //     Utils().printMessage('loading');
  //   }

  //   ///todo: load materials
  //   ///
  //   ///
  //   if (Provider.of<MaterialProvider>(context, listen: false).loading ==
  //       false) {
  //     Utils().printMessage('Not loading');
  //     if (Provider.of<MaterialProvider>(context, listen: false)
  //             .materialList
  //             .isNotEmpty &&
  //         schedule.jOBMATERIAL != null) {
  //       Utils().printMessage('Not Empty');

  //       List<int> materialIDs = schedule.jOBMATERIAL == null
  //           ? []
  //           : schedule.jOBMATERIAL!.isEmpty
  //               ? []
  //               : schedule.jOBMATERIAL!
  //                   .map((e) => int.parse(e.pKMATERIALID.toString()))
  //                   .toList();

  //       List<int> materialIDList =
  //           Provider.of<MaterialProvider>(context, listen: false)
  //               .materialList
  //               .map((e) => e.materialId!)
  //               .toList();

  //       List<String> materialNames =
  //           Provider.of<MaterialProvider>(context, listen: false)
  //               .materialList!
  //               .map((e) => e.materialName!.capitalizeFirst!)
  //               .toList();

  //       List<MaterialList> materialList = [];

  //       for (var element in materialIDs) {
  //         materialList.add(MaterialList(
  //           index: materialIDList.indexOf(element),
  //           materialID: element.toString(),
  //           materialName: materialNames[materialIDList.indexOf(element)],
  //         ));
  //       }

  //       model.materialList = materialList;
  //       model.newMaterialList =  schedule.jOBMATERIAL!;

  //       Provider.of<JobScheduleProvider>(context, listen: false)
  //           .getJobStatus(jobId: model!.jobId.toString());

  //       notifyListeners();
  //     } else {
  //       model.materialList = [];
  //       Utils().printMessage('Material Empty');
  //     }
  //   } else {
  //     Utils().printMessage('loading');
  //   }

  //   ///todo: load services
  //   ///
  //   ///
  //   if (Provider.of<ServiceProvider>(context, listen: false).loading == false) {
  //     Utils().printMessage('Not loading');
  //     if (Provider.of<ServiceProvider>(context, listen: false)
  //         .allServiceList!
  //         .isNotEmpty) {
  //       Utils().printMessage('Not Empty');

  //       ///todo get service from schedule model
  //       ///
  //       List<int> serviceIDs =
  //           schedule.serviceList!.map((e) => e.iD ?? 0).toList();
  //       List<int> serviceIDList =
  //           Provider.of<ServiceProvider>(context, listen: false)
  //               .allServiceList
  //               .map((e) => e.serviceId!)
  //               .toList();

  //       List<String> serviceNames =
  //           Provider.of<ServiceProvider>(context, listen: false)
  //               .allServiceList
  //               .map((e) => e.serviceName!.capitalizeFirst!)
  //               .toList();

  //       List<ServiceList> serviceList = [];

  //       for (var element in serviceIDs) {
  //         serviceList.add(ServiceList(
  //           index: serviceIDList.indexOf(element),
  //           serviceID: element.toString(),
  //           serviceName: serviceNames[serviceIDList.indexOf(element)],
  //         ));
  //       }

  //       model.serviceList = serviceList;

  //       notifyListeners();
  //     } else {
  //       Utils().printMessage(' Service Empty');
  //     }
  //   } else {
  //     Utils().printMessage('loading');
  //   }

  //   return model;
  // }

  editSchedule(
      BuildContext context, Map<String, dynamic> jsonBody, String jobID) async {
    timeScheduleController =
        Provider.of<JobScheduleProvider>(context, listen: false);
    Utils().printMessage("==Edit Schedule==");
    print("in edit scchedule data ====>${jsonEncode(jsonBody)}");
    if (model.images != null) {
      log("model.images--->${model.images}");
    }

    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());

    scheduleRepo.editSchedule(scheduleData: jsonBody).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        // try {
        // if (value.data != null) {
        try {
          if (value.status == STATUS.SUCCESS) {
            //------------after successfull editing clearing recur state here-----------//
            Provider.of<JobScheduleProvider>(context, listen: false)
                .reccurrDateList
                .clear();

            model.clearData();
            Provider.of<ServiceProvider>(context, listen: false)
                .selectedIndex
                .clear();
            Provider.of<StaffProvider>(context, listen: false)
                .selectedIndex
                .clear();
            Provider.of<MaterialProvider>(context, listen: false)
                .selectedIndex
                .clear();

            addScheduleModel!.totalJobs = null;

            await Provider.of<JobScheduleProvider>(context, listen: false)
                .getScheduleList(context);

            await context.read<StaffProvider>().getStaffList(context);
            await context.read<MaterialProvider>().getMaterialListApi(context);
            await context.read<ServiceProvider>().getServiceList(context);

            if (addScheduleModel!.images != null) {
              addScheduleModel!.images!.clear();
            }

            await Future.delayed(Duration(seconds: 1));
            Utils().ShowSuccessSnackBar(
                context, "Success", 'Job ID $jobID has been Edit successfully');

            GoRouter.of(context).pop();

            // addScheduleModel!.clearData();
            // temporaryImageIdList.clear();

            // temporaryImageIdList.forEach((element) {
            //   model.allImageList!.removeWhere((element1) => element1.iMAGEID == element);
            // });

            // temporaryPkMediaIdList.clear();
            // temporaryImageIdList.clear();

            GoRouter.of(context).goNamed('schedule');
            // timeScheduleController.items.isNotEmpty
            //     ? GoRouter.of(context).goNamed('create-schedule', extra: {
            //         'time': getTime(timeScheduleController
            //             .items[Provider.of<JobScheduleProvider>(context,
            //                     listen: false)
            //                 .timeIndex]
            //             .time!),
            //       })
            //     : GoRouter.of(context).goNamed('create-schedule', extra: {
            //         'time': '',
            //       });
            notifyListeners();
          } else {
            //------------if error occured clearing recur state here-----------//
            Provider.of<JobScheduleProvider>(context, listen: false)
                .reccurrDateList
                .clear();
            addScheduleModel!.duration = null;
            addScheduleModel!.totalJobs = null;
            addScheduleModel!.clearData();
            if (model.images != null) {
              addScheduleModel!.images!.clear();
            }
            //--------------------------------------------------------------------------//
            Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
          }
        } catch (e) {
          //------------if error occured clearing recur state here-----------//
          Provider.of<JobScheduleProvider>(context, listen: false)
              .reccurrDateList
              .clear();
          addScheduleModel!.duration = null;
          addScheduleModel!.totalJobs = null;
          //--------------------------------------------------------------------------//
          Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
        }
        // }

        loading = false;
        notifyListeners();
        // } catch (e) {
        //   loading = false;
        //   Utils().printMessage("STATUS Failure ==>>> " + e.toString());
        // }
        notifyListeners();
      } else {
        loading = false;
        Utils().printMessage("STATUS FAILED");
        Utils().ShowErrorSnackBar(context, 'Error', '${value.message}');
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();
    notifyListeners();
  }

  deleteSchedule(BuildContext context, String jobID) async {
    Utils().printMessage("==Delete Schedule==");
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());

    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    String? companyId = await GlobalHandler.getCompanyId();

    Map<String, dynamic> data = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "userId": userId,
      "tenantId": companyId,
      "jobId": jobID
    };

    scheduleRepo.deleteSchedule(scheduleData: data).then((value) async {
      //for now snackbar is showing because of delete api throwing error
      Utils().ShowSuccessSnackBar(
          context, "Success", 'Schedule has been deleted successfully');
      getScheduleList(context);
      model.clearData();
      context.pop();
      notifyListeners();
      // if (value.status == STATUS.SUCCESS) {
      //   try {
      //     if (value.data != null) {
      //       try {
      //         if (value.status == STATUS.SUCCESS) {
      //           Utils().ShowSuccessSnackBar(context, "Success",
      //               'Schedule has been deleted successfully');
      //           getScheduleList(context);
      //           model.clearData();
      //           context.pop();
      //           //Navigate.NavigateAndReplace(context, SCHEDULE_PAGE, params: {});
      //           notifyListeners();
      //         } else {
      //           Utils()
      //               .ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
      //         }
      //       } catch (e) {
      //         print(e.toString());
      //         Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
      //       }
      //     }

      //     loading = false;
      //     notifyListeners();
      //   } catch (e) {
      //     loading = false;
      //     Utils().printMessage("STATUS Failure ==>>> " + e.toString());
      //   }
      //   notifyListeners();
      // } else {
      //   loading = false;
      //   Utils().printMessage("STATUS FAILED");
      //   if (value.message == TOKEN_EXPIRED) {
      //     Utils.Logout(context);
      //   }
      //   notifyListeners();
      //   notifyListeners();
      // }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();
    // notifyListeners();
  }

  reScheduleJob(BuildContext context,
      {required String jobID,
      required String endTime,
      required String startTime}) async {
    Utils().printMessage("==Doing Re-Schedule==");
    print(
        "==========updatedTimeSlot========> jobId-${jobID},startTime-${startTime},endTime-${endTime}");
    // loading = true;
    // print("Loading-->${loading}");
    // EasyLoading.show(
    //     status: "Loading", indicator: const CircularProgressIndicator());

    scheduleRepo
        .reSchedule(
      jobID: jobID,
      startTime: startTime,
      endTime: endTime,
    )
        .then((value) async {
      print("vallllllll======>$value");
      // Utils().printMessage(value!.status!.toString());
      // Utils().printMessage(value!.data!.toString());
      // Utils().printMessage(value!.message!.toString());
      if (value.status == STATUS.SUCCESS) {
        try {
          if (value.data != null) {
            try {
              if (value.status == STATUS.SUCCESS) {
                Utils().ShowSuccessSnackBar(context, "Success",
                    'Schedule has been updated with different time slot');
                getScheduleList(context);
                notifyListeners();
              } else {
                Utils()
                    .ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
              }
            } catch (e) {
              print(e.toString());
              Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
            }
          }

          // loading = false;
          print("Loading-->${loading}");
          notifyListeners();
        } catch (e) {
          loading = false;
          Utils().printMessage("STATUS Failure ==>>> " + e.toString());
        }
        notifyListeners();
      } else {
        loading = false;
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();
    // notifyListeners();
  }

  getServiceEntity(BuildContext context) async {
    serviceEntityStatus = 0;

    Utils().printMessage("==get Schedule Api Call of Date gse: $date==");

    serviceEntityItems.clear();

    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    /*List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();*/
    String? companyId = await GlobalHandler.getCompanyId();
    Utils().printMessage("CompanyId ==>" + companyId!);
    print('Selected Date: $date');
    scheduleRepo.getServiceEntityQuestion().then((value) async {
      if (value.status == STATUS.SUCCESS) {
        try {
          if (value.data != null) {
            ServiceEntityQuestionModel resp =
                value.data as ServiceEntityQuestionModel;

            try {
              List<ServiceEntityItems> list = resp.data!.serviceEntityItems!;
              if (list != null) {
                print('Length: ${list.length}');
                print(
                    'Response Length: ${resp.data!.serviceEntityItems!.length}');
                entityType = resp.message ?? '';
                items.clear();
                getScheduleList(context);
                keys.clear();
                for (int index = 0; index < list.length; index++) {
                  List<String> answerItems = [];

                  if (list[index].items != null) {
                    answerItems.addAll(
                        list[index].items!.map((e) => e.toString()).toList());
                  }

                  serviceEntityItems.add(
                    ServiceEntityItems(
                      typeId: list[index].typeId,
                      answer: list[index].answer,
                      items: answerItems,
                      question: list[index].question,
                      rowItems: list[index].rowItems,
                      questionId: list[index].questionId,
                    ),
                  );
                }

                notifyListeners();
              }
            } catch (e) {
              print(e.toString());
              Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
            }
          }

          serviceEntityStatus = serviceEntityItems.isEmpty ? -1 : 1;

          loading = false;
          notifyListeners();
        } catch (e) {
          loading = false;
          Utils().printMessage("STATUS Failure ==>>> " + e.toString());
        }
        notifyListeners();
      } else {
        loading = false;
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();
    // notifyListeners();
  }

  updateServiceEntity(List<ServiceEntityItems> items) {
    serviceEntityItems = [];
    notifyListeners();
    print('Total Length: ${items.length}');
    print(
        'Updating Servic Entity ${items.length} ${items.firstWhere((element) => element.typeId == 7).answer}');
    serviceEntityItems.addAll(items);
    notifyListeners();
  }

  getServiceEntityDetails(
      BuildContext context, String customerID, String entityID) async {
    Utils().printMessage("==get Service Entity Details API Call");

    serviceEntityItems.clear();

    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    /*List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();*/
    String? companyId = await GlobalHandler.getCompanyId();
    scheduleRepo
        .getServiceEntityDetails(
      customerID: customerID,
      serviceEntityID: entityID,
    )
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        try {
          if (value.data != null) {
            ServiceEntityQuestionModel resp =
                value.data as ServiceEntityQuestionModel;

            //print(value.data);

            List<Map<String, dynamic>> answerList = [];

            model.serviceEntity = null;

            try {
              List<ServiceEntityItems> list = resp.data!.serviceEntityItems!;

              if (list != null) {
                print('Length: ${list.length}');
                print(
                    'Response Length: ${resp.data!.serviceEntityItems!.length}');
                // entityType = resp.message ?? '';
                items.clear();
                keys.clear();
                for (int index = 0; index < list.length; index++) {
                  //print('Question ID: ${list[index].questionId!}');

                  List<String> answerItems = [];

                  if (list[index].items != null) {
                    answerItems.addAll(
                        list[index].items!.map((e) => e.toString()).toList());
                  }

                  serviceEntityItems.add(
                    ServiceEntityItems(
                      typeId: list[index].typeId,
                      answer: list[index].answer,
                      items: answerItems,
                      question: list[index].question,
                      rowItems: list[index].rowItems,
                      questionId: list[index].questionId,
                    ),
                  );
                }

                print(
                    'Service Entity Items Length: ${serviceEntityItems.length}');

                serviceEntityItems.forEach((element) {
                  Map<String, dynamic> answer = {
                    'question': element.question,
                    'answer': element.answer,
                  };

                  answerList.add(answer);
                });

                print(answerList);

                Map<String, dynamic> map = {
                  "item": "",
                  "data": answerList
                      .map((e) => {
                            "question_id": e['question_id'].toString(),
                            "question_name": e['question'],
                            "answer": e['answer'],
                            "answer_type_id": e['answer_type'],
                          })
                      .toList()
                };

                model.serviceEntity = map;

                notifyListeners();
              }
            } catch (e) {
              print(e.toString());
              Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
            }

            serviceEntityStatus = serviceEntityItems.isEmpty ? -1 : 1;
          }

          loading = false;
          notifyListeners();
        } catch (e) {
          loading = false;
          Utils().printMessage("STATUS Failure ==>>> " + e.toString());
        }
        notifyListeners();
      } else {
        loading = false;
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();
    // notifyListeners();
  }

  saveImage(BuildContext context,
      {required String tempID, required List<XFile> image}) async {
    Utils().printMessage("==save Image==");

    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());

    scheduleRepo.saveImage(image: image, tempJobID: tempID).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        try {
          if (value.data != null) {
            try {} catch (e) {
              print(e.toString());
              Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
            }
          }

          loading = false;
          notifyListeners();
        } catch (e) {
          loading = false;
          Utils().printMessage("STATUS Failure ==>>> " + e.toString());
        }
        notifyListeners();
      } else {
        loading = false;
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();
    // notifyListeners();
  }

  generateInvocie(BuildContext context) async {
    Utils().printMessage("==Generating Invoice==");
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    // print("checking customer in generate Invoce->${model.customer}");
    if (model.customer != null && model.customer!.isNotEmpty) {
      if (model.staffList != null && model.staffList!.isNotEmpty) {
        scheduleRepo.generateInvoice(jobID: model.jobId!).then((value) async {
          // print("invoice value =======>${value.data['message']}");
          print(value.data);
          if (value.status == STATUS.SUCCESS) {
            loading = false;
            try {
              if (value.data != null) {
                try {
                  if (value.status == STATUS.SUCCESS) {
                    Utils().ShowSuccessSnackBar(
                        context, "Success", 'Invoice has been generated');
                    addScheduleModel!.jobStatus = 1;
                    loading = false;
                    AllPdfListModel resp = value.data as AllPdfListModel;
                    GoRouter.of(context).pushNamed(
                      'customerPdfList',
                      extra: {
                        'list': resp.data,
                      },
                    );
                    //Navigate.NavigatePushUntil(context, SCHEDULE_PAGE, params: {});
                    notifyListeners();
                  } else {
                    Utils().ShowErrorSnackBar(
                        context, "Failed", '${value.message}');
                  }
                } catch (e) {
                  print(e.toString());
                  Utils()
                      .ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
                }
              }

              loading = false;
              notifyListeners();
            } catch (e) {
              loading = false;
              Utils().printMessage("STATUS Failure ==>>> " + e.toString());
            }
            notifyListeners();
          } else {
            loading = false;
            Utils().printMessage("STATUS FAILED");
            Utils().ShowErrorSnackBar(
                context, 'Error', 'Can not generate invoice');
            if (value.message == TOKEN_EXPIRED) {
              Utils.Logout(context);
            }
            notifyListeners();
            notifyListeners();
          }
        }, onError: (err) {
          loading = false;
          Utils().printMessage("STATUS ERROR-> $err");
          notifyListeners();
        });
        EasyLoading.dismiss();
      } else {
        Utils().ShowErrorSnackBar(
            context, 'Error', 'Please Add staff For Creating Invoice');
        loading = false;
        EasyLoading.dismiss();
      }
    } else {
      Utils().ShowErrorSnackBar(
          context, 'Error', 'Please Add Customer For Creating Invoice');
      loading = false;
      EasyLoading.dismiss();
    }

    // notifyListeners();
  }

  // pushTaxSettingScreen({required BuildContext context}) {
  //   getTaxValue(context: context);
  // }

  Future getTaxValue({
    required BuildContext context,
  }) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      await scheduleRepo.getTaxTable().then((value) {
        if (value.status == STATUS.SUCCESS) {
          try {
            log("Tax Val : ${value.data}");
            if (value.data != null) {
              TaxModel resp = value.data as TaxModel;
              taxList.clear();
              taxList = resp.data!.taxTable!;
              notifyListeners();

              // if (isRedirect == true) {
              //   // GoRouter.of(context).pushNamed('tax-setting',
              //   //     extra: {'taxList': taxList}).then((value) {
              //   //   Provider.of<TitleProvider>(context, listen: false)
              //   //       .changeTitle('Settings');
              //   //   notifyListeners();
              //   // });
              // }
              EasyLoading.dismiss();
            } else {
              taxList.clear();
              notifyListeners();
              EasyLoading.dismiss();
            }
          } catch (e) {
            EasyLoading.dismiss();
            log("GEtting error in getting tax value : ${e}");
          }
          notifyListeners();
        } else {
          taxList.clear();
          notifyListeners();
          EasyLoading.dismiss();
          Utils().printMessage("STATUS FAILED");
          if (value.message == TOKEN_EXPIRED) {
            Utils.Logout(context);
          }
          // if (isRedirect == true) {
          //   GoRouter.of(context).pushNamed('tax-setting',
          //       extra: {'taxList': taxList}).then((value) {
          //     Provider.of<TitleProvider>(context, listen: false)
          //         .changeTitle('Settings');
          //     notifyListeners();
          //   });
          // }
          // notifyListeners();
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log("GEtting error in getting tax value : ${e}");
    }
  }

  Future addTaxTable(
      {required String taxMasterName,
      required String taxMasterRate,
      required BuildContext context}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      await scheduleRepo
          .addTaxTable(
              taxMasterName: taxMasterName, taxMasterRate: taxMasterRate)
          .then((value) {
        if (value.status == STATUS.SUCCESS) {
          // getTaxValue(context: context);
          EasyLoading.dismiss();
          notifyListeners();
        } else {
          //error dialog
          EasyLoading.dismiss();
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log("GEtting error in adding tax value : ${e}");
    }
  }

  Future updateTaxTable(
      {required Map<String, dynamic> taxUpdates,
      required BuildContext context}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      await scheduleRepo.updateTaxTable(taxUpdates: taxUpdates).then((value) {
        if (value.status == STATUS.SUCCESS) {
          Utils()
              .ShowSuccessSnackBar(context, "Success", 'Tax has been updated');
          EasyLoading.dismiss();
          notifyListeners();
        } else {
          EasyLoading.dismiss();
          notifyListeners();
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log("Getting error in updating tax value : ${e}");
    }
  }

  Future deleteTaxTable(
      {required String taxTypeId, required BuildContext context}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      await scheduleRepo
          .deleteTaxTable(taxTypeId: taxTypeId)
          .then((value) async {
        if (value.status == STATUS.SUCCESS) {
          Utils().ShowSuccessSnackBar(
              context, "Success", 'Tax has been Deleted Successfully');
          await getTaxValue(context: context);
          EasyLoading.dismiss();
          notifyListeners();
        }
      });
    } catch (e) {}
  }

  WorkingHoursResponseModel? workingHoursResponseModel;

  Future getWorkingHours(
      {required BuildContext context,
      required bool isRedirect,
      required bool openDialogue}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      scheduleRepo.getWorkingHours().then((value) {
        if (value.status == STATUS.SUCCESS) {
          print('value here: ${value.status} ${value.data}');

          try {
            if (value.data != null) {
              workingHoursResponseModel =
                  value.data as WorkingHoursResponseModel;
              //workingHoursResponseModel = resp;
              notifyListeners();
              EasyLoading.dismiss();

              if (openDialogue) {
                showMyDialog('working-hours');
              }
            } else {
              workingHoursResponseModel = null;
              EasyLoading.dismiss();
            }
          } catch (e) {
            EasyLoading.dismiss();
            log("Error to get Working Hours : ${e}");
          }
          notifyListeners();
        } else {
          EasyLoading.dismiss();
          Utils().printMessage("STATUS FAILED");
          if (value.message == TOKEN_EXPIRED) {
            Utils.Logout(context);
          }
          notifyListeners();
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log("Error to get Working Hours : ${e}");
    }
  }

  Future addWorkingHours(
    BuildContext context, {
    required String startTime,
    required String endTime,
  }) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      await scheduleRepo
          .addWorkingHours(start: startTime, end: endTime)
          .then((value) async {
        if (value.status == STATUS.SUCCESS) {
          EasyLoading.dismiss();
          Utils().ShowSuccessSnackBar(rootNavigatorKey.currentContext!,
              "Success", "Working hours have been modified");
          await getWorkingHours(
              context: rootNavigatorKey.currentContext!,
              isRedirect: false,
              openDialogue: false);
          notifyListeners();
        } else {
          //error dialog
          EasyLoading.dismiss();
          Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!, "Error",
              "Unable to get working hours");
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log("GEtting error in adding working hours : ${e}");
      Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!, "Error",
          "Unable to get working hours");
    }
  }

  IntervalData? timeInterval;

  Future getTimeInterval(
      {required BuildContext context,
      required bool isRedirect,
      required bool openDialogue}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      scheduleRepo.getTimeInterval().then((value) {
        if (value.status == STATUS.SUCCESS) {
          print('value here: ${value.status} ${value.data}');

          try {
            if (value.data != null) {
              timeInterval = value.data as IntervalData;
              //workingHoursResponseModel = resp;
              notifyListeners();
              EasyLoading.dismiss();

              if (openDialogue) {
                showMyDialog('time-interval');
              }
            } else {
              timeInterval = null;
              EasyLoading.dismiss();
              Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!,
                  "Error", "Unable to get Time Interval");
            }
          } catch (e) {
            EasyLoading.dismiss();
            log("Error to get TimeInterval : ${e}");
          }
          notifyListeners();
        } else {
          EasyLoading.dismiss();
          Utils().printMessage("STATUS FAILED");
          if (value.message == TOKEN_EXPIRED) {
            Utils.Logout(context);
          }
          notifyListeners();
          Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!, "Error",
              "Unable to get Time Interval");
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log("Error to get Working Hours : ${e}");
      Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!, "Error",
          "Unable to get working hours");
    }
  }

  Future addTimeInterval(BuildContext context,
      {required String hour, required String minute}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      await scheduleRepo
          .addTimeInterval(hour: hour, minute: minute)
          .then((value) async {
        if (value.status == STATUS.SUCCESS) {
          EasyLoading.dismiss();
          Utils().ShowSuccessSnackBar(rootNavigatorKey.currentContext!,
              "Success", "Time interval has been modified");
          await getTimeInterval(
              context: rootNavigatorKey.currentContext!,
              isRedirect: false,
              openDialogue: false);
          notifyListeners();
        } else {
          //error dialog
          EasyLoading.dismiss();
          Utils().ShowErrorSnackBar(
              rootNavigatorKey.currentContext!, "Error", value.message ?? "Unable to save data");
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log("Getting error in adding Time Interval : ${e}");
    }
  }

  Future addMaxJobTask(BuildContext context, {required String maxJob}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      await scheduleRepo.addMaxJobTask(maxJobTask: maxJob).then((value) async {
        if (value.status == STATUS.SUCCESS) {
          EasyLoading.dismiss();
          Utils().ShowSuccessSnackBar(rootNavigatorKey.currentContext!,
              "Success", "Max JOb has been modified");
          await getMaxJobTask(
              context: rootNavigatorKey.currentContext!,
              isRedirect: false,
              openDialogue: false);
          notifyListeners();
        } else {
          //error dialog
          EasyLoading.dismiss();
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log("GEtting error in adding working hours : ${e}");
    }
  }

  String? maxJobTask;

  Future getMaxJobTask(
      {required BuildContext context,
      required bool isRedirect,
      required bool openDialogue}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      scheduleRepo.getMaxJobTask().then((value) {
        if (value.status == STATUS.SUCCESS) {
          print('value here: ${value.status} ${value.data}');

          try {
            if (value.data != null) {
              maxJobTask = value.data as String;
              //workingHoursResponseModel = resp;
              notifyListeners();
              EasyLoading.dismiss();

              if (openDialogue) {
                showMyDialog('max-job-task');
              }
            } else {
              maxJobTask = null;
              EasyLoading.dismiss();
              Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!,
                  "Error", "Unable to get max job");
            }
          } catch (e) {
            EasyLoading.dismiss();
            log("Error to get MaxJob Task : ${e}");
          }
          notifyListeners();
        } else {
          EasyLoading.dismiss();
          Utils().printMessage("STATUS FAILED");
          Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!, "Error",
              "Unable to get max job");
          if (value.message == TOKEN_EXPIRED) {
            Utils.Logout(context);
          }
          notifyListeners();
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log("Error to get Working Hours : ${e}");
      Utils().ShowErrorSnackBar(
          rootNavigatorKey.currentContext!, "Error", "Unable to get max job");
    }
  }

  UserTypeResponseModel? userTypeResponseModel;

  Future getUserType(
      {required BuildContext context, required bool isRedirect}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      scheduleRepo.getUserType().then((value) {
        if (value.status == STATUS.SUCCESS) {
          try {
            if (value.data != null) {
              userTypeResponseModel = value.data as UserTypeResponseModel;
              //workingHoursResponseModel = resp;
              notifyListeners();
              EasyLoading.dismiss();
            } else {
              userTypeResponseModel = null;
              EasyLoading.dismiss();
            }
          } catch (e) {
            EasyLoading.dismiss();
            log("Error to get User Type : ${e}");
            Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!, "Error",
                "Unable to get user details");
          }
          notifyListeners();
        } else {
          EasyLoading.dismiss();
          Utils().printMessage("STATUS FAILED");
          if (value.message == TOKEN_EXPIRED) {
            Utils.Logout(context);
          }
          Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!, "Error",
              "Unable to get user details");
          notifyListeners();
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log("Error to get User Type : ${e}");
      Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!, "Error",
          "Unable to get user details");
    }
  }

  PrivilegeResponseModel? privilegeResponseModel;

  Future getUserPrivilege(BuildContext context,
      {required String phoneNumber}) async {
    privilegeResponseModel = null;

    notifyListeners();

    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      await scheduleRepo
          .getUserPrivilege(phoneNumber: phoneNumber)
          .then((value) async {
        if (value.status == STATUS.SUCCESS) {
          privilegeResponseModel = value.data as PrivilegeResponseModel;
          EasyLoading.dismiss();
          notifyListeners();
        } else {
          //error dialog
          Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!, "Error",
              "Can not find any privilege");
          EasyLoading.dismiss();
        }
      });
    } catch (e) {
      print('Error: ${e.toString()}');
      EasyLoading.dismiss();
      Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!, "Error",
          "Can not get any Privilege");
    }
  }

  Future addUserPrivilege(BuildContext context,
      {required String privileges,
      required String type,
      required String phoneNumber}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      await scheduleRepo
          .savePrivilege(
        type: type,
        privilegeList: privileges,
        phoneNumber: phoneNumber,
      )
          .then((value) async {
        if (value.status == STATUS.SUCCESS) {
          EasyLoading.dismiss();
          Utils().ShowSuccessSnackBar(rootNavigatorKey.currentContext!,
              "Success", "User Privilege has been modified");
          await getUserPrivilege(rootNavigatorKey.currentContext!,
              phoneNumber: phoneNumber);
          notifyListeners();
        } else {
          //error dialog
          EasyLoading.dismiss();
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log("GEtting error in adding User Privilege : ${e}");
    }
  }

  ReminderResponseModel? reminderResponseModel;

  Future getReminder(BuildContext context, {required bool openDialogue}) async {
    reminderResponseModel = null;

    notifyListeners();

    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      await scheduleRepo.getReminder().then((value) async {
        if (value.status == STATUS.SUCCESS) {
          reminderResponseModel = value.data as ReminderResponseModel;
          EasyLoading.dismiss();
          notifyListeners();
        } else {
          //error dialog
          Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!, "Error",
              "Can not find any reminder");
          reminderResponseModel = ReminderResponseModel(
            data: null,
            message: '',
            success: false,
          );
          EasyLoading.dismiss();
        }
      });
    } catch (e) {
      print('Error: ${e.toString()}');
      EasyLoading.dismiss();
      reminderResponseModel = ReminderResponseModel(
        data: null,
        message: '',
        success: false,
      );
      notifyListeners();
      Utils().ShowErrorSnackBar(rootNavigatorKey.currentContext!, "Error",
          "Can not get any reminder");
    }
  }

  Future setReminder(BuildContext context,
      {required Map<String, dynamic> reminder}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      await scheduleRepo.setReminder(reminders: reminder).then((value) async {
        if (value.status == STATUS.SUCCESS) {
          EasyLoading.dismiss();
          Utils().ShowSuccessSnackBar(rootNavigatorKey.currentContext!,
              "Success", "Reminder events have been modified");
          await getReminder(rootNavigatorKey.currentContext!,openDialogue: false);
          notifyListeners();
        } else {
          //error dialog
          EasyLoading.dismiss();
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log("GEtting error in Set Reminder : ${e}");
    }
  }

  //------------------New Create Invoice----------------//
  saveEditInvoice(
      {required List<int> customerIds,
      required Map<String, int> services,
      required Map<String, double> materials,
      required double laborCharge,
      required double tripTavelCharge,
      required Map<String, double> specialCharges,
      required double discountValue,
      required String discountMethod,
      required double deposit,
      required String jobId,
      required BuildContext context,
      required String paymentTerm}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var saveEditJson = {
      "TenantId": loginData!.tenantId,
      "UserId": userId,
      "JobId": jobId,
      "paymentTerm": paymentTerm,
      "CustomerIds": customerIds,
      "Services": services,
      "Materials": materials,
      "LaborCharge": laborCharge,
      "TripTravelCharge": tripTavelCharge,
      "SpecialCharges": specialCharges,
      "Discount": discountValue == 0.0
          ? {}
          : {"DiscountValue": discountValue, "DiscountMethod": discountMethod},
      "Deposit": double.tryParse(deposit.toStringAsFixed(2)) ?? 0.00
    };

    log("AFTER CREATE INVOICE -------- |||${jsonEncode(saveEditJson)} |||");

    try {
      scheduleRepo.saveEditInvoice(saveEditJson: saveEditJson).then((value) {
        if (value.status == STATUS.SUCCESS) {
          EasyLoading.dismiss();
          Utils().ShowSuccessSnackBar(context, 'Success', '${value.message}');
          // context.pop();
          //-----preview popup------//
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return PreviewCustomerInvoice(
                      addScheduleModel: addScheduleModel!,
                      customerIdList: customerIds,
                    );
                  },
                ),
              );
            },
          );
          //------------------------//
          isInvoiced = true;
          notifyListeners();
        } else {
          EasyLoading.dismiss();
          Utils().ShowErrorSnackBar(context, 'Error', '${value.message}');
          if (value.message == TOKEN_EXPIRED) {
            Utils.Logout(context);
          }
          notifyListeners();
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      Utils().ShowErrorSnackBar(context, 'Error', '${e}');
    }
  }

  //----------------New-create-invoice-end---------------//

  //-----------------Update-Invoice-start----------------//
  updateInvoice(
      {required List<int> customerIds,
      required Map<String, int> services,
      required Map<String, double> materials,
      required double laborCharge,
      required double tripTavelCharge,
      required Map<String, double> specialCharges,
      required double discountValue,
      required String discountMethod,
      required double deposit,
      required String jobId,
      required BuildContext context,
      required String paymentTerm}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    model.paymentDuration = null;
    // if (selectedValue == "OnReceipt") {
    //   model.paymentDuration = "1";
    // }

    // if (selectedPayLetterDurationValue == "Next 30 Days") {
    //   model.paymentDuration = "2";
    // } else if (selectedPayLetterDurationValue == "Next 60 Days") {
    //   model.paymentDuration = "3";
    // } else if (selectedPayLetterDurationValue == "Next 90 Days") {
    //   model.paymentDuration = "4";
    // }
    var updateJson = {
      "TenantId": loginData!.tenantId,
      "UserId": userId,
      "JobId": jobId,
      "paymentTerm": paymentTerm,
      "CustomerIds": customerIds,
      "Services": services,
      "Materials": materials,
      "LaborCharge": laborCharge,
      "TripTravelCharge": tripTavelCharge,
      "SpecialCharges": specialCharges,
      "Discount": discountValue == 0.0
          ? {}
          : {"DiscountValue": discountValue, "DiscountMethod": discountMethod},
      "Deposit": double.tryParse(deposit.toStringAsFixed(2)) ?? 0.00
    };

    log("AFTER UPDATING INVOICE -------- |||${jsonEncode(updateJson)} |||");

    try {
      scheduleRepo.updateInvoice(updateJson: updateJson).then((value) {
        if (value.status == STATUS.SUCCESS) {
          EasyLoading.dismiss();
          Utils().ShowSuccessSnackBar(context, 'Suucess', '${value.message}');
          // context.pop();
          //-----preview popup------//
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return PreviewCustomerInvoice(
                      addScheduleModel: addScheduleModel!,
                      customerIdList: customerIds,
                    );
                  },
                ),
              );
            },
          );
          //------------------------//
          isInvoiced = true;
          notifyListeners();
        } else {
          EasyLoading.dismiss();
          Utils().ShowErrorSnackBar(context, 'Error', '${value.message}');
          if (value.message == TOKEN_EXPIRED) {
            Utils.Logout(context);
          }
          notifyListeners();
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      Utils().ShowErrorSnackBar(context, 'Error', '${e}');
    }
  }

  //------------------Update-Invoice-End-----------------//

  //-----------------get and edit invoice-----------------//
  Future getEditInvoice({
    required String jobId,
    required List<int> customerIds,
    required BuildContext context,
    required AddScheduleModel addScheduleModel,
  }) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      getTaxValue(
        context: context,
      );
      scheduleRepo
          .getEditInvoice(jobId: jobId, customerIds: customerIds)
          .then((value) {
        log("INCONTROLLER GETTING : ${jsonEncode(value.data)}");
        if (value.status == STATUS.SUCCESS) {
          // GetEditInvoiceModel resp = GetEditInvoiceModel.fromJson(data);
          // log("value.data['message'] : ${value.data['message']}");
          if (value.data['message'] != null) {
            if (value.data['message']
                .toString()
                .contains('find the correct combination')) {
              Utils().ShowWarningSnackBar(
                  context, 'Error', '${value.data['message'].toString()}');
            }
            //  else if (value.data['message']
            //     .toString()
            //     .contains('Data mismatch')) {
            //   context.pop();
            //   GoRouter.of(context).pushNamed('addeditinvoice', extra: {
            //     'addScheduleModel': addScheduleModel,
            //     'customerIdList': customerIds,
            //     'model': null,
            //   });
            // }
            else if (value.data['message']
                .toString()
                .contains('Invoice not created.')) {
              context.pop();
              GoRouter.of(context).pushNamed('addeditinvoice', extra: {
                'addScheduleModel': addScheduleModel,
                'customerIdList': customerIds,
                'model': null,
              });
            }
          } else {
            var data = GetEditInvoiceModel.fromJson(value.data);
            log('saveEditInvice Data : ${data.jobId}');
            context.pop();
            GoRouter.of(context).pushNamed('addeditinvoice', extra: {
              'addScheduleModel': addScheduleModel,
              'customerIdList': customerIds,
              'model': data
            });
          }

          notifyListeners();
        } else {
          GoRouter.of(context).pushNamed('addeditinvoice', extra: {
            'addScheduleModel': addScheduleModel,
            'customerIdList': customerIds,
            'model': null
          });
        }
      });
      EasyLoading.dismiss();
    } catch (e) {
      log("error ===> $e");
      EasyLoading.dismiss();
    }
  }

  //-------------------------------------------------------//

  //--------------------GET-INVOICED-CUSTOMER-DATA--------------------//
  getInvoicedCustomerData(
      {required BuildContext context, required String jobId}) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());
    try {
      scheduleRepo.getInvoicedCustomerData(jobId: jobId).then((value) {
        if (value.status == STATUS.SUCCESS) {
          try {
            if (value.data != null) {
              InvoicedCustomerModel resp = value.data as InvoicedCustomerModel;
              invoicedCustomerData.clear();
              invoicedCustomerData = resp.data!;
              EasyLoading.dismiss();
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return ViewAllCreatedInvoice(
                          invoicedCustomerList: invoicedCustomerData,
                        );
                      },
                    ),
                  );
                },
              );
            }
          } catch (e) {
            EasyLoading.dismiss();
            log("GEtting error in getting Invoiced Customer List : ${e}");
          }
          notifyListeners();
        } else {
          EasyLoading.dismiss();
          Utils().printMessage("STATUS FAILED");
          if (value.message == TOKEN_EXPIRED) {
            Utils.Logout(context);
          }
          notifyListeners();
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log("GEtting error in getting Invoiced Customer List : ${e}");
    }
  }

  //-----------------------------------------------------------------------------//

  //-----------------------CREATE-INVOICE-PDF-CUSTOMER---------------------------//
  // String? pdfFilePath;
  // createInvoicePdf(
  //     {required customerId,
  //     required String jobId,
  //     required BuildContext context}) async {
  //   EasyLoading.show(
  //       status: "Loading", indicator: const CircularProgressIndicator());
  //   scheduleRepo
  //       .getPdfByCustomer(customerId: customerId, jobId: jobId)
  //       .then((value) async {
  //     if (value.status == STATUS.SUCCESS) {
  //       final directory = await getApplicationDocumentsDirectory();
  //       final filePath = "${directory.path}/invoice.pdf";
  //       final file = File(filePath);

  //       // await file.writeAsBytes(value);
  //       pdfFilePath = filePath;
  //       downloadPdf(context: context);
  //       EasyLoading.dismiss();
  //     } else {
  //       EasyLoading.dismiss();
  //     }
  //   });
  // }

  // Future<void> downloadPdf({required BuildContext context}) async {
  //   if (await Permission.storage.request().isGranted) {
  //     final directory = await getExternalStorageDirectory();
  //     final filePath = "${directory!.path}/invoice.pdf";
  //     final file = File(filePath);

  //     if (pdfFilePath != null) {
  //       final pdfFile = File(pdfFilePath!);
  //       await pdfFile.copy(filePath);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('PDF downloaded to $filePath')),
  //       );
  //     }
  //   }
  // }

  String? pdfFilePath;

  //  Future<void> createInvoicePdf({
  //   required String customerId,
  //   required String jobId,
  //   required BuildContext context,
  // }) async {
  //   EasyLoading.show(
  //       status: "Loading", indicator: const CircularProgressIndicator());

  //   try {
  //     // Assuming getPdfByCustomer returns a PDF file in byte format
  //     final value = await scheduleRepo.getPdfByCustomer(
  //         customerId: customerId, jobId: jobId);

  //     if (value.status == STATUS.SUCCESS) {
  //       final directory = await getApplicationDocumentsDirectory();
  //       final filePath = "${directory.path}/invoice.pdf";
  //       final file = File(filePath);

  //       // Write the received PDF bytes to the file
  //       await file.writeAsBytes(value.pdfBytes);
  //       pdfFilePath = filePath;

  //       // Show a download notification
  //       await downloadPdf(context: context);

  //       // Open the PDF for viewing
  //       OpenFile.open(pdfFilePath!);
  //     } else {
  //       // Handle the failure
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to create PDF')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }

  // Future<void> downloadPdf({required BuildContext context}) async {
  //   if (await Permission.storage.request().isGranted) {
  //     final directory = await getExternalStorageDirectory();
  //     final filePath = "${directory!.path}/invoice.pdf";
  //     final file = File(filePath);

  //     if (pdfFilePath != null) {
  //       final pdfFile = File(pdfFilePath!);
  //       await pdfFile.copy(filePath);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('PDF downloaded to $filePath')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('PDF file path is null')),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Storage permission denied')),
  //     );
  //   }
  // }
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  String? localPath;

  // Future<void> _downloadAndSavePdf({required String url}) async {
  //   try {
  //     Dio dio = Dio();
  //     String fileName = 'invoice';
  //     Directory directory = await getApplicationDocumentsDirectory();
  //     String filePath = '${directory.path}/$fileName';

  //     // Download the PDF file
  //     await dio.download(url, filePath);

  //     // setState(() {
  //     localPath = filePath;
  //     notifyListeners();
  //     // });
  //   } catch (e) {
  //     print('Error downloading PDF: $e');
  //   }
  // }

  Future<void> _openPdfLink({required String pdfUrlasync}) async {
    if (await canLaunch(pdfUrl!)) {
      await launch(pdfUrl!);
    } else {
      throw 'Could not launch $pdfUrl';
    }
  }

  Future<void> createInvoicePdf({
    required String customerId,
    required String jobId,
    required BuildContext context,
  }) async {
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());

    try {
      final value = await scheduleRepo.getPdfByCustomer(
          customerId: customerId, jobId: jobId);

      if (value.status == STATUS.SUCCESS) {
        if (value.data != null) {
          CreateInvoicePdfModel resp = value.data as CreateInvoicePdfModel;
          log("URK : ${resp.data!.url!}");
          if (resp.data!.url!.isNotEmpty) {
            EasyLoading.dismiss();
            pdfUrl = "${Urls.BASE_URL}${resp.data!.url!}";
            log("pdfUrl : ${pdfUrl}");
            // if (isShare) {
            // SharePDF sharePDF = SharePDF(
            //   url: "$pdfUrl",
            //   subject: "Subject Line goes here",
            // );
            // await sharePDF.downloadAndShare();
            // downloadFile(pdfUrl!).then((filePath) {
            //   // setState(() {
            //   localFilePath = filePath;
            //   // });
            // });
            // PDFView(
            //   filePath: localFilePath!,
            // );

            // const PDF().cachedFromUrl(
            //   '$pdfUrl',
            //   placeholder: (progress) => Center(child: Text('$progress %')),
            //   errorWidget: (error) => Center(child: Text(error.toString())),
            // );
            // } else {
            //   _openPdfLink(pdfUrlasync: pdfUrl!);
            // }

            // _downloadAndSavePdf(url: pdfUrl!);
            // PDFView(
            //   filePath: localPath,
            // );

            // SharePDF sharePDF = SharePDF(
            //   url: "$pdfUrl",
            //   subject: "Subject Line goes here",
            // );
            // await sharePDF.downloadAndShare();
            context.pop();
            GoRouter.of(context).pushNamed('createInvoice', extra: {
              'url': pdfUrl,
            });
            // SfPdfViewer.network(
            //   '$pdfUrl',
            //   key: _pdfViewerKey,
            //   onDocumentLoadFailed: (PdfDocumentLoadFailedDetails value) {
            //     Utils().ShowErrorSnackBar(context, 'ERROR', value.description);
            //     Navigator.pop(context);
            //   },
            // );
          } else {
            EasyLoading.dismiss();
            pdfUrl = null;
          }
          notifyListeners();
          EasyLoading.dismiss();

          // CreateInvoicePdfModel
        }
      } else {
        // Handle the failure
        EasyLoading.dismiss();
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  String? localFilePath;

  Future<String> downloadFile(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(response.bodyBytes);
    print("FilePath : ${file.path}");
    return file.path;
  }

  // Future<void> downloadPdf(
  //     {required BuildContext context, required String path}) async {
  //   if (await Permission.storage.request().isGranted) {
  //     final directory = await getExternalStorageDirectory();
  //     final filePath = "${directory!.path}/invoice.pdf";
  //     final file = File(filePath);

  //     if (pdfFilePath != null) {
  //       final pdfFile = File(pdfFilePath!);
  //       await pdfFile.copy(filePath);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('PDF downloaded to $filePath')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('PDF file path is null')),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Storage permission denied')),
  //     );
  //   }
  // }

  //-----------------------------------------------------------------------------//

  getRecurrDate(BuildContext context) async {
    Utils().printMessage("==Get Reccurr Date==");
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());

    scheduleRepo.getReccurrDateList().then((value) async {
      if (value.status == STATUS.SUCCESS) {
        loading = false;

        ReccurrDateModel resp = ReccurrDateModel.fromJson(value.data);

        try {
          List<ReccurrData> list = resp.data ?? [];
          if (list != null) {
            print('Length: ${list.length}');
            print('Response Length: ${resp.data!.length}');

            reccurrDateList.clear();

            for (int index = 0; index < list.length; index++) {
              reccurrDateList.add(ReccurrData(
                startTime: list[index].startTime,
                endTime: list[index].endTime,
              ));
            }
            model.totalJobs = reccurrDateList.length.toString();

            notifyListeners();
          }
        } catch (e) {
          print(e.toString());
          model.recurrType = null;
          model.totalJobs = '1';
          Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
        }
        notifyListeners();
      } else {
        loading = false;
        model.duration = null;
        model.totalJobs = '1';
        Utils().printMessage("STATUS FAILED");
        Utils().ShowErrorSnackBar(
            context, 'Error', 'Can not get future dates for this recurrence');
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();
    // notifyListeners();
  }

  late List<StaffValidationResponseModel> validStaff;

  getStaffValidation(BuildContext context, List recurDateList) async {
    Utils().printMessage("==Get Staff Validation==");
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());

    try {
      await scheduleRepo
          .getStaffValidation(recurDateList: recurDateList, context: context)
          .then((value) async {
        print(value);

        if (value.status == STATUS.SUCCESS) {
          loading = false;

          print(value.data);

          var data = StaffValidationResponseModel.fromJson(value.data);

          print("StaffValidationResponseModelData------>${data.message}");

          try {
            List<StaffValidationData> unAvailableStaffs =
                data.data!.where((e) => e.availability == 0).toList();

            print("unavailable stuff::====>${unAvailableStaffs}");

            if (unAvailableStaffs.isNotEmpty) {
              for (var item in unAvailableStaffs) {
                ///todo: remove this staff from the model
                ///
                int indexOfStaff = model.staffList!
                    .map((e) => e.staffName)
                    .toList()
                    .indexOf(
                        '${item.uSERFIRSTNAME!.capitalizeFirst} ${item.uSERLASTNAME!.capitalizeFirst!}');

                //this piece of code auto remove staff
                // model.staffList!.removeAt(indexOfStaff);
              }

              String staffNames = unAvailableStaffs
                  .map((e) =>
                      '${e.uSERFIRSTNAME!.capitalizeFirst} ${e.uSERLASTNAME!.capitalizeFirst}')
                  .toList()
                  .join(',');

              Utils().ShowErrorSnackBar(
                  duration: Duration(seconds: 10),
                  context,
                  "Staff Unavailable",
                  unAvailableStaffs.length > 1
                      ? '$staffNames are not available for this time slot'
                      : '${staffNames.replaceAll(',', '')} is not available for this time slot');

              if (model.staffList!.isEmpty) {
                model.staffList = null;
              }
            }

            /*validStaff = data.where((element) => int.parse(element.status!) == 1).toList();
          if(validStaff.isNotEmpty){
            for(var item in validStaff){
              Utils().ShowErrorSnackBar(context, "Staff Unavailable", '${item.uSERFIRSTNAME} ${item.uSERLASTNAME} is not available');
            }
          }*/

            notifyListeners();
          } catch (e) {
            //model.staffList = null;
            print('catch: $e');
            Utils().ShowErrorSnackBar(
                context, "Failed", '$SomethingWentWrong, Can not add staff');
          }
          notifyListeners();
        } else {
          loading = false;
          //model.staffList = null;
          Utils().printMessage("STATUS FAILED");
          Utils().ShowErrorSnackBar(context, "Staff Unavailable",
              'Staff is not available for this time slot');
          // if (model.staffList!.isEmpty) {
          model.staffList = null;
          // }

          //--------commenting temporary----------//
          // Utils().ShowErrorSnackBar(
          //     context, 'Error', 'Can not get staff availability');
          //--------commenting temporary----------//
          if (value.message == TOKEN_EXPIRED) {
            Utils.Logout(context);
          }
          notifyListeners();
          notifyListeners();
        }
      }, onError: (err) {
        loading = false;
        Utils().printMessage("STATUS ERROR-> $err");
        notifyListeners();
      });
      EasyLoading.dismiss();
    } catch (e) {
      print("muguwarah lufi--->${e}");
    }

    // notifyListeners();
  }

  getStaffValidationOnDate(BuildContext context, List recurDateList) async {
    Utils().printMessage("==Get Staff Validation on Date==");
    loading = true;
    EasyLoading.show(
        status: "Loading", indicator: const CircularProgressIndicator());

    scheduleRepo
        .getStaffValidation(recurDateList: recurDateList, context: context)
        .then((value) async {
      print(value);

      if (value.status == STATUS.SUCCESS) {
        loading = false;

        print(value.data);

        var data = StaffValidationResponseModel.fromJson(value.data);

        try {
          List<StaffValidationData> unAvailableStaffs =
              data.data!.where((e) => e.availability == 0).toList();

          if (unAvailableStaffs.isNotEmpty) {
            String staffNames = unAvailableStaffs
                .map((e) =>
                    '${e.uSERFIRSTNAME!.capitalizeFirst} ${e.uSERLASTNAME!.capitalizeFirst}')
                .toList()
                .join(',');

            Utils().ShowErrorSnackBar(
                context,
                "Staff Unavailable",
                unAvailableStaffs.length > 1
                    ? '$staffNames are not available for this time slot'
                    : '${staffNames.replaceAll(',', '')} is not available for this time slot');
          }
          notifyListeners();
        } catch (e) {
          print('catch: $e');
          Utils().ShowErrorSnackBar(
              context, "Failed", '$SomethingWentWrong, Can not add staff');
        }
        notifyListeners();
      } else {
        loading = false;
        Utils().printMessage("STATUS FAILED");
        //---------------commenting temporary------------------//
        // Utils().ShowErrorSnackBar(
        //     context, 'Error', 'Can not get staff availability');
        //---------------commenting temporary------------------//
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
        notifyListeners();
      }
    }, onError: (err) {
      loading = false;
      Utils().printMessage("STATUS ERROR-> $err");
      notifyListeners();
    });
    EasyLoading.dismiss();
    // notifyListeners();
  }

  addServiceEntity(BuildContext context, String customerID) async {
    log("service enitity adding here......");
    EasyLoading.show(
        status: "Loading",
        indicator: const CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    scheduleRepo.addServiceEntity(customerID).then((value) async {
      log("addServiceEntity value----->$value");
      log("addServiceEntity message----->${value.message}");
      log("addServiceEntity data----->${value.data}");
      if (value.status == STATUS.SUCCESS) {
        await Provider.of<CustomerProvider>(context, listen: false)
            .getCustomerServiceEntity(
          context,
          customerID: customerID,
        );
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowSuccessSnackBar(context, "Success",
            value.message ?? "Successfully service entity added");
        // Utils().printMessage("ADD_CUSTOMER_DATA==>${value.data}");
        Utils().printMessage("STATUS SUCCESS");
        GoRouter.of(context).pop();

        // Navigator.pop(context);
        //GoRouter.of(context).pop();
        //Navigate.NavigateAndReplace(context, customer_list, params: {});
        notifyListeners();
      } else {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(
            context, "Failed", value.message ?? "Failed to service entity add");
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
      }
    }, onError: (err, stackTrace) {
      loading = false;
      Utils().printMessage("ADD_SERVICE_ENTITY_ERROR==>$err & $stackTrace");
      EasyLoading.dismiss();
      //Utils().ShowErrorSnackBar(context, "Failed", err.toString());
      notifyListeners();
    });
  }

  deleteRecurrDate(BuildContext context) {
    reccurrDateList.clear();
    notifyListeners();
  }

  getJobStatus({required String jobId}) async {
    Utils().printMessage("==Getting JobStatus==");
    String? companyId = await GlobalHandler.getCompanyId();
    Map<String, dynamic> statusData = {"tenantId": companyId, "jobId": jobId};

    scheduleRepo.getJobStatus(statusData: statusData).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        try {
          if (value.data != null) {
            GetJobStatusResponse resp = value.data as GetJobStatusResponse;
            print("xxxxxx=>${resp.data!.statuses}");
            newJobStatus = resp.data!.statuses!.toString() ?? '0';
            print("getStatus value====>${newJobStatus.toString()}");
            addScheduleModel!.jobStatus = int.parse(newJobStatus.toString());
            notifyListeners();
          }
        } catch (e) {
          //  Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
          print(e);
          // loading = false;
          // EasyLoading.dismiss();
        }
      } else {
        // loading = false;
        // EasyLoading.dismiss();
        Utils().printMessage("cannot fetching scheduleList");
      }
      // return null;
    });
  }

  saveJobStatus(
      {required String jobId,
      required String jobStatus,
      required BuildContext context}) async {
    Utils().printMessage("==Getting JobStatus==");
    String? companyId = await GlobalHandler.getCompanyId();
    Map<String, dynamic> saveJobStatusData = {
      "tenantId": companyId,
      "jobId": jobId,
      "JobStatus": jobStatus,
      "fkSubscriptionId": "1"
    };

    print("saveJobStatusData======>$saveJobStatusData");

    scheduleRepo
        .saveJobStatus(saveJobStatusData: saveJobStatusData)
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        Utils().ShowSuccessSnackBar(
            context, "Success", 'Status has been changed successfully');
        try {
          if (value.data != null) {
            SaveJobStatusResponse resp = value.data as SaveJobStatusResponse;
            getJobStatus(jobId: jobId);

            // newJobStatus = resp.data!.statuses![0].toString() ?? '0';
            // print("getStatus value====>${newJobStatus}");
            // addScheduleModel!.jobStatus = int.parse(newJobStatus.toString());
            notifyListeners();
          }
        } catch (e) {
          //  Utils().ShowErrorSnackBar(context, "Failed", SomethingWentWrong);
          print(e);
          // loading = false;
          // EasyLoading.dismiss();
        }
      } else {
        // loading = false;
        // EasyLoading.dismiss();
        Utils().printMessage("cannot fetching scheduleList");
      }
      // return null;
    });
  }

  getCustomerServiceHistory(
      {required List<Map<String, dynamic>>? customerId,
      required BuildContext context}) async {
    EasyLoading.show(
        status: "Loading",
        indicator: const CircularProgressIndicator(),
        dismissOnTap: false);
    loading = true;
    Utils().printMessage("==Getting customer history==");
    String? companyId = await GlobalHandler.getCompanyId();
    Map<String, dynamic> customerHistoryData = {
      "tenantId": companyId,
      "customerIdList": customerId
    };
    try {
      await scheduleRepo
          .getCustomerServiceHistory(customerData: customerHistoryData)
          .then((value) async {
        print("value======>$value");
        if (value != null) if (value.isNotEmpty) {
          historyList.clear();
          for (var item in value) {
            historyList.add(Hist.fromJson(item));
            notifyListeners();
          }
          loading = false;
          EasyLoading.dismiss();
        } else {
          // Utils().ShowErrorSnackBar(
          //     context, "Success", 'Customer History fetched Failed');
          loading = false;
          EasyLoading.dismiss();
        }
      });
    } catch (e) {
      print("customer History fetch failed $e");
      Utils().ShowErrorSnackBar(
          context, "Success", 'Customer History fetched Failed');
    }
  }

  AddScheduleModel loadPrevData(BuildContext context) {
    ScheduleModel schedule = items[timeIndex].schedule![jobIndex];

    model.location = schedule.jOBLOCATION;
    model.isAdding = false;
    model.jobId = schedule.pKJOBID;
    model.note = schedule.jOBNOTES;
    model.startTime = schedule.jOBSTARTTIME;
    // model.startDate = schedule.s
    model.endTime = schedule.jOBENDTIME;

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

    //-------------------------now it is commented-----------------------//
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
    //     schedule.staffList!.map((e) => e.pKUSERID ?? 0).toList();
    //     List<int> staffIDList =
    //     Provider.of<StaffProvider>(context, listen: false)
    //         .staffList!
    //         .map((e) => int.parse(e.staffId))
    //         .toList();
    //     List<String> staffNames = Provider.of<StaffProvider>(context,
    //         listen: false)
    //         .staffList!
    //         .map((e) =>
    //     '${e.staffFirstName.capitalizeFirst} ${e.staffLastName.capitalizeFirst}')
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
    //     notifyListeners();
    //   } else {
    //     Utils().printMessage('Empty');
    //   }
    // } else {
    //   Utils().printMessage('loading');
    // }
    //-------------------now it is commented--------------------//

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

        notifyListeners();
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

        notifyListeners();
      } else {
        Utils().printMessage(' Service Empty');
      }
    } else {
      Utils().printMessage('loading');
    }

    return model;
  }

  Future<bool> validateReturn(
    BuildContext context,
  ) async {
    print("selected value --->$selectedValue");
    // if (revisedAppoinmentDate == null || revisedAppoinmentDate.isEmpty) {
    //   await Utils.showAlertDialog(
    //       context, 'Validation!', 'Please Select Your Date.',
    //       type: 'Error');
    //   // Utils.showSnackBarMessage(context, "Please Select Assignee",Colors.red);
    //   return false;
    // }
    if (selectedValue == null) {
      await Utils().ShowErrorSnackBar(context, "Error!", 'Please Select When');
      notifyListeners();
      //Utils.showSnackBarMessage(context, "Please Select Assignee",Colors.red);
      return false;
    }
    if (selectedValue == 'PayLater' && selectedPayLetterDurationValue == null) {
      await Utils()
          .ShowErrorSnackBar(context, "Error!", 'Please Select Duration');
      notifyListeners();
      //Utils.showSnackBarMessage(context, "Please Select Assignee",Colors.red);
      return false;
    }

    return true;
  }
}

showMyDialog(String str, [String? time]) async {
  await showDialog(
    barrierDismissible: false,
    context: rootNavigatorKey.currentContext!,
    builder: (context) {
      return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: StatefulBuilder(// You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState) {
            return str == "working-hours"
                ? WorkingHourWidget(
                    onChanged: (val) async {
                      print('Val: $val');
                      await Provider.of<JobScheduleProvider>(context,
                              listen: false)
                          .addWorkingHours(context,
                              startTime: val[0], endTime: val[1]);
                    },
                  )
                : str == "time-interval"
                    ? TimeIntervalWidget(
                        onChanged: (val) async {
                          print('Val: $val');
                          await Provider.of<JobScheduleProvider>(context,
                                  listen: false)
                              .addTimeInterval(context,
                                  hour: val[0], minute: val[1]);
                        },
                      )
                    : str == "max-job-task"
                        ? MaxJobTaskWidget(
                            onChanged: (val) async {
                              await Provider.of<JobScheduleProvider>(context,
                                      listen: false)
                                  .addMaxJobTask(context, maxJob: val);
                            },
                          )
                        : str == "reminder"
                            ? ReminderWidget()
                            : Container();
          }));
    },
  ).then((value) {
    if (value != null) {
    } else if (value is List) {
      //todo set working hours
      print(value.toString());
    } else if (value is Map<String, int?>) {
      if (value['interval'] == null) {
        //todo maxJob
      } else if (value['max_job'] == null) {
        //todo interval
      }
    }
  });
}
