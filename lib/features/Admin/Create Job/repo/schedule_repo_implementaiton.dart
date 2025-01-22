import 'package:bizfns/core/common/Resource.dart';
import 'package:bizfns/features/Admin/Create%20Job/repo/schedule_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/Status.dart';
import '../../../../core/utils/Utils.dart';

class ScheduleRepoImplementation extends ScheduleRepo {
  ScheduleRepoImplementation({required super.apiClient});

  @override
  Future<Resource> getSchedule({required String date}) async {
    Utils().printMessage("here im fetching schedule");

    Resource data = await apiClient.getScheduleList(date: date);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Schedule List fetch is successful");
    } else {
      Utils().printMessage("Can not fetch schedule list");
    }
    return data;
  }

  @override
  Future<Resource> addSchedule(
      {required Map<String, dynamic> scheduleData}) async {
    Utils().printMessage("here im adding schedule");
    print("schedule data ============================>$scheduleData");

    Resource data = await apiClient.addSchedule(data: scheduleData);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Adding Schedule is successful");
    } else {
      Utils().printMessage("Can not add schedule ");
    }
    return data;
  }

  @override
  Future<Resource> reSchedule(
      {required String jobID,
      required String startTime,
      required String endTime}) async {
    Utils().printMessage("here im adding re-schedule");

    Resource data = await apiClient.reSchedule(
      startTime: startTime,
      jobID: jobID,
      endTime: endTime,
    );
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Job has been rescheduled");
    } else {
      Utils().printMessage("Can not re-schedule this job at this moment");
    }
    return data;
  }

  @override
  Future<Resource> editSchedule(
      {required Map<String, dynamic> scheduleData}) async {
    Utils().printMessage("here im editing schedule");

    Resource data = await apiClient.editSchedule(data: scheduleData);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Editing Schedule is successful");
    } else {
      Utils().printMessage("Can not edit schedule ");
    }
    return data;
  }

  @override
  Future<Resource> deleteSchedule(
      {required Map<String, dynamic> scheduleData}) async {
    Utils().printMessage("here im deleting schedule");

    Resource data = await apiClient.deleteSchedule(data: scheduleData);
    // if (data.status == STATUS.SUCCESS) {
    //   Utils().printMessage("Schedule has been deleted");
    // } else {
    //   Utils().printMessage("Can not delete schedule ");
    // }
    return data;
  }

  @override
  Future<Resource> getServiceEntityQuestion() async {
    Utils().printMessage("here im getting service entity question");

    Resource data = await apiClient.getServiceEntityQuestion();
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Service Entity is available");
    } else {
      Utils().printMessage("Can not get service entity ");
    }
    return data;
  }

  @override
  Future<Resource> saveImage(
      {required List<XFile> image, required String tempJobID}) async {
    Utils().printMessage("here im getting service entity question");

    Resource data = await apiClient.addImage(image: image);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Service Entity is available");
    } else {
      Utils().printMessage("Can not get service entity ");
    }
    return data;
  }

  @override
  Future<Resource> generateInvoice({required String jobID}) async {
    Utils().printMessage("here im generating invoice");

    Resource data = await apiClient.generateInvoice(jobID: jobID);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("incoice is available");
    } else {
      Utils().printMessage("can not get invoice ");
    }
    return data;
  }

  @override
  Future<Resource> getServiceEntityDetails(
      {String? customerID, String? serviceEntityID}) async {
    Utils().printMessage("here im getting service entity question");

    Resource data = await apiClient.getServiceEntityDetails(
      customerID: customerID!,
      serviceEntityID: serviceEntityID,
    );
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Service Entity is available");
    } else {
      Utils().printMessage("Can not get service entity ");
    }
    return data;
  }

  @override
  Future<Resource> getReccurrDateList() async {
    Utils().printMessage("here im getting service Reccurr Date List");

    Resource data = await apiClient.getRecurrDate();
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Reccurr Date List is available");
    } else {
      Utils().printMessage("No recurr date list ");
    }
    return data;
  }

  @override
  Future<Resource> getStaffValidation(
      {required List recurDateList, required BuildContext context}) async {
    Utils().printMessage("here im getting service Reccurr Date List");

    Resource data = await apiClient.getStaffValidation(
        recurDateList: recurDateList, context: context);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Staff Validation");
    } else {
      Utils().printMessage("No Staff Validation");
    }
    return data;
  }

  @override
  Future<Resource> addServiceEntity(String customerID) async {
    Utils().printMessage("Add Service Entity");

    Resource data = await apiClient.createServiceEntity(customerID);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Added Service Entity");
    } else {
      Utils().printMessage("Can not add Service Entity");
    }
    return data;
  }

  // @override
  // Future<Resource> updateServiceEntity() async {
  //   Utils().printMessage("Add Service Entity");

  //   Resource data = await apiClient.createServiceEntity(customerID);
  //   if (data.status == STATUS.SUCCESS) {
  //     Utils().printMessage("Added Service Entity");
  //   } else {
  //     Utils().printMessage("Can not add Service Entity");
  //   }
  //   return data;
  // }

  @override
  Future<Resource> getJobStatus(
      {required Map<String, dynamic> statusData}) async {
    Utils().printMessage("Get Job Status");
    Resource data = await apiClient.getJobStatus(data: statusData);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Job status get successfully");
    } else {
      Utils().printMessage("can't get Job status successfully");
    }
    return data;
  }

  @override
  Future<Resource> saveJobStatus(
      {required Map<String, dynamic> saveJobStatusData}) async {
    Utils().printMessage("Changing Job Status");
    Resource data = await apiClient.saveJobStatus(data: saveJobStatusData);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Job status saved successfully");
    }
    return data;
  }

  @override
  Future getCustomerServiceHistory(
      {required Map<String, dynamic> customerData}) async {
    Utils().printMessage("Getting customer service history");
    var data = await apiClient.getCustomerServiceHistory(data: customerData);
    // if (data.status == STATUS.SUCCESS) {
    //   Utils().printMessage("Job status saved successfully");
    // }
    return data;
  }

  @override
  Future<Resource> updateServiceEntity({
    required String customerID,
    required String serviceEntityId,
  }) async {
    Utils().printMessage("Add Service Entity");

    Resource data = await apiClient.editServiceEntity(
        customerID: customerID, serviceEntityId: serviceEntityId);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Added Service Entity");
    } else {
      Utils().printMessage("Can not add Service Entity");
    }
    return data;
  }

  @override
  Future<Resource> deleteServiceEntity(
      {required String customerID, required String serviceEntityId}) async {
    Utils().printMessage("Add Service Entity");

    Resource data = await apiClient.deleteServiceEntity(
        customerID: customerID, serviceEntityId: serviceEntityId);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Deleted Service Entity");
    } else {
      Utils().printMessage("Can not Delete Service Entity");
    }
    return data;
  }

  @override
  Future<Resource> getTaxTable() async {
    Utils().printMessage("Get Tax Value");
    Resource data = await apiClient.getTaxTable();
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Got Tax Table Data");
    } else {
      Utils().printMessage("Can not Get Tax Table Data");
    }
    return data;
  }

  @override
  Future<Resource> getEditInvoice(
      {required String jobId, required List<int> customerIds}) async {
    Utils().printMessage("Get Edit Invoice");

    Resource data =
        await apiClient.getEditInvoice(jobId: jobId, customerIds: customerIds);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Got Edit Invoice");
    } else {
      Utils().printMessage("Can not Get Edit Invoice");
    }
    return data;
  }

  @override
  Future<Resource> saveEditInvoice(
      {required Map<String, dynamic> saveEditJson}) async {
    Utils().printMessage("Save Invoice");

    Resource data = await apiClient.saveEditInvoice(saveEditJson: saveEditJson);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("saved Invoice");
    } else {
      Utils().printMessage("Can not save Invoice");
    }
    return data;
  }

  @override
  Future<Resource> updateInvoice(
      {required Map<String, dynamic> updateJson}) async {
    Utils().printMessage("Update Invoice");

    Resource data = await apiClient.updateInvoice(updateJson: updateJson);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Updated Invoice");
    } else {
      Utils().printMessage("Can not update Invoice");
    }
    return data;
  }

  @override
  Future<Resource> getInvoicedCustomerData({required String jobId}) async {
    Utils().printMessage("Getting Invoice Customer data");

    Resource data = await apiClient.getInvoicedCustomerData(jobId: jobId);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Got Invoiced Customer Data");
    } else {
      Utils().printMessage("Can not Get Invoiced Customer Data");
    }
    return data;
  }

  @override
  Future<Resource> getPdfByCustomer(
      {required String customerId, required String jobId}) async {
    Utils().printMessage("Getting Invoice Pdf");
    var data = await apiClient.getInvoicePdfByCustomer(
        customerId: customerId, jobId: jobId);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Created Customer Pdf");
    } else {
      Utils().printMessage("Can not Create customer Pdf");
    }
    return data;
  }

  @override
  Future<Resource> addTaxTable(
      {required String taxMasterName, required String taxMasterRate}) async {
    Utils().printMessage("Adding Tax table");
    var data = await apiClient.addTaxTable(
        taxMasterName: taxMasterName, taxMasterRate: taxMasterRate);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Created Tax");
    } else {
      Utils().printMessage("Can not Create Tax");
    }
    return data;
  }

  @override
  Future<Resource> updateTaxTable(
      {required Map<String, dynamic> taxUpdates}) async {
    Utils().printMessage("Updating Tax table");
    var data = await apiClient.updateTaxTable(taxUpdates: taxUpdates);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Updated Tax");
    } else {
      Utils().printMessage("Can not Update Tax");
    }
    return data;
  }

  @override
  Future<Resource> deleteTaxTable({required String taxTypeId}) async {
    Utils().printMessage("Deleting Tax table");
    var data = await apiClient.deleteTaxTable(taxTypeId: taxTypeId);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Tax Deleted");
    } else {
      Utils().printMessage("Can not Delete Tax");
    }
    return data;
  }

  @override
  Future getWorkingHours() async {
    Utils().printMessage("Get Working Hours");
    var data = await apiClient.getWorkingHours();
    return data;
  }

  @override
  Future<Resource> addWorkingHours(
      {required String start, required String end}) async {
    var data = await apiClient.addWorkingHours(startTime: start, endTime: end);
    return data;
  }

  @override
  Future<Resource> addMaxJobTask({required String maxJobTask}) async {
    var data = await apiClient.addMaxJobTask(
      maxTask: maxJobTask,
    );
    return data;
  }

  @override
  Future<Resource> addTimeInterval(
      {required String hour, required String minute}) async {
    var data = await apiClient.addTimeInterval(hours: hour, minute: minute);
    return data;
  }

  @override
  Future getMaxJobTask() async {
    Utils().printMessage("Get Max Job");
    var data = await apiClient.getMaxJobTask();
    return data;
  }

  @override
  Future getTimeInterval() async {
    Utils().printMessage("Get Time Interval");
    var data = await apiClient.getTimeInterval();
    return data;
  }

  @override
  Future<Resource> getUserType() async {
    Utils().printMessage("Get User Type");
    var data = await apiClient.getUserType();
    return data;
  }

  @override
  Future<Resource> getUserPrivilege({required String phoneNumber}) async {
    Utils().printMessage("Get User Privilege");
    var data = await apiClient.getPrivilegeList(phoneNo: phoneNumber);
    return data;
  }

  @override
  Future<Resource> savePrivilege(
      {required String privilegeList,
      required String type,
      required String phoneNumber}) async {
    var data = await apiClient.addUserPrivilege(
        privilegeList: privilegeList, phoneNumber: phoneNumber, type: type);
    return data;
  }

  @override
  Future<Resource> getReminder() async{
    Utils().printMessage("Get Reminder");
    var data = await apiClient.getReminder();
    return data;
  }

  @override
  Future<Resource> setReminder({required Map<String, dynamic> reminders}) async{
    var data = await apiClient.setReminder(reminder: reminders);
    return data;
  }

// @override
// Future saveAndEditInvoice({required String jobId, required List<int> customerIds}) {
//   // TODO: implement saveAndEditInvoice
//   throw UnimplementedError();
// }
}
