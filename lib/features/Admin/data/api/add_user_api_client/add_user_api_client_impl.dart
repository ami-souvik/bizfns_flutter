import 'dart:convert';
import 'dart:developer';

import 'package:bizfns/core/utils/const.dart';
import 'package:flutter/material.dart';

import '../../../../../core/api_helper/api_helper.dart';
import '../../../../../core/common/Resource.dart';
import '../../../../../core/common/Status.dart';
import '../../../../../core/shared_pref/shared_key.dart';
import '../../../../../core/shared_pref/shared_pref.dart';
import '../../../../../core/utils/Utils.dart';
import '../../../../../core/utils/api_constants.dart';
import '../../../../Settings/model/get_job_number_by_date_model.dart';
import '../../../../Settings/model/time_sheet_by_billno_staff_model.dart';
import '../../../../auth/Login/model/login_otp_verification_model.dart';

class AddUserApiClientImpl {
  @override
  Future<Resource> addCustomer(
      {required firstName,
      required lastName,
      required email,
      required phone,
      required serviceEntity,
      required String custAddress,
      required String custCompanyName}) async {
    try {
      Utils().printMessage("here im");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      Utils().printMessage("here im");
      var body = {
        "deviceId": deviceDetails[0],
        "deviceType": deviceDetails[1],
        "appVersion": deviceDetails[2],
        "tenantId": loginData!.tenantId,
        "custFName": firstName,
        "custLName": lastName,
        "custEmail": email,
        "custPhNo": phone,
        "companyId": loginData!.cOMPANYID.toString(),
        "custAddress": custAddress,
        "custCompanyName": custCompanyName,
        "questionData": serviceEntity['data'],
      };

      Utils().printMessage("ADD_CUSTOMER_BODY==>$body");
      String value = jsonEncode(body);
      print(value);
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
          url: Urls.ADD_CUSTOMER,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + token.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            return Resource(
                status: STATUS.SUCCESS,
                data: response.data["data"],
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  @override
  Future<Resource> getStaffData({required body}) async {
    try {
      Utils().printMessage("GET_STAFF_DATA==>$body");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here ${Urls.GET_PRE_STAFF_CREATION_DATA}");
      var response = await ApiHelper().apiCall(
          url: Urls.GET_PRE_STAFF_CREATION_DATA,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + token.toString()});
      try {
        Utils().printMessage(response.data.toString());
        log("GET_PRE_STAFF_CREATION_DATA : ${jsonEncode(response.data)}");
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            return Resource(
                status: STATUS.SUCCESS,
                data: response.data["data"],
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  @override
  Future<Resource> addStaff({required body}) async {
    try {
      Utils().printMessage("here im");
      OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      List<String> deviceDetails = await Utils.getDeviceDetails();
      String? userId = await GlobalHandler.getUserId();
      Utils().printMessage("here im");

      Utils().printMessage("ADD_Staff_BODY==>$body");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
          url: Urls.ADD_STAFF,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + token.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            return Resource(
                status: STATUS.SUCCESS,
                data: response.data["data"],
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //---------------------staffUserLogin-------------------//
  @override
  Future<Resource> staffUserLogin({required body}) async {
    try {
      Utils().printMessage("here im");
      // OtpVerificationData? loginData = await GlobalHandler.getLoginData();
      // List<String> deviceDetails = await Utils.getDeviceDetails();
      // String? userId = await GlobalHandler.getUserId();
      // Utils().printMessage("here im");

      Utils().printMessage("staffUserLoginBody==>$body");
      // String? token = await GlobalHandler.getToken();
      // if(token ==null){
      //   OtpVerificationData? data = await GlobalHandler.getLoginData();
      //   token = data!.token??"";
      //   await GlobalHandler.setToken(token);
      // }
      // Utils().printMessage(token.toString());
      // Utils().printMessage("here imddwfd");
      var response = await ApiHelper().apiCall(
        url: Urls.STAFF_USER_LOGIN, body: body, requestType: RequestType.POST,
        // header: {"Authorization":"Bearer "+token.toString()}
      );
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("succes staff login data===>${response.data["data"]}");
          if (response.data["success"] == true) {
            return Resource(
                status: STATUS.SUCCESS,
                data: response.data["data"],
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //------------------------get-job-number-by-date------------------------//
  @override
  Future<Resource> getJobNumberByDate(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.GET_JOB_NUMBER_BY_DATE,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("GET JOB NUMBER BY DATE data===>${response.data["data"]}");
          if (response.data["success"] == true) {
            Map<String, dynamic> mapResponse =
                response.data as Map<String, dynamic>;
            GetJobNumberByDateModel getJobNumberByDateModel =
                GetJobNumberByDateModel.fromJson(mapResponse);

            return Resource(
                status: STATUS.SUCCESS,
                data: getJobNumberByDateModel,
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //------------------------get staff details-----------------------------//
  @override
  Future<Resource> getstaffDetails(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.GET_STAFF_DETAILS,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("GET STAFF DETAILS data===>${response.data["data"]}");
          if (response.data["success"] == true) {
            return Resource(
                status: STATUS.SUCCESS,
                data: response.data["data"],
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //--------------------------EDIT STAFF DETAILS-----------------------------//

  Future<Resource> editStaffDetails(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING edit details body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.EDIT_STAFF_DETAILS,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("GET EDIT DETAILS data===>${response.data["data"]}");
          if (response.data["success"] == true) {
            return Resource(
                status: STATUS.SUCCESS,
                data: response.data["data"],
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //--------------------------DELETE-STAFF-------------------------//
  Future<Resource> deleteStaff(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING edit details body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.DELETE_STAFF,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("GET EDIT DETAILS data===>${response.data["data"]}");
          if (response.data["success"] == true) {
            return Resource(
                status: STATUS.SUCCESS,
                data: response.data["data"],
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //------------------------SAVE-TIME-SHEET------------------------//
  Future<Resource> saveTimeSheet(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING saveTimeSheet body : ${jsonEncode(body)}");
    try {
      var response = await ApiHelper().apiCall(
          url: Urls.SAVE_TIME_SHEET,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          log("SAVE_TIME_SHEET_RESPONSE : ${response.data["data"]}");
          if (response.data["success"] == true) {
            return Resource(
                status: STATUS.SUCCESS,
                data: response.data["data"],
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  //------------------------TIME-SHEET-BY-BILL-NO--------------------------//
  @override
  Future<Resource> timeSheetByBillNo(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.TIME_SHEET_BY_BILLNO_STAFF,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("GET timeSheetByBillNo data===>${response.data["data"]}");
          if (response.data["success"] == true) {
            Map<String, dynamic> mapResponse =
                response.data as Map<String, dynamic>;
            TimeSheetByBillNoAndStaffModel getTimeSheetModel =
                TimeSheetByBillNoAndStaffModel.fromJson(mapResponse);

            return Resource(
                status: STATUS.SUCCESS,
                data: getTimeSheetModel,
                message: response.data["message"]);
          } else {
            return Resource.error(message: response.data["message"].toString());
          }
        } else {
          if (response.data.toString() == "403") {
            return Resource.error(message: TOKEN_EXPIRED);
          } else {
            return Resource.error(message: response.message);
          }
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: SomethingWentWrong);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }
}
