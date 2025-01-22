import 'dart:convert';
import 'dart:developer';

import 'package:bizfns/core/model/dropdown_model.dart';
import 'package:bizfns/features/Admin/data/api/add_user_api_client/add_user_api_client_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../../../../core/common/Status.dart';
import '../../../../../core/route/RouteConstants.dart';
import '../../../../../core/utils/Utils.dart';
import '../../../../core/common/Resource.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../core/utils/const.dart';
import '../../../../core/utils/route_function.dart';
import '../../../Settings/job_list.dart';
import '../../../Settings/model/get_job_number_by_date_model.dart';
import '../../../Settings/model/time_sheet_by_billno_staff_model.dart';
import '../../../auth/Login/model/login_otp_verification_model.dart';

import '../../../auth/Login/provider/login_provider.dart';
import '../../model/get_staff_details_model.dart';
import '../../model/preStaffCreationData.dart';
import '../../model/staffListResponseModel.dart';
import '../repo/staff_repo_impl.dart';

class StaffProvider extends ChangeNotifier {
  final StaffRepoImpl? addCustomerRepository =
      new StaffRepoImpl(apiClient: AddUserApiClientImpl());

  final formKey = GlobalKey<FormState>();
  bool loading = false;
  List<int> selectedIndex = [];
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final rateController = TextEditingController();

  TextEditingController tempoPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool isTemporaryPasswordHidden = true;
  bool isPasswordHidden = true;
  var costRateBy;

  initialController() {
    isTemporaryPasswordHidden = true;
    isPasswordHidden = true;
  }
  // AddStaffProvider({this.addCustomerRepository});

  List<StaffTypeDetailsList> staffTypeDetailsList = [];
  List<WageFrequencyDetailsList> wageFrequencyDetailsList = [];
  List<StaffDetailsData> staffDetailsData = [];
  var firstIndex =
      DropdownModel(id: "-1", name: "Select One", dependentid: "-1");
  var selectedStaffType =
      DropdownModel(id: "-1", name: "Select One", dependentid: "-1");
  var selectedFrequency =
      DropdownModel(id: "-1", name: "Select One", dependentid: "-1");
  List<DropdownModel> staffTypeList = [
    DropdownModel(id: "-1", name: "Select One", dependentid: "-1")
  ];
  List<DropdownModel> frequencyList = [
    DropdownModel(id: "-1", name: "Select One", dependentid: "-1")
  ];

  List<StaffListData>? staffList = [];

  String searchText = '';

  void searchCustomer(context, String text) {
    searchText = text;
    notifyListeners();
  }

  bool isSwitched = false;

  toggleSwitch(bool value) {
    isSwitched = value;
    notifyListeners();
  }

  final maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  validity(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String phone,
    bool isEdit,
    String? staffId, [
    staffActiveStatus,
  ]) {
    if (lastName.isEmpty) {
      Utils().ShowWarningSnackBar(context, "Opps", "Enter Last Name");
    } else if (email.isNotEmpty && !Utils.IsValidEmail(email)) {
      Utils().ShowWarningSnackBar(context, "Opps", "Enter a valid Email Id");
    } else if (phone.isEmpty) {
      Utils().ShowWarningSnackBar(context, "Opps", "Enter Mobile Number");
    } else if (rateController.text.isEmpty) {
      Utils().ShowWarningSnackBar(context, "Opps", "Enter rate");
    } else if (phone.length < 14) {
      Utils()
          .ShowWarningSnackBar(context, "Opps", "Enter a valid Mobile Number");
    } else if (selectedStaffType.id == "-1") {
      Utils().ShowWarningSnackBar(context, "Opps", "Choose a staff type");
    } else if (selectedFrequency.id == "-1") {
      Utils().ShowWarningSnackBar(context, "Opps", "Choose a rate frequency");
    } else {
      isEdit
          ? editStaffDetails(context: context, staffId: staffId!)
          : addStaff(context, firstName, lastName, email, phone);
    }
  }

  void addStaff(BuildContext context, String firstName, String lastName,
      String email, String phone) async {
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);

    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "userId": userId,
      "tenantId": loginData!.tenantId!,
      "staffFirstName": firstName,
      "staffLastName": lastName,
      "staffEmail": email.isEmpty ? null : email,
      "staffMobile": phone,
      "staffType": selectedStaffType.id,
      "companyId": loginData!.cOMPANYID.toString(),
      "chargeRate": rateController.text,
      "chargeFrequency": selectedFrequency.id
    };
    addCustomerRepository!.addStaff(body: body).then((value) async {
      print("value.message===============>${value.message}");
      if (value.status == STATUS.SUCCESS) {
        log("jlkjljlj--->${value.message}");
        loading = false;
        EasyLoading.dismiss();
        if (value.message!
            .contains('You cannot be added as a staff in your own company')) {
          Utils().ShowErrorSnackBar(context, "Error", "${value.message}",
              duration: Duration(seconds: 2));
        } else {
          Utils().ShowSuccessSnackBar(context, "Success",
              "Successfully staff added \n ${value.message}",
              duration: Duration(seconds: 2));
        }
        await getStaffList(context);
        await Future.delayed(Duration(seconds: 2));

        //Navigate.NavigateAndReplace(context, staff_list, params: {});

        if (GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
            '/home/schedule') {
          Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        }

        GoRouter.of(context).pop();
      } else {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(context, "Failed", value.message!);
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
      }
    }, onError: (err) {
      loading = false;
      EasyLoading.dismiss();
      Utils().printMessage("ADD_CUSTOMER_ERROR==>$err");
    });
  }

  getPreStaffCreationData(
      {required BuildContext context,
      required String firstName,
      required String lastName,
      required String email,
      required String phone,
      required String rate,
      required String staffType,
      required String frequencyID,
      required int? activeStatus}) async {
    print("getting staffid -> ${staffType}");
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    firstNameController.text = firstName;
    lastNameController.text = lastName;
    emailController.text = email;
    phoneController.text = maskFormatter.maskText(phone);
    rateController.text = rate;
    if (activeStatus != null) {
      if (activeStatus == 1) {
        isSwitched = true;
        notifyListeners();
      } else {
        isSwitched = false;
        notifyListeners();
      }
    }
    staffTypeList.clear();
    frequencyList.clear();
    staffTypeList = [
      DropdownModel(id: "-1", name: "Select One", dependentid: "-1")
    ];
    frequencyList = [
      DropdownModel(id: "-1", name: "Select One", dependentid: "-1")
    ];

    // selectedStaffType = staffTypeList.first;
    // selectedFrequency = frequencyList.first;

    Utils().check_internet_connection(context).then((value) async {
      if (value != null && value == true) {
        // loading = true;
        // EasyLoading.show(
        //     status: "Loading",
        //     indicator: CircularProgressIndicator(),
        //     dismissOnTap: false);

        OtpVerificationData? loginData = await GlobalHandler.getLoginData();
        List<String> deviceDetails = await Utils.getDeviceDetails();
        var body = {
          "deviceId": deviceDetails[0],
          "deviceType": deviceDetails[1],
          "appVersion": deviceDetails[2],
          "tenantId": loginData!.tenantId
        };

        print(body);
        log("getPreStaffCreationData  :  ${jsonEncode(body)}");

        await addCustomerRepository!
            .getStaffData(body: body)
            .then((value) async {
          if (value.status == STATUS.SUCCESS) {
            if (value.data != null) {
              try {
                // EasyLoading.show(
                //     status: "Loading",
                //     indicator: CircularProgressIndicator(),
                //     dismissOnTap: false);
                StaffCreationData staffCreationData = value.data;
                if (staffCreationData.staffTypeDetailsList != null) {
                  selectedStaffType = firstIndex;
                  Utils().printMessage("here======");
                  staffTypeDetailsList.clear();
                  staffTypeList.clear();
                  staffTypeList.add(firstIndex);
                  staffTypeDetailsList
                      .addAll(staffCreationData.staffTypeDetailsList!);
                  for (var staffType in staffTypeDetailsList) {
                    staffTypeList.add(DropdownModel(
                        id: staffType.pKTYPEID.toString(),
                        dependentid: staffType.pKTYPEID.toString(),
                        name: staffType.tYPENAME.toString()));
                  }
                  if (staffType.isNotEmpty) {
                    selectedStaffType = staffTypeList.firstWhere((element) =>
                        int.parse(element.id.toString()) ==
                        int.parse(staffType));
                    notifyListeners();
                  } else {
                    selectedStaffType = firstIndex;
                    notifyListeners();
                  }
                  // selectedStaffType = staffTypeList.firstWhere((element) => element.id.toString().contains(staffID));
                  print(selectedStaffType);
                  notifyListeners();
                }
                if (staffCreationData.wageFrequencyDetailsList != null) {
                  Utils().printMessage("here==987998098====");
                  wageFrequencyDetailsList.clear();
                  frequencyList.clear();
                  frequencyList.add(firstIndex);
                  wageFrequencyDetailsList
                      .addAll(staffCreationData.wageFrequencyDetailsList!);
                  for (var rate in wageFrequencyDetailsList) {
                    frequencyList.add(DropdownModel(
                        id: rate.pKFREQUENCYID.toString(),
                        dependentid: rate.pKFREQUENCYID.toString(),
                        name: rate.fREQUENCYTYPE.toString()));
                  }

                  if (frequencyID.isNotEmpty) {
                    selectedFrequency = frequencyList.firstWhere((element) =>
                        int.parse(element.id.toString()) ==
                        int.parse(frequencyID));
                    notifyListeners();
                  } else {
                    selectedFrequency = firstIndex;
                    notifyListeners();
                  }

                  notifyListeners();
                }
                loading = false;
                EasyLoading.dismiss();
                notifyListeners();
              } catch (e) {
                Utils().printMessage(e.toString());
                loading = false;
                EasyLoading.dismiss();
              }
            }
          } else {
            Utils().ShowErrorSnackBar(
                context, "Failed", value.message ?? "Failure");
            loading = false;
            EasyLoading.dismiss();
            if (value.message == TOKEN_EXPIRED) {
              Utils.Logout(context);
            }
          }
        });
      } else {
        loading = false;
        notifyListeners();
      }
    });
  }

  getStaffList(BuildContext context, {bool? searchRefresh}) {
    loading = searchRefresh == null ? true : false;
    addCustomerRepository!.getStaffList(context).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        loading = false;
        EasyLoading.dismiss();
        // Utils().ShowSuccessSnackBar(context, "Success", value.message??"Successfully customer added");
        staffList!.clear();
        try {
          staffList!.addAll(value.data);
        } catch (e) {
          Utils().ShowSuccessSnackBar(
              context, "Failure", value.message ?? SomethingWentWrong);
        }
        // Navigator.pop(context);
        notifyListeners();
      } else {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(
            context, "Failed", value.message ?? "Failed to customer add");
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
        notifyListeners();
      }
    }, onError: (err) {
      Utils().printMessage("ADD_CUSTOMER_ERROR==>$err");
      EasyLoading.dismiss();
      Utils().ShowErrorSnackBar(context, "Failed", err.toString());
      notifyListeners();
    });
  }

  //STAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF//
  staffUserLogin({required context}) async {
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);

    // OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    // List<String> deviceDetails = await Utils.getDeviceDetails();
    // String? userId = await GlobalHandler.getUserId();
    var body = {
      "userId": Provider.of<LoginProvider>(context, listen: false)
          .userIdController
          .text,
      "temporaryPassword": tempoPassword.text,
      "newPassword": confirmPassword.text,
      "tenantId": Provider.of<LoginProvider>(context, listen: false)
          .selectedBusiness
          .id,
      // Provider.of<LoginProvider>(context, listen: false).sselectedBusiness,
      "staffEmail": ''
    };
    print("Incoming body====>${jsonEncode(body)}");
    addCustomerRepository!.staffUserLogin(body: body).then((value) async {
      if (value.status == STATUS.SUCCESS) {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowSuccessSnackBar(
          context,
          "Success",
          "Successfully staff added",
        );
        Provider.of<LoginProvider>(context, listen: false).tenantIds.clear();
        //Navigate.NavigateAndReplace(context, staff_list, params: {});

        if (GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
            '/home/schedule') {
          Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        }
        Provider.of<LoginProvider>(context, listen: false)
            .getBusinessId(context);
        // GoRouter.of(context).pop();
      } else {
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowErrorSnackBar(context, "Failed", value.message!);
        Utils().printMessage("STATUS FAILED");
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
      }
    }, onError: (err) {
      loading = false;
      EasyLoading.dismiss();
      Utils().printMessage("ADD_CUSTOMER_ERROR==>$err");
    });
  }

  Future<bool> validateReturn(
    BuildContext context,
  ) async {
    if (tempoPassword.text.isEmpty) {
      await Utils().ShowWarningSnackBar(
              context, 'Validation', 'Please add your temorary Password')
          //  Utils.showAlertDialog(
          //     context, 'Validation!', 'Please Select Your Date.',
          //     type: 'Error')
          ;
      // Utils.showSnackBarMessage(context, "Please Select Assignee",Colors.red);
      return false;
    }
    if (confirmPassword.text.isEmpty) {
      await await Utils().ShowWarningSnackBar(
          context, 'Validation', 'Please add your New Password');
      //Utils.showSnackBarMessage(context, "Please Select Assignee",Colors.red);
      return false;
    }

    return true;
  }

  getStaffDetails(
      {required String phoneNo, required BuildContext context}) async {
    // loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    addCustomerRepository!.getstaffDetails(staffPhoneNo: phoneNo).then((value) {
      if (value.status == STATUS.SUCCESS) {
        // loading = false;
        EasyLoading.dismiss();
        if (value.data != null) {
          try {
            StaffDetailsData data = value.data;
            // staffDetailsData.add(data);
            // log("====${staffTypeList.where((element) => element.id == "2")}");
            // staffTypeList.where((element) => element.id == "2");
            // print(staffTypeList.firstWhere(
            //     (element) => element.id!.contains(data.stafftype.toString())));
            // selectedStaffType = staffTypeList.firstWhere((element) => element.id!.contains(data.stafftype.toString()));
            notifyListeners();
            GoRouter.of(context).pushNamed('parent-add-staff', extra: {
              'isEdit': true,
              'firstName': data.stafffirstname,
              'lastName': data.stafflastname,
              'email': data.staffemail,
              'phone': data.staffmobile,
              'staffId': data.staffid.toString(),
              'staffType': data.stafftype.toString(),
              'friquencyId': data.chargefrequency.toString(),
              'rate': data.chargerate.toString(),
              'activeStatus':
                  int.parse(data.staffactiveinactivestatus.toString())
            }).then((value) async {
              await getStaffList(context);
            });
          } catch (e) {
            Utils().printMessage(e.toString());
            // loading = false;
            EasyLoading.dismiss();
          }
        }
      } else {
        Utils()
            .ShowErrorSnackBar(context, "Failed", value.message ?? "Failure");
        // loading = false;
        EasyLoading.dismiss();
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
      }
    });
  }

  //---------------Get-staff-details-when-staff-login--------------//
  getStaffDetailsWhileStaffLogin({required BuildContext context}) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    await addCustomerRepository!
        .getstaffDetailsForStaffLogin()
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        if (value.data != null) {
          try {
            StaffDetailsData data = value.data;
            await getStaffRateForStaffLogin(
                context: context, id: data.chargefrequency!);
            notifyListeners();
            EasyLoading.dismiss();
            GoRouter.of(context).pushNamed('time-sheet', extra: {
              'data': data,
            }).then((value) {
              Provider.of<TitleProvider>(context, listen: false)
                  .changeTitle('Settings');
            });
          } catch (e) {
            Utils().printMessage(e.toString());
            EasyLoading.dismiss();
          }
        }
      } else {
        Utils()
            .ShowErrorSnackBar(context, "Failed", value.message ?? "Failure");
        EasyLoading.dismiss();
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
      }
    });
  }

  //---------------------get-staff-rate-value----------------------//
  getStaffRateForStaffLogin(
      {required BuildContext context, required int id}) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    var body = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "tenantId": loginData!.tenantId
    };
    log("GET_STAFF_RATE_FOR_STAFF_LOGIN_BODY : ${jsonEncode(body)}");
    await addCustomerRepository!.getStaffData(body: body).then((value) {
      if (value.status == STATUS.SUCCESS) {
        if (value.data != null) {
          try {
            StaffCreationData staffCreationData = value.data;
            wageFrequencyDetailsList.clear();
            if (staffCreationData.staffTypeDetailsList != null) {
              // staffTypeDetailsList
              //     .addAll(staffCreationData.staffTypeDetailsList!);
              wageFrequencyDetailsList
                  .addAll(staffCreationData.wageFrequencyDetailsList!);
              costRateBy = wageFrequencyDetailsList
                  .firstWhere((element) => element.pKFREQUENCYID == id)
                  .fREQUENCYTYPE;
              log("x : ${costRateBy}");
              notifyListeners();
              EasyLoading.dismiss();
            }
          } catch (e) {
            Utils().printMessage(e.toString());
            EasyLoading.dismiss();
          }
        }
      } else {
        Utils()
            .ShowErrorSnackBar(context, "Failed", value.message ?? "Failure");
        EasyLoading.dismiss();
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
      }
    });
  }

  //---------------------get-job-number-by-date--------------------//
  List<JobDetails> jobDetailsData = [];
  List<int> selectedJobs = [];
  List<List<List<int>>> jobEvents = [];
  Future getJobNumberByDate({
    required String date,
    required BuildContext context,
  }) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    await addCustomerRepository!
        .getJobNumberByDate(date: date)
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        try {
          GetJobNumberByDateModel getJobNumberByDateModel = value.data;
          if (getJobNumberByDateModel != null) {
            jobDetailsData = getJobNumberByDateModel.data!.jobDetails!;

            EasyLoading.dismiss();
            notifyListeners();
          } else {
            Utils().ShowErrorSnackBar(context, 'Error', '${value.message}');
            EasyLoading.dismiss();
            notifyListeners();
          }
        } catch (e) {
          log(e.toString());
          EasyLoading.dismiss();
          notifyListeners();
        }
      } else {
        Utils().ShowErrorSnackBar(context, 'Error', '${value.message}');
        EasyLoading.dismiss();
        notifyListeners();
      }
    });
  }

  submitTimeSheetBill(
      {required List<List<TextEditingController>> hourControllers,
      required List<List<TextEditingController>> overtimeControllers,
      required String timesheetBillNo,
      required int weekNumber,
      required String weekStartDate,
      required String weekEndDate,
      required String timeSheetStatus,
      required int staffId,
      required bool isExempt,
      required List<DateTime> selectedWeekDates,
      required double totalRegularHour,
      required double totalOvertimeHour,
      required double totalRegularCost,
      required BuildContext context}) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    List<Map<String, dynamic>> weekSchedule = [];
    Map<String, dynamic> dayEntry = {};

    for (var i = 0; i < selectedWeekDates.length; i++) {
      for (var j = 0; j < hourControllers[i].length; j++) {
        log("JobEvents : ${jobEvents[i][j]}");
        log("HourValue ; ${hourControllers[i][j].text}");

        dayEntry =
            // {
            //   "dayOfWeek":
            //       DateFormat.EEEE().format(selectedWeekDates[i]), // Full day name
            //   "dateOfWeek": DateFormat('yyyy-MM-dd')
            //       .format(selectedWeekDates[i]), // Date in 'yyyy-MM-dd' format
            //   "jobEvents": jobEvents[i][j].join(','),
            //   "regularHour": hourControllers[i][j].text.isEmpty
            //       ? 0.0
            //       : int.parse(hourControllers[i][j].text.toString()).toDouble(),
            //   "overtimeHour": overtimeControllers[i][j].text.isEmpty
            //       ? 0.0
            //       : int.parse(overtimeControllers[i][j].text.toString()).toDouble()
            // }
            {
          "dayOfWeek":
              DateFormat.EEEE().format(selectedWeekDates[i]), // Full day name
          "dateOfWeek": DateFormat('yyyy-MM-dd')
              .format(selectedWeekDates[i]), // Date in 'yyyy-MM-dd' format
          "jobEvents": jobEvents[i][j].join(','),
          "regularHour": hourControllers[i][j].text.isEmpty
              ? 0.00
              : double.parse(double.parse(hourControllers[i][j].text)
                  .toStringAsFixed(
                      2)), // Keep as double with two decimal places
          "overtimeHour": overtimeControllers[i][j].text.isEmpty
              ? 0.00
              : double.parse(double.parse(overtimeControllers[i][j].text)
                  .toStringAsFixed(2)) // Keep as double with two decimal places
        };
        weekSchedule.add(dayEntry);
      }
    }

    log("weekSchedule : ${jsonEncode(weekSchedule)}");

    var body = {
      "timesheetBillNo": timesheetBillNo,
      "weekNumber": weekNumber,
      "weekStartDate": weekStartDate,
      "weekEndDate": weekEndDate,
      "timeSheetStatus": "Approved",
      "staffId": staffId,
      "isExempt": isExempt,
      "entries": weekSchedule,
      "totalRegularHour": totalRegularHour,
      "totalOvertimeHour": totalOvertimeHour,
      "totalRegularCost": totalRegularCost,
      "totalOvertimeCost": 120.00,
      "totalPayableCost": 1800.00
    };

    log("DemoJson : ${jsonEncode(body)}");
    Utils().check_internet_connection(context).then((value) async {
      if (value != null && value == true) {
        await addCustomerRepository!.saveTimeSheet(body: body).then((value) {
          if (value.status == STATUS.SUCCESS) {
            if (value.data != null) {
              log("VAL : ${value.data}");
              EasyLoading.dismiss();
              Utils().ShowSuccessSnackBar(context, 'Success',
                  value.message ?? "Time Sheet Saved Successfully");
              notifyListeners();
            } else {
              EasyLoading.dismiss();
              notifyListeners();
            }
          } else {
            Utils().ShowErrorSnackBar(
                context, "Failed", value.message ?? "Failure");
            loading = false;
            EasyLoading.dismiss();
            if (value.message == TOKEN_EXPIRED) {
              Utils.Logout(context);
            }
          }
        });
      }
    });
  }

  //-----------------Time-sheet-By-Bill-no-Id------------------//
  List<TimeSheetData> timeSheetData = [];
  Future getTimeSheetByBillNoId(
      {required String billNo, required String staffId}) async {
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    await addCustomerRepository!
        .timeSheetByBillNoId(billNo: billNo, staffId: staffId)
        .then((value) {
      if (value.status == STATUS.SUCCESS) {
        try {
          if (value.data != null) {
            TimeSheetByBillNoAndStaffModel resp =
                value.data as TimeSheetByBillNoAndStaffModel;
            timeSheetData.clear();
            timeSheetData.addAll(resp.data!.timeSheetData!);
            notifyListeners();
          }
          EasyLoading.dismiss();
        } catch (e) {
          Utils().printMessage("STATUS Failure ==>>> " + e.toString());
          EasyLoading.dismiss();
        }
      } else {
        EasyLoading.dismiss();
        timeSheetData = [];
      }
    });
  }

  editStaffDetails(
      {required BuildContext context, required String staffId}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    await addCustomerRepository!
        .editStaffDetails(
            staffPhoneNumber: phoneController.text
                .replaceAll('(', '')
                .replaceAll(')', '')
                .replaceAll('-', '')
                .removeAllWhitespace,
            staffFirstName: firstNameController.text,
            staffLastName: lastNameController.text,
            staffEmail: emailController.text,
            staffId: staffId,
            // staffMobile: phoneController.text
            //     .replaceAll('(', '')
            //     .replaceAll(')', '')
            //     .replaceAll('-', '')
            //     .removeAllWhitespace,
            staffType: selectedStaffType.id.toString(),
            companyId: loginData!.cOMPANYID.toString(),
            chargeRate: rateController.text,
            chargeFrequency: selectedFrequency.id.toString(),
            staffActiveStatus: isSwitched ? '1' : '0')
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        print("value.message ===>${value.message}");
        loading = false;
        EasyLoading.dismiss();
        Utils().ShowSuccessSnackBar(context, "Success", "${value.message}",
            duration: Duration(seconds: 2));
        await getStaffList(context);
        await Future.delayed(Duration(seconds: 2));

        //Navigate.NavigateAndReplace(context, staff_list, params: {});

        if (GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
            '/home/schedule') {
          Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        }

        GoRouter.of(context).pop();
      } else {
        Utils()
            .ShowErrorSnackBar(context, "Failed", value.message ?? "Failure");
        loading = false;
        EasyLoading.dismiss();
        if (value.message == TOKEN_EXPIRED) {
          Utils.Logout(context);
        }
      }
    });
  }

  //-------------------------DELETE-STAFF------------------------//
  deleteStaff(
      {required String staffPhoneNo, required BuildContext context}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    loading = true;
    EasyLoading.show(
        status: "Loading",
        indicator: CircularProgressIndicator(),
        dismissOnTap: false);
    await addCustomerRepository!
        .deleteStaff(staffPhoneNumber: staffPhoneNo)
        .then((value) async {
      if (value.status == STATUS.SUCCESS) {
        getStaffList(context);
        EasyLoading.dismiss();
        loading = false;

        Utils().ShowSuccessSnackBar(
            context, "Success", value.message ?? "Successfully Staff Deleted",
            duration: Duration(seconds: 2));

        // await Future.delayed(Duration(seconds: 2));

        // if (GoRouter.of(context).routerDelegate.currentConfiguration.fullPath ==
        //     '/home/schedule') {
        //   Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        // }
        GoRouter.of(context).pop();
        //Navigate.NavigateAndReplace(context, material_list, params: {});
        notifyListeners();
      }
    });
  }
}
