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
import '../model/get_material_details_model.dart';

class MaterialRepoImpl {
  AdminApiClientImpl apiClient;
  MaterialRepoImpl({required this.apiClient});

  @override
  Future<Resource> getMaterial({required body}) async {
    Utils().printMessage("here im");

    Resource data = await apiClient.getMaterialList(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Get Material successfully");
    } else {
      Utils().printMessage("Get Material failed");
    }
    return data;
  }

  @override
  Future<Resource> getMaterialCategory({required body}) async {
    Utils().printMessage("here im");

    Resource data = await apiClient.getMaterialCategory(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Get Material successfully");
    } else {
      Utils().printMessage("Get Material failed");
    }
    return data;
  }

  @override
  Future<Resource> getMaterialUnit({required body}) async {
    Utils().printMessage("here im fetching unit list");

    Resource data = await apiClient.getMaterialUnit(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Get Material Unit successfully");
    } else {
      Utils().printMessage("Get Material Unit failed");
    }
    return data;
  }

  @override
  Future<Resource> addMaterial({required body}) async {
    Utils().printMessage("here im");

    Resource data = await apiClient.addMaterial(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Customer added successfully");
    } else {
      Utils().printMessage("Customer added failed");
    }
    return data;
  }

  //--------------------MATERIAL DETAILS--------------------//
  @override
  Future<Resource> getMaterialDetails({required String materialId}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "materialId": materialId
    };
    Resource data = await apiClient.getMaterialDetails(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      if (data.data != null) {
        try {
          var list = data.data!;
          MaterialDetailsData materialDetailsData =
              MaterialDetailsData.fromJson(data.data);
          data.data = materialDetailsData;
        } catch (e) {
          data.status = STATUS.ERROR;
          data.data = null;
          data.message = SomethingWentWrong;
        }
      }
    } else {
      Utils().printMessage("Material Details fetch failed");
    }
    return data;
  }

  //------------------------MATERIAL-EDIT-------------------------//
  // Future<Resource> ediMaterialDetails({
  //   required String serviceName,
  //   required String rateUnit,
  //   required String serviceId,
  //   required String serviceRate,
  //   required String serviceActiveStatus,
  // }) async {
  //   OtpVerificationData? loginData = await GlobalHandler.getLoginData();
  //   List<String> deviceDetails = await Utils.getDeviceDetails();
  //   String? userId = await GlobalHandler.getUserId();
  //   var body = {
  //     "deviceId": deviceDetails[0],
  //     "deviceType": deviceDetails[1],
  //     "appVersion": deviceDetails[2],
  //     "userId": userId,
  //     "tenantId": loginData!.tenantId,
  //     "serviceId": serviceId,
  //     "serviceName": serviceName,
  //     "rate": serviceRate,
  //     "rateUnit": rateUnit,
  //     "status": serviceActiveStatus
  //   };
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

  Future<Resource> editMaterialDetails({
    required String materialName,
    required String materialRateUnitId,
    required String materialId,
    required String categoryId,
    required String subCategoryId,
    required String materialRate,
    required String materialType,
    required String materialActiveStatus,
  }) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "materialId": materialId,
      "categoryId": categoryId,
      "subcategoryId": subCategoryId,
      "materialName": materialName,
      "materialRate": materialRate,
      "materialType": materialType,
      "materialRateUnitId": materialRateUnitId
    };
    log("editbody : ${jsonEncode(body)}");
    Resource data = await apiClient.editMaterialDetails(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Service Edited successfully");
    } else {
      Utils().printMessage("Service Edit failed");
    }
    return data;
  }

  Future<Resource> deleteMaterial({required String materialId}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "materialId": materialId
    };

    log("editbody : ${jsonEncode(body)}");
    Resource data = await apiClient.deleteMaterial(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Material Deleted successfully");
    } else {
      Utils().printMessage("Material Delete failed");
    }
    return data;
  }

  //----------ACTIVE_INACTIVE------------//
  Future<Resource> activeInactiveMaterial(
      {required String materialID, required String activeStatus}) async {
    // AdminApiClientImpl adminApiClientImpl = new AdminApiClientImpl();
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "materialId": materialID,
      "status": activeStatus
    };
    Resource data = await apiClient.activeInactiveMaterial(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Customer Edited successfully");
    } else {
      Utils().printMessage("Customer Edit failed");
    }
    return data;
  }

  //---------------------SAVE-MATERIAL-UNIT---------------------//
  Future<Resource> saveMaterialUnit({required String unitName}) async {
    // AdminApiClientImpl adminApiClientImpl = new AdminApiClientImpl();
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    // var body = {
    //   "tenantId": loginData!.tenantId,
    //   "userId": userId,
    //   "materialId": materialID,
    //   "status": activeStatus
    // };\
    var body = {"tenantId": loginData!.tenantId, "unit_name": unitName};
    log("SAVE UNIT BODY : ${jsonEncode(body)}");
    Resource data = await apiClient.saveMaterialUnit(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Unit Added successfully");
    } else {
      Utils().printMessage("Unit Adding failed");
    }
    return data;
  }

  //-----------------ADD-MATERIAL-SUBCATEGORY-----------------//
  Future<Resource> addMaterialSubCategory(
      {required String subCategoryName, required String categoryId}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "categoryId": categoryId,
      "subcategoryName": subCategoryName
    };
    log("ADD MATERIAL SUBCATEGORY BODY : ${jsonEncode(body)}");
    Resource data = await apiClient.addMaterialSubCategory(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Material Subcategory Added successfully");
    } else {
      Utils().printMessage("Material Subcategory Added Failed");
    }
    return data;
  }

  //----------------------ADD-MATERIAL-CATEGORY--------------------//
  Future<Resource> addMaterialCategory({required String categoryName}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "categoryName": categoryName,
      "parentCategoryId": 0
    };
    log("ADD MATERIAL CATEGORY BODY : ${jsonEncode(body)}");
    Resource data = await apiClient.addMaterialCategory(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Material Category Added successfully");
    } else {
      Utils().printMessage("Material Category Added Failed");
    }
    return data;
  }

  //-----------------DELETE-CATEGORY--------------------//
  Future<Resource> deleteCategoryAndSubcategory(
      {required String categoryId, required String subcategoryId}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "categoryId": categoryId,
      "subcategoryId": subcategoryId
    };
    log("DELETE CATEGORY-SUBCATEGORY BODY : ${jsonEncode(body)}");
    Resource data = await apiClient.deleteCategoryAndSubcategory(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Material Category Added successfully");
    } else {
      Utils().printMessage("Material Category Added Failed");
    }
    return data;
  }
}
