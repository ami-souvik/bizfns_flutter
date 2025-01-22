import 'dart:developer';

import 'package:bizfns/core/route/NavRouter.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/JobScheduleModel/schedule_list_response_model.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/service_entity_question_answer_model.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/service_entity_question_model.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../provider/job_schedule_controller.dart';
import 'add_schedule_model.dart';

class AddScheduleModel {
  String? jobId;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? custInvoiceCreatedIds;
  String jobStopDate = '';
  String? paymentModeId;
  String? paymentTypeId;
  String? paymentDuration;
  String? deposit;

  ///todo: for multiple customer List<CustomerList>? customerList;
  ///
  ///currently doing single customer
  ///
  List<CustomerData>? customer;
  List<CustomerData>? tempCustomerList;
  List<ServiceList>? serviceList;
  List<Services>? newServiceList;
  List<MaterialList>? materialList;
  List<JOBMATERIAL>? newMaterialList;

  List<StaffID>? staffList;
  List<ImageList>? allImageList;
  String? note;
  String imageId = '';
  Map<String, dynamic>? serviceEntity;

  bool isAdding = true;
  bool isEdit = false;

  List<XFile>? images;
  List<ImageList>? copyImages;

  String? location;
  String? duration;
  // String? totalJobs;
  String? totalJobs;

  String? recurrType;
  String? weekNumber;
  int? jobStatus;
  List<String>? serviceEntityID;
  List<String>? serviceEntityName;
  bool? isRecurSelectionIsFromCalender;
  String? recurSelectedDate;

  /*AddScheduleModel(
      {required this.jobId,
      required this.startDate,
      required this.endDate,
      required this.customerList,
      required this.serviceList,
      required this.materialList});*/

  static final AddScheduleModel addSchedule = AddScheduleModel._internal();

  AddScheduleModel._internal();

  factory AddScheduleModel(
      {String? jobId,
      String? startDate,
      String? endDate,
      String? startTime,
      String? endTime,
      String? custInvoiceCreatedIds,
      String jobStopDate = '',
      String? paymentModeId,
      String? paymentTypeId,
      String? paymentDuration,
      String? deposit,

      ///todo: multiple customer List<CustomerList>? customerList,
      ///
      ///
      List<CustomerData>? customerData,
      List<CustomerData>? tempCustomerList,
      List<ServiceList>? serviceList,
      List<Services>? newServiceList,
      List<MaterialList>? materialList,
      List<JOBMATERIAL>? newMaterialList,
      List<StaffID>? staffList,
      List<ImageList>? allImageList,
      String note = "",
      String imageId = "",
      Map<String, dynamic>? entity,
      bool isAdding = true,
      bool isEdit = false,
      List<XFile>? imageList,
      List<ImageList>? copyImages,
      String location = "",
      String? recurringDuration,
      // String? jobs,
      String? jobs,
      String? recType,
      String? weekNo,
      int? jobStatus,
      bool? isRecurSelectionIsFromCalender,
      String? recurSelectedDate}) {
    addSchedule.isRecurSelectionIsFromCalender = false;
    addSchedule.recurSelectedDate = recurSelectedDate;
    addSchedule.jobId = jobId;
    addSchedule.startDate = startDate;
    addSchedule.endDate = endDate;
    addSchedule.startTime = startTime;
    addSchedule.endTime = endTime;
    addSchedule.custInvoiceCreatedIds = custInvoiceCreatedIds;
    addSchedule.jobStopDate = jobStopDate;
    addSchedule.paymentModeId = paymentModeId;
    addSchedule.paymentTypeId = paymentTypeId;
    addSchedule.paymentDuration = paymentDuration;
    addSchedule.deposit = deposit;

    ///todo: addSchedule.customerList = customerList;
    ///
    ///
    ///
    addSchedule.customer = customerData;
    addSchedule.tempCustomerList = tempCustomerList;
    addSchedule.allImageList = allImageList;
    addSchedule.serviceList = serviceList;
    addSchedule.newServiceList = newServiceList;
    addSchedule.materialList = materialList;
    addSchedule.newMaterialList = newMaterialList;
    addSchedule.staffList = staffList;
    addSchedule.note = note;
    addSchedule.imageId = imageId;
    addSchedule.serviceEntity = entity;

    addSchedule.isAdding = isAdding;

    addSchedule.isEdit = isEdit!;

    addSchedule.images = imageList;
    addSchedule.copyImages = copyImages;

    addSchedule.location = location;

    addSchedule.duration = recurringDuration;

    addSchedule.totalJobs = jobs;

    addSchedule.recurrType = recType;

    addSchedule.weekNumber = weekNo;

    return addSchedule;
  }

  bool validateServiceEntry(BuildContext context) {
    log("service report------>${addSchedule.serviceList}");
    /*if (addSchedule.customer!.customerId == null ||
        addSchedule.staffList == null ||
        addSchedule.materialList == null ||
        addSchedule.serviceList == null) {
      return false;
    } else {
      return true;
    }*/

    ///validation for customer
    ///
    ///-------------old validation while scheduling-------------///
    // if (addSchedule.customer == null) {
    //   Utils().ShowErrorSnackBar(
    //       context, 'Error', 'Please add customer to create a job');
    //   return false;
    // } /*else if (addSchedule.serviceEntity == null) {
    //   Utils().ShowErrorSnackBar(context, 'Error', 'Please add service object ');
    //   return false;
    // } */
    // else if (addSchedule.staffList == null) {
    //   Utils().ShowErrorSnackBar(
    //       context, 'Error', 'Staff is required to create a job');
    //   return false;
    // } else if (addSchedule.serviceList == null) {
    //   Utils().ShowErrorSnackBar(
    //       context, 'Error', 'Service is needed to be added for a job');
    //   return false;
    // } else if (addSchedule.location == null) {
    //   Utils().ShowErrorSnackBar(
    //       context, 'Error', 'Select your location for the job');
    //   return false;
    // } else {
    //   return true;
    // }
    //----------------------------------------------------------------//
    if (addSchedule.serviceList == null) {
      Utils().ShowErrorSnackBar(
          context, 'Error', 'Please add service to create a job');
      return false;
    } else if (addSchedule.serviceList!.isEmpty) {
      Utils().ShowErrorSnackBar(
          context, 'Error', 'Please add service to create a job');
      return false;
    } else {
      return true;
    }
  }

  clearData() {
    addSchedule.startDate = null;
    addSchedule.startTime = null;
    addSchedule.endDate = null;
    addSchedule.endTime = null;
    addSchedule.custInvoiceCreatedIds = null;
    addSchedule.customer = null;
    addSchedule.tempCustomerList = null;
    addSchedule.staffList = null;
    addSchedule.materialList = null;
    addSchedule.newMaterialList = null;
    addSchedule.serviceList = null;
    addSchedule.newServiceList = null;
    addSchedule.note = "";
    addSchedule.imageId = "";
    addSchedule.jobId = null;
    addSchedule.serviceEntity = null;
    addSchedule.location = "";
    addSchedule.totalJobs = null;
    addSchedule.duration = null;
    addSchedule.recurrType = null;
    addSchedule.images = null;
    addSchedule.jobStatus = null;
    addSchedule.allImageList = null;
    addSchedule.jobStopDate = "";
    addSchedule.paymentModeId = "";
    addSchedule.paymentTypeId = "";
    addSchedule.paymentDuration = "";
    addSchedule.deposit = "";
    addSchedule.isRecurSelectionIsFromCalender = null;
  }

  Map<String, dynamic> toJson(List<String> deviceDetails, userId, companyId) {
    final Map<String, dynamic> data = <String, dynamic>{};
    String recType = recurrType == "Yearly"
        ? "Year"
        : recurrType == "Weekly"
            ? "Week"
            : recurrType == "Monthly"
                ? "Month"
                : "Day";

    List<String> serviceIDList = [];
    List<String> materialIDList = [];

    Map<String, dynamic> serviceMap = {};

    Map<String, dynamic> jobDetailsMap = {};
    Map<String, dynamic> jobDetailsMap2 = {};

    if (addSchedule.serviceList != null) {
      addSchedule.serviceList!.forEach((element) {
        serviceIDList.add(element.serviceID!);
      });
      serviceMap = {'serviceId': serviceIDList.join(',')};
    } else {}

    if (addSchedule.materialList != null) {
      addSchedule.materialList!.forEach((element) {
        materialIDList.add(element.materialID!);
      });
    }

    List<Map<String, String>> formattedMaterialList = materialIDList.map((id) {
      return {
        "materialId": id,
      };
    }).toList();
    print("in model isEdit value===>$isEdit");

    String imageIds = addSchedule.imageId;

// Split the string into a List of image IDs
    List<String> imageIdList = imageIds.split(',');

// Convert the List to a Set to remove duplicates
    Set<String> uniqueImageIds = Set.from(imageIdList);

// Convert the Set back to a List if needed
    List<String> uniqueImageIdList = uniqueImageIds.toList();

// Convert the List back to a comma-separated String
    String uniqueImageIdsString = uniqueImageIdList.join(',');
    // isEdit == false
    //     ?
    String convertTo24HourFormat(String time) {
      try {
        // Ensure the time string is trimmed to remove any leading/trailing spaces
        time = time.trim();
        log("addSchedule.startTime : ${addSchedule.startTime}");
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

    // String convertTo24HourFormat(String time) {
    //   print("addSchedule.startTime : ${addSchedule.startTime}");
    //   DateFormat inputFormat = DateFormat("hh:mm a");
    //   DateFormat outputFormat = DateFormat("HH:mm");
    //   DateTime parsedTime = inputFormat.parse(time);
    //   return outputFormat.format(parsedTime);
    // }
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

    String convertTimeFormatWhileEditing(String timeString) {
      log("Getting timeString : ${timeString}");
      log("isEdit Editing : ${addScheduleModel!.isEdit}");
      log("convertTimeFormatWhileEditing calling");
      // Parse the input time string
      DateTime parsedTime = DateFormat('hh:mm:ss a').parse(timeString);

      // Format the time as 'HH:mm' (24-hour format)
      String formattedTime = DateFormat('HH:mm').format(parsedTime);

      return formattedTime;
    }

    log("number of jobs : ${totalJobs}");
    jobDetailsMap = {
      'startDate': addSchedule.startDate!.split(" ")[0],
      'startTime': convertTimeFormatWhileAdding(addSchedule.startTime!),
      'endDate': addSchedule.endDate!.split(" ")[0],
      'endTime': convertTimeFormatWhileAdding(addSchedule.endTime!),
      "jobstopdate": addSchedule.jobStopDate!.split(" ")[0],
      "imageId": addSchedule.imageId,
      'customer': customer != null
          ? customer!.map((v) => v.toJson()).toList() ?? []
          : [],
      'staffList':
          staffList == null ? [] : staffList!.map((v) => v.toJson()).toList(),
      'service': serviceMap,
      //'serviceEntityQuestions': addSchedule.serviceEntity,
      /*"serviceEntityQuestions": {
        "item": "",
        "data": [
          {
            "question_id": "1",
            "question_name": "Phone Number",
            "answer": "9876543210",
            "answer_type_id": "1"
          },
          {
            "question_id": "4",
            "question_name": "Name",
            "answer": "sayan",
            "answer_type_id": "1"
          }
        ]
      },*/
      'paymentModeId': addSchedule.paymentModeId,
      'paymentTypeId': addSchedule.paymentTypeId,
      "paymentDuration": addSchedule.paymentDuration,
      'deposit': addSchedule.deposit,
      'materialList': formattedMaterialList,
      'note': note,
      'attachments': [],
      // "DurationOfrecurr": duration ?? '0',
      "DurationOfrecurr": recType == 'Year'
          ? '365'
          : recType == 'Week'
              ? '7'
              : recType == 'Month'
                  ? '30'
                  // : '1',
                  : recType == 'Day'
                      ? '1'
                      : '0',

      // "Numberofrecurr": totalJobs ?? '1',  //totalJobs == '0' ||  ? totalJobs == null ? '1' ?? totalJobs
      "Numberofrecurr": totalJobs == null || totalJobs == '0' ? '1' : totalJobs,
      "recurrType": recType,
      "weekNumber": weekNumber ?? "0",
      "jobstatus": "0",
      "joblocation": location
      //'job_id' : addSchedule.jobId == null ? "" : addSchedule.jobId!.toString(),
    };
    jobDetailsMap2 = {
      'startDate': addSchedule.startDate!.split(" ")[0],
      // 'startTime': addSchedule.startTime!.split(" ")[0],
      'startTime': convertTimeFormatWhileAdding(addSchedule.startTime!),
      'endDate': addSchedule.endDate!.split(" ")[0],
      // 'endTime': addSchedule.endTime!.split(" ")[0],
      'endTime': convertTimeFormatWhileAdding(addSchedule.endTime!),
      "jobstopdate": addSchedule.jobStopDate!.split(" ")[0],
      "imageId": uniqueImageIdsString,
      'customer': customer != null
          ? customer!.map((v) => v.toJson()).toList() ?? []
          : [],
      'staffList':
          staffList == null ? [] : staffList!.map((v) => v.toJson()).toList(),
      'service': serviceMap,
      'paymentModeId': addSchedule.paymentModeId,
      'paymentTypeId': '',
      'materialList': formattedMaterialList,
      'note': note,
      // 'attachments': [],
      //newly added recur for modify//
      "DurationOfrecurr": recType == 'Year'
          ? '365'
          : recType == 'Week'
              ? '7'
              : recType == 'Month'
                  ? '30'
                  : recType == 'Day'
                      ? '1'
                      : '0',

      "Numberofrecurr": totalJobs == null || totalJobs == '0' ? '1' : totalJobs,
      "recurrType": recType,
      "weekNumber": weekNumber ?? "0",
      //----------------------------//
      "jobstatus": "0",
      "joblocation": location
    };

    data["deviceId"] = deviceDetails[0];
    data["deviceType"] = deviceDetails[1];
    data["appVersion"] = deviceDetails[2];
    data["userId"] = userId;
    data["tenantId"] = companyId;
    data['job_id'] =
        addSchedule.jobId == null ? "" : addSchedule.jobId!.toString();
    log("IS_EDIT_007 : ${isEdit}");
    data['jobDetails'] = isEdit == false ? jobDetailsMap : jobDetailsMap2;
    // isEdit == false ? data['isAdding'] = isAdding : '';
    return data;
  }
}

class MaterialList {
  int? index;
  String? materialID;
  String? materialName;

  MaterialList({
    required this.index,
    required this.materialID,
    required this.materialName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['material_id'] = materialID;
    return data;
  }

  factory MaterialList.fromJson(Map<String, dynamic> json) {
    return MaterialList(
      index: json['index'],
      materialID: json['material_id'],
      materialName: json['materialName'],
    );
  }
}

class NewMaterialList {
  int? pKMATERIALID;
  String? mATERIALNAME;
  String? rATE;
  String? mATERIALUNITNAME;

  NewMaterialList(
      {this.pKMATERIALID, this.mATERIALNAME, this.rATE, this.mATERIALUNITNAME});

  NewMaterialList.fromJson(Map<String, dynamic> json) {
    pKMATERIALID = json['PK_MATERIAL_ID'];
    mATERIALNAME = json['MATERIAL_NAME'];
    rATE = json['RATE'];
    mATERIALUNITNAME = json['MATERIAL_UNIT_NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PK_MATERIAL_ID'] = this.pKMATERIALID;
    data['MATERIAL_NAME'] = this.mATERIALNAME;
    data['RATE'] = this.rATE;
    data['MATERIAL_UNIT_NAME'] = this.mATERIALUNITNAME;
    return data;
  }
}

class CustomerData {
  int? index;
  String? customerId;
  String? customerName;
  List<String>? serviceEntityId;
  List<String>? serviceEntityName;

  CustomerData(
      {this.customerId,
      this.customerName,
      this.serviceEntityId,
      this.serviceEntityName,
      this.index});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['customerId'] = customerId;
    data['serviceEntityId'] = serviceEntityId;
    // data['serviceentityname'] = serviceEntityName;
    return data;
  }
}

class ServiceList {
  int? index;
  String? serviceID;
  String? serviceName;

  ServiceList({
    required this.index,
    required this.serviceID,
    required this.serviceName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceID'] = serviceID;
    return data;
  }

  factory ServiceList.fromJson(Map<String, dynamic> json) {
    return ServiceList(
      index: json['index'],
      serviceID: json['serviceID'],
      serviceName: json['serviceName'],
    );
  }
}

// class Services {
//   int? iD;
//   String? sERVICENAME;
//   int? rATE;
//   String? rATEUNITNAME;

//   Services({this.iD, this.sERVICENAME, this.rATE, this.rATEUNITNAME});

//   Services.fromJson(Map<String, dynamic> json) {
//     iD = json['ID'];
//     sERVICENAME = json['SERVICE_NAME'];
//     rATE = json['RATE'];
//     rATEUNITNAME = json['RATE_UNIT_NAME'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ID'] = this.iD;
//     data['SERVICE_NAME'] = this.sERVICENAME;
//     data['RATE'] = this.rATE;
//     data['RATE_UNIT_NAME'] = this.rATEUNITNAME;
//     return data;
//   }
// }

class StaffID {
  int? index;
  String? id;
  String staffName;

  StaffID({required this.index, required this.id, required this.staffName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['staffId'] = id;
    return data;
  }

  factory StaffID.fromJson(Map<String, dynamic> json) {
    return StaffID(
      index: json['index'],
      id: json['staffId'],
      staffName: json['staffName'],
    );
  }
}
