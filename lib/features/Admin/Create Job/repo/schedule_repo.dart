import 'package:bizfns/features/Admin/Create%20Job/api-client/schedule_api_client_implementation.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/common/Resource.dart';

abstract class ScheduleRepo {
  final ScheduleAPIClientImpl apiClient;

  ScheduleRepo({required this.apiClient});

  Future<Resource> getSchedule({required String date});

  Future<Resource> addSchedule({required Map<String, dynamic> scheduleData});

  Future<Resource> editSchedule({required Map<String, dynamic> scheduleData});

  Future<Resource> reSchedule(
      {required String jobID,
      required String startTime,
      required String endTime});

  Future<Resource> deleteSchedule({required Map<String, dynamic> scheduleData});

  Future<Resource> getServiceEntityQuestion();

  Future<Resource> getServiceEntityDetails(
      {String? customerID, String? serviceEntityID});

  Future<Resource> saveImage(
      {required List<XFile> image, required String tempJobID});

  Future<Resource> generateInvoice({required String jobID});

  Future<Resource> getReccurrDateList();

  Future<Resource> getStaffValidation({required List recurDateList,required BuildContext context});

  Future<Resource> addServiceEntity(String customerID);

  Future<Resource> updateServiceEntity({required String customerID,
    required String serviceEntityId,});

  Future<Resource> deleteServiceEntity({required String customerID,
    required String serviceEntityId,});

  Future<Resource> getJobStatus({required Map<String, dynamic> statusData});

  Future<Resource> saveJobStatus(
      {required Map<String, dynamic> saveJobStatusData});

  Future getCustomerServiceHistory(
      {required Map<String, dynamic> customerData});

  Future getTaxTable();
 
  Future<Resource> addTaxTable({required String taxMasterName, required String taxMasterRate});

  Future<Resource> updateTaxTable({required Map<String, dynamic> taxUpdates});

  Future<Resource> deleteTaxTable({required String taxTypeId});

  Future getEditInvoice({required String jobId, required List<int> customerIds});

  Future saveEditInvoice({required Map<String, dynamic> saveEditJson});

  Future updateInvoice({required Map<String, dynamic> updateJson});

  Future<Resource> getInvoicedCustomerData({required String jobId});

  Future getPdfByCustomer({required String customerId, required String jobId});

  Future getWorkingHours();

  Future<Resource> addWorkingHours({required String start, required String end});

  Future getTimeInterval();

  Future<Resource> addTimeInterval({required String hour, required String minute});


  Future getMaxJobTask();

  Future<Resource> addMaxJobTask({required String maxJobTask});


  Future<Resource> getUserType();

  Future<Resource> getUserPrivilege({required String phoneNumber});

  Future<Resource> savePrivilege({required String privilegeList, required String type, required String phoneNumber});

  Future<Resource> getReminder();

  Future<Resource> setReminder({required Map<String,dynamic> reminders});
}
