import 'dart:convert';
import 'dart:developer';

import 'package:bizfns/core/utils/const.dart';
import 'package:bizfns/features/Admin/Material/model/material_unit_list_response.dart';
import 'package:flutter/material.dart';

import '../../../../../core/api_helper/api_helper.dart';
import '../../../../../core/common/Resource.dart';
import '../../../../../core/common/Status.dart';
import '../../../../../core/shared_pref/shared_key.dart';
import '../../../../../core/shared_pref/shared_pref.dart';
import '../../../../../core/utils/Utils.dart';
import '../../../../../core/utils/api_constants.dart';
import '../../../../auth/Login/model/login_otp_verification_model.dart';
import '../../../Material/model/materialCategoryListResponse.dart';

class AdminApiClientImpl {
  Future<Resource> getMaterialCategory({required body}) async {
    try {
      Utils().printMessage("GET_Material_Category_BODY==>$body");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      var response = await ApiHelper().apiCall(
          url: Urls.MATERIAL_CATEGORY_LIST,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + token.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            Map<String, dynamic> mapResponse =
                response.data as Map<String, dynamic>;
            MaterialCategoryListResponse materialCategoryListResponse =
                MaterialCategoryListResponse.fromJson(mapResponse);
            return Resource(
                status: STATUS.SUCCESS,
                data: materialCategoryListResponse,
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

  Future<Resource> getMaterialUnit({required body}) async {
    try {
      log("GET_Material__Unit_BODY==>${jsonEncode(body)}");
      log("Hitting Api : ${Urls.MATERIAL_UNIT_LIST}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      var response = await ApiHelper().apiCall(
          url: Urls.MATERIAL_UNIT_LIST,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + token.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            Map<String, dynamic> mapResponse =
                response.data as Map<String, dynamic>;
            MaterialUnitResponse materialUnitResponse =
                MaterialUnitResponse.fromJson(mapResponse);
            return Resource(
                status: STATUS.SUCCESS,
                data: materialUnitResponse,
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

  Future<Resource> addMaterial({required body}) async {
    try {
      Utils().printMessage("ADD_Material_BODY==>$body");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      var response = await ApiHelper().apiCall(
          url: Urls.ADD_MATERIAL,
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

  Future<Resource> getMaterialList({required body}) async {
    try {
      Utils().printMessage("GET_Material_LIST_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      var response = await ApiHelper().apiCall(
          url: Urls.MATERIAL_LIST,
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

  //------------------------GET-MATERIAL-DETAILS-DATA--------------------------//

  Future<Resource> getMaterialDetails(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.GET_MATERIAL_DETAILS,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("GET MATERIAL DETAILS data===>${response.data["data"]}");
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

  //-----------------------EDIT-MATERIAL-DETAILS-------------------------//
  // Future<Resource> editMaterialDetails({
  //   required String materialName,
  //   required String materialRateUnitId,
  //   required String materialId,
  //   required String categoryId,
  //   required String subCategoryId,
  //   required String materialRate,
  //   required String materialType,
  //   required String materialActiveStatus,
  // }) async {
  //   OtpVerificationData? loginData = await GlobalHandler.getLoginData();
  //   List<String> deviceDetails = await Utils.getDeviceDetails();
  //   String? userId = await GlobalHandler.getUserId();
  //   // var body = {
  //   //   "deviceId": deviceDetails[0],
  //   //   "deviceType": deviceDetails[1],
  //   //   "appVersion": deviceDetails[2],
  //   //   "userId": userId,
  //   //   "tenantId": loginData!.tenantId,
  //   //   "serviceId": serviceId,
  //   //   "serviceName": serviceName,
  //   //   "rate": serviceRate,
  //   //   "rateUnit": rateUnit,
  //   //   "status": serviceActiveStatus
  //   // };
  //   var body = {
  //   "tenantId": loginData!.tenantId,
  //   "userId": userId,
  //   "materialId": materialId,
  //   "categoryId": categoryId,
  //   "subcategoryId": subCategoryId,
  //   "materialName": materialName,
  //   "materialRate": materialRate,
  //   "materialType": materialType,
  //   "materialRateUnitId": materialRateUnitId
  // };
  //   log("editbody : ${jsonEncode(body)}");
  //   Resource data = await apiClient.editServicefDetails(
  //       body: body, authToken: loginData.token ?? "");
  //   if (data.status == STATUS.SUCCESS) {
  //     Utils().printMessage("Service Edited successfully");
  //   } else {
  //     Utils().printMessage("Service Edit failed");
  //   }
  //   return data;
  // }

  Future<Resource> editMaterialDetails(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING edit details body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.EDIT_MATERIAL_DETAILS,
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

  //----------------------DELETE MATERIAL---------------------//
  Future<Resource> deleteMaterial(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING DELETE details body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.DELETE_MATERIAL,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("GET DELETE DETAILS data===>${response.data["data"]}");
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

  //-----------------ACTIVE-INACTIVE MATERIAL------------------//
  Future<Resource> activeInactiveMaterial(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING active/inactive body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.ACTIVE_INACTIVE_MATERIAL,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("ACTIVE/INACTIVE DETAILS data===>${response.data["data"]}");
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

  //-------------------------SAVE-MATERIAL-UNIT--------------------------//
  Future<Resource> saveMaterialUnit(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING saveMaterial body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.SAVE_MATERIAL_UNIT,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("SAVE MATERIAL DETAILS data===>${response.data["data"]}");
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

  Future<Resource> getStaffList({required body}) async {
    try {
      Utils().printMessage("GET_Staff_LIST_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      var response = await ApiHelper().apiCall(
          url: Urls.FETCH_STAFFS,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + token.toString()});
      log("get staff success : ${response.data["success"]}");
      log("FETCHING STAFFS : ${response.data["data"]}");
      try {
        // Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("get staff response : ${response.data["data"]}");
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

  Future<Resource> getCustomerList({required body}) async {
    try {
      Utils().printMessage("GET_Customer_List_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      var response = await ApiHelper().apiCall(
          url: Urls.FETCH_CUSTOMERS,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + token.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          if (response.data["success"] == true) {
            log("CUSTOMER LIST : ${jsonEncode(response.data["data"])}");
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

  //----------------------GET-CUSTOMER-DETAILS-----------------------//
  @override
  Future<Resource> getCustomerDetails(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.GET_CUSTOMER_DETAILS,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("GET CUSTOMER DETAILS data===>${response.data["data"]}");
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

  Future<Resource> getCustomerServiceEntityList({required body}) async {
    try {
      log("GET_Customer_SERVICE_List_BODY==>${jsonEncode(body)}");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      var response = await ApiHelper().apiCall(
          url: Urls.CUSTOMER_SERVICE_ENTITY,
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

  //-----------------------DELETE-CUSTOMER-------------------------//
  Future<Resource> deleteCustomer(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING edit details body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.DELETE_CUSTOMER,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("DELETE CUSTOMER DETAILS data===>${response.data["data"]}");
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

  //-----------------------UPDATE-CUSTOMER------------------------//
  Future<Resource> editCustomerDetails(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING edit details body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.UPDATE_CUSTOMER,
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

  //----------------ACTIVE/INACTIVE CUSTOMER---------------//
  Future<Resource> activeInactiveCustomer(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING active/inactive body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.ACTIVE_INACTIVE_CUSTOMER,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("ACTIVE/INACTIVE DETAILS data===>${response.data["data"]}");
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

  Future<Resource> getServiceRateUnitList({required body}) async {
    try {
      Utils().printMessage("GET_SERVICE_RATE_UNIT_LIST_BODY==>$body");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      var response = await ApiHelper().apiCall(
          url: Urls.GET_SERVICE_RATE_UNIT_LIST,
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

  Future<Resource> addService({required body}) async {
    try {
      Utils().printMessage("ADD_Service_BODY==>$body");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      var response = await ApiHelper().apiCall(
          url: Urls.ADD_SERVICE,
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

  Future<Resource> getServiceList({required body}) async {
    try {
      Utils().printMessage("GET_SERVICE_LIST_BODY==>$body");
      String? token = await GlobalHandler.getToken();
      if (token == null) {
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        token = data!.token ?? "";
        await GlobalHandler.setToken(token);
      }
      Utils().printMessage(token.toString());
      var response = await ApiHelper().apiCall(
          url: Urls.GET_SERVICE_LIST,
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

  //----------------------GET SERVICE DETAILS-----------------------//

  Future<Resource> getServiceDetails(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.GET_SERVICE_DETAILS,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print(
              "GET SERVICE DETAILS data===>${jsonEncode(response.data["data"])}");
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

  //-----------------------EDIT-SERVICE-DETAILS----------------------------//

  Future<Resource> editServiceDetails(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING edit details body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.UPDATE_SERVICE_DETAILS,
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

  //------------------------DELETE-SERVICE----------------------------//
  Future<Resource> deleteService(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING edit details body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.DELETE_SERVICE,
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

  //---------------------ADD-MATERIAL-SUBCATEGORY---------------------//
  Future<Resource> addMaterialSubCategory(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING addMaterialSubCategory body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.ADD_MATERIAL_SUB_CATEGORY,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          print("ADD MATERIAL SUBCATEGORY data===>${response.data["data"]}");
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

  //----------------ADD-MATERIAL-CATEGORY-----------------//
  Future<Resource> addMaterialCategory(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING addMaterialCategory body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.ADD_MATERIAL_CATEGORY,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          log("ADD MATERIAL CATEGORY data===>${response.data["data"]}");
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

  //--------------DELETE-MATERIAL-CATEGORY-SUBCATEGORY------------//
  Future<Resource> deleteCategoryAndSubcategory(
      {required body, required String authToken}) async {
    log("GETTING AUTH TOKEN : ${authToken}");
    log("GETTING deleteCategoryAndSubcategory body : $body");

    try {
      var response = await ApiHelper().apiCall(
          url: Urls.DELETE_CATEGORY_SUBCATEGORY,
          body: body,
          requestType: RequestType.POST,
          header: {"Authorization": "Bearer " + authToken.toString()});
      try {
        Utils().printMessage(response.data.toString());
        if (response != null && response.status == STATUS.SUCCESS) {
          log("DELETE CATEGORY SUBCATEGORY data===>${response.data["data"]}");
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
}
