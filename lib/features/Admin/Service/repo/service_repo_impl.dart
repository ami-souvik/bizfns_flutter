import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../../core/common/Resource.dart';
import '../../../../../core/common/Status.dart';
import '../../../../../core/utils/Utils.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/const.dart';
import '../../../auth/Login/model/login_otp_verification_model.dart';
import '../../data/api/admin_api_client/admin_api_client_impl.dart';
import '../../model/get_service_details_model.dart';

class ServiceRepoImpl {
  AdminApiClientImpl apiClient;
  ServiceRepoImpl({required this.apiClient});

  @override
  Future<Resource> getServiceRateUnit({required body}) async {
    Resource data = await apiClient.getServiceRateUnitList(body: body);
    if (data.status == STATUS.SUCCESS) {
    } else {
      Utils().printMessage(data.message ?? "");
    }
    return data;
  }

  @override
  Future<Resource> addService({required body}) async {
    Resource data = await apiClient.addService(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Service added successfully");
    } else {
      Utils().printMessage("Service added failed");
    }
    return data;
  }

  @override
  Future<Resource> getServiceList({required body}) async {
    Resource data = await apiClient.getServiceList(body: body);
    if (data.status == STATUS.SUCCESS) {
    } else {
      Utils().printMessage(data.message ?? "");
    }
    return data;
  }

  @override
  Future<Resource> getServiceDetails({required String serviceId}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    // var body = {
    //   "tenantId": loginData!.tenantId,
    //   "userId": userId,
    //   "staffPhoneNumber": staffPhoneNo
    // };
    var body = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "userId": userId,
      "tenantId": loginData!.tenantId,
      "serviceId": serviceId
    };
    Resource data = await apiClient.getServiceDetails(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      if (data.data != null) {
        try {
          var list = data.data!;
          ServiceDetailsData serviceDetailsData =
              ServiceDetailsData.fromJson(data.data);
          data.data = serviceDetailsData;
        } catch (e) {
          data.status = STATUS.ERROR;
          data.data = null;
          data.message = SomethingWentWrong;
        }
      }
    } else {
      Utils().printMessage("Staff Details fetch failed");
    }
    return data;
  }

  Future<Resource> ediServiceDetails({
    required String serviceName,
    required String rateUnit,
    required String serviceId,
    required String serviceRate,
    required String serviceActiveStatus,
  }) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "userId": userId,
      "tenantId": loginData!.tenantId,
      "serviceId": serviceId,
      "serviceName": serviceName,
      "rate": serviceRate,
      "rateUnit": rateUnit,
      "status": serviceActiveStatus
    };
    log("editbody : ${jsonEncode(body)}");
    Resource data = await apiClient.editServiceDetails(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Service Edited successfully");
    } else {
      Utils().printMessage("Service Edit failed");
    }
    return data;
  }

  //---------------------------DELETE-SERVICE-----------------------------//
  Future<Resource> deleteService({
    required String serviceId,
  }) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    // var body = {
    //   "tenantId": loginData!.tenantId,
    //   "userId": userId,
    //   "staffPhoneNumber": staffPhoneNumber,
    //   "staffFirstName": staffFirstName,
    //   "staffLastName": staffLastName,
    //   "staffEmail": staffEmail,
    //   "staffType": staffType,
    //   "companyId": companyId,
    //   "chargeRate": chargeRate,
    //   "chargeFrequency": chargeFrequency,
    //   "StaffActiveStatus": staffActiveStatus
    // };
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "serviceId": serviceId
    };
    log("deletetbody : ${jsonEncode(body)}");
    Resource data = await apiClient.deleteService(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Service Deleted successfully");
    } else {
      Utils().printMessage("Service Deletion failed");
    }
    return data;
  }
}
