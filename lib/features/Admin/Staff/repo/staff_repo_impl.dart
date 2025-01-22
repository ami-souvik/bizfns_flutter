import 'dart:convert';
import 'dart:developer';

import 'package:bizfns/core/utils/const.dart';
import 'package:bizfns/features/Admin/data/api/add_user_api_client/add_user_api_client_impl.dart';
import 'package:bizfns/features/Admin/model/staffListResponseModel.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common/Resource.dart';
import '../../../../../core/common/Status.dart';
import '../../../../../core/utils/Utils.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../Settings/model/get_job_number_by_date_model.dart';
import '../../../auth/Login/model/login_otp_verification_model.dart';
import '../../data/api/admin_api_client/admin_api_client_impl.dart';
import '../../model/get_staff_details_model.dart';
import '../../model/preStaffCreationData.dart';

class StaffRepoImpl {
  final AddUserApiClientImpl apiClient;
  StaffRepoImpl({required this.apiClient});
  @override
  Future<Resource> getStaffData({required body}) async {
    Resource data = await apiClient.getStaffData(body: body);
    if (data.status == STATUS.SUCCESS) {
      if (data.data != null) {
        try {
          StaffCreationData staffCreationData =
              StaffCreationData.fromJson(data.data!);
          data.data = staffCreationData;
        } catch (e) {
          data.status = STATUS.ERROR;
          data.data = null;
          data.message = SomethingWentWrong;
        }
      }
    } else {
      Utils().printMessage("Get Staff Data Failed");
    }
    return data;
  }

  @override
  Future<Resource> addStaff({required body}) async {
    Resource data = await apiClient.addStaff(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Staff added successfully");
    } else {
      Utils().printMessage("Staff added failed");
    }
    return data;
  }

  @override
  Future<Resource> getStaffList(BuildContext context) async {
    AdminApiClientImpl adminApiClient = new AdminApiClientImpl();
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "tenantId": loginData!.tenantId,
      "userId": userId
    };
    Resource data = await adminApiClient.getStaffList(body: body);
    if (data.status == STATUS.SUCCESS) {
      print("Data.status : ${data.status}");
      if (data.data != null) {
        print("Continue1");
        try {
          print("Continue2");
          var list = data.data!;
          print("Continue3");
          List<StaffListData> staffCreationData = List<StaffListData>.from(
              list.map((model) => StaffListData.fromJson(model)));

          print("Continue4");
          data.data = staffCreationData;
          print("Continue");
        } catch (e, stackTrace) {
          print('Error: $e StackTrace $stackTrace');
          data.status = STATUS.ERROR;
          data.data = null;
          data.message = SomethingWentWrong;
        }
      }
    } else {
      Utils().printMessage("Customer added failed");
    }
    return data;
  }

  @override
  Future<Resource> staffUserLogin({required body}) async {
    Resource data = await apiClient.staffUserLogin(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Staff Login successfully");
    } else {
      Utils().printMessage("Staff Login failed");
    }
    return data;
  }
  // @override
  // Future<Resource> staffUserLogin(BuildContext context) async{
  //   AdminApiClientImpl adminApiClient = new AdminApiClientImpl();
  //   // OtpVerificationData? loginData = await GlobalHandler.getLoginData();
  //   // List<String> deviceDetails = await Utils.getDeviceDetails();
  //   // String? userId = await GlobalHandler.getUserId();
  //   var body ={
  //     "deviceId":deviceDetails[0],
  //     "deviceType":deviceDetails[1],
  //     "appVersion":deviceDetails[2],
  //     "tenantId":loginData!.tenantId,
  //     "userId":userId
  //   };
  //   Resource data = await adminApiClient.(body: body);
  //   if(data.status == STATUS.SUCCESS){
  //     if(data.data!= null){
  //       try{
  //         var list = data.data!;
  //         List<StaffListData> staffCreationData = List<StaffListData>.from(list.map((model)=> StaffListData.fromJson(model)));
  //         data.data = staffCreationData;
  //       }catch(e){
  //         data.status = STATUS.ERROR;
  //         data.data = null;
  //         data.message = SomethingWentWrong;
  //       }
  //     }
  //   }else{
  //     Utils().printMessage("Customer added failed");
  //   }
  //   return data;
  // }

  //-------------------this is for normal getStaffDetails-----------------//
  @override
  Future<Resource> getstaffDetails({required String staffPhoneNo}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "staffPhoneNumber": staffPhoneNo
    };
    Resource data = await apiClient.getstaffDetails(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      if (data.data != null) {
        try {
          var list = data.data!;
          StaffDetailsData staffDetailsData =
              StaffDetailsData.fromJson(data.data);
          data.data = staffDetailsData;
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

  //------------------get job number by Date-------------------//
  Future<Resource> getJobNumberByDate({required String date}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": loginData!.cOMPANYBACKUPPHONENUMBER,
      "date": date
    };
    Resource data = await apiClient.getJobNumberByDate(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Get Material successfully");
    } else {
      Utils().printMessage("Get Material failed");
    }
    return data;
  }

  //------------------this is for after staff login get staff details---------------//
  @override
  Future<Resource> getstaffDetailsForStaffLogin() async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": loginData!.cOMPANYBACKUPPHONENUMBER,
      "staffPhoneNumber": loginData!.sTAFFBACKUPPHONENUMBER
    };
    Resource data = await apiClient.getstaffDetails(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      if (data.data != null) {
        try {
          var list = data.data!;
          StaffDetailsData staffDetailsData =
              StaffDetailsData.fromJson(data.data);
          data.data = staffDetailsData;
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

  //------------------------SAVE-TIME-SHEET--------------------------//
  Future<Resource> saveTimeSheet({required Map<String, dynamic> body}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    Resource data = await apiClient.saveTimeSheet(
        body: body, authToken: loginData!.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Saved TimeSheet successfully");
    } else {
      Utils().printMessage("TimeSheet Saving Failed");
    }
    return data;
  }

  //---------------------TIME-SHEET-BY-BILLNO-ID--------------------//
  Future<Resource> timeSheetByBillNoId(
      {required String billNo, required String staffId}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    var body = {
      "TenantId": loginData!.tenantId,
      "billNo": billNo,
      "staffId": staffId
    };
    Resource data = await apiClient.timeSheetByBillNo(
        body: body, authToken: loginData!.token ?? "");

    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Fetched TimeSheet By BillNo id");
    } else {
      Utils().printMessage("TimeSheet fetching Failed");
    }
    return data;
  }
  //----------------------------------------------------------------//

  Future<Resource> editStaffDetails({
    required String staffPhoneNumber,
    required String staffFirstName,
    required String staffLastName,
    required String staffId,
    required String staffEmail,
    // required String staffMobile,
    required String staffType,
    required String companyId,
    required String chargeRate,
    required String chargeFrequency,
    required String staffActiveStatus,
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
      "staffPhoneNumber": staffPhoneNumber,
      "staffId": staffId,
      "staffFirstName": staffFirstName,
      "staffLastName": staffLastName,
      "staffEmail": staffEmail,
      "staffType": staffType,
      "companyId": companyId,
      "chargeRate": chargeRate,
      "chargeFrequency": chargeFrequency,
      "StaffActiveStatus": staffActiveStatus
    };
    log("editbody : ${jsonEncode(body)}");
    Resource data = await apiClient.editStaffDetails(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Staff Edited successfully");
    } else {
      Utils().printMessage("Staff Edit failed");
    }
    return data;
  }

  Future<Resource> deleteStaff({
    required String staffPhoneNumber,
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
      "staffPhoneNumber": staffPhoneNumber
    };
    log("deletetbody : ${jsonEncode(body)}");
    Resource data = await apiClient.deleteStaff(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Staff Deleted successfully");
    } else {
      Utils().printMessage("Staff Deletion failed");
    }
    return data;
  }
}
