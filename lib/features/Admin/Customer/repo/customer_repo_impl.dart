import 'dart:convert';
import 'dart:developer';

import 'package:bizfns/features/Admin/Customer/model/customer_service_entity_response_model.dart';
import 'package:bizfns/features/Admin/data/api/admin_api_client/admin_api_client_impl.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common/Resource.dart';
import '../../../../../core/common/Status.dart';
import '../../../../../core/utils/Utils.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/const.dart';
import '../../../auth/Login/model/login_otp_verification_model.dart';
import '../model/customerListResponseModel.dart';
import '../model/get_customer_details_model.dart';
import 'customer_repo.dart';

class CustomerRepoImpl extends CustomerRepo {
  CustomerRepoImpl({required super.apiClient});

  @override
  Future<Resource> addCustomer(
      {required String firstName,
      required String lastName,
      required String email,
      required String phone,
      required serviceEntity,
      required String custAddress,
      required String custCompanyName}) async {
    Utils().printMessage("here im");

    Resource data = await apiClient.addCustomer(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      serviceEntity: serviceEntity,
      custAddress: custAddress,
      custCompanyName: custCompanyName,
    );
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Customer added successfully");
    } else {
      Utils().printMessage("Customer added failed");
    }
    return data;
  }

  @override
  Future<Resource> getCustomerList(BuildContext context) async {
    Utils().printMessage("here im");
    AdminApiClientImpl adminApiClientImpl = new AdminApiClientImpl();
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
    Resource data = await adminApiClientImpl.getCustomerList(body: body);
    if (data.status == STATUS.SUCCESS) {
      var list = data.data!;
      List<CustomerListData> customerList = List<CustomerListData>.from(
          list.map((model) => CustomerListData.fromJson(model)));
      data.data = customerList;
      // Utils().printMessage("Customer added successfully");
    } else {
      Utils().printMessage(data.message ?? "No data found");
    }
    return data;
  }

  @override
  Future<Resource> getCustomerServiceEntity({required customerID}) async {
    Utils().printMessage("here im");
    AdminApiClientImpl adminApiClientImpl = new AdminApiClientImpl();
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "customer_id": customerID
    };
    Resource data =
        await adminApiClientImpl.getCustomerServiceEntityList(body: body);
    if (data.status == STATUS.SUCCESS) {
      var list = data.data!;
      print(list);
      List<CustomerServiceEntityData> customerServiceEntity =
          List<CustomerServiceEntityData>.from(
              list.map((model) => CustomerServiceEntityData.fromJson(model)));
      data.data = customerServiceEntity;
      // Utils().printMessage("Customer added successfully");
    } else {
      Utils().printMessage(data.message ?? "No data found");
    }
    return data;
  }

  @override
  Future<Resource> deleteCustomer({required customerId}) async {
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    AdminApiClientImpl adminApiClientImpl = new AdminApiClientImpl();

    var body = {
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "customerId": customerId
    };
    log("deletetbody : ${jsonEncode(body)}");
    Resource data = await adminApiClientImpl.deleteCustomer(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Customer Deleted successfully");
    } else {
      Utils().printMessage("Customer Deletion failed");
    }
    return data;
  }

  @override
  Future<Resource> getCustomerDetails({required String customerId}) async {
    AdminApiClientImpl adminApiClientImpl = new AdminApiClientImpl();
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "customerId": customerId
    };
    Resource data = await adminApiClientImpl.getCustomerDetails(
        body: body, authToken: loginData.token ?? "");

    if (data.status == STATUS.SUCCESS) {
      if (data.data != null) {
        try {
          var list = data.data!;
          CustomerDetailsData customerDetailsData =
              CustomerDetailsData.fromJson(data.data);
          data.data = customerDetailsData;
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

  @override
  Future<Resource> updateCustomer(
      {required String customerId,
      required String firstName,
      required String lastName,
      required String companyName,
      required String address,
      required String email,
      required String customerPhone}) async {
    AdminApiClientImpl adminApiClientImpl = new AdminApiClientImpl();
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "customerId": customerId,
      "firstName": firstName,
      "lastName": lastName,
      "companyName": companyName,
      "address": address,
      "email": email,
      "customerPhone": customerPhone
    };
    Resource data = await adminApiClientImpl.editCustomerDetails(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Customer Edited successfully");
    } else {
      Utils().printMessage("Customer Edit failed");
    }
    return data;
  }

  @override
  Future<Resource> activeInactiveCustomer(
      {required String customerId, required String activeStatus}) async {
    AdminApiClientImpl adminApiClientImpl = new AdminApiClientImpl();
    OtpVerificationData? loginData = await GlobalHandler.getLoginData();
    List<String> deviceDetails = await Utils.getDeviceDetails();
    String? userId = await GlobalHandler.getUserId();
    var body = {
      "tenantId": loginData!.tenantId,
      "userId": userId,
      "customerId": customerId,
      "status": activeStatus
    };
    Resource data = await adminApiClientImpl.activeInactiveCustomer(
        body: body, authToken: loginData.token ?? "");
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("Customer Edited successfully");
    } else {
      Utils().printMessage("Customer Edit failed");
    }
    return data;
  }
}
