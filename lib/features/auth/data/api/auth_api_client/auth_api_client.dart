import 'dart:convert';
import 'dart:developer';

import 'package:bizfns/core/api_helper/api_helper.dart';
import 'package:bizfns/features/auth/Signup/model/RegistrationSuccessModel.dart';
import 'package:bizfns/features/auth/Signup/model/signup_otp_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/connect.dart';

import '../../../../../core/common/Resource.dart';
import '../../../../../core/common/Status.dart';
import '../../../../../core/utils/Utils.dart';
import '../../../../../core/utils/api_constants.dart';
import '../../../../../core/utils/const.dart';
import '../../../Login/model/login_model.dart';
import '../../../Signup/model/pre_registration_data.dart';

class AuthApiClient extends GetConnect {
  Future<Resource> login({required body}) async {
    Utils().printMessage("LOGIN_BODY=>$body ");

    // final response = await post(Urls.LOGIN, json.encode(body));
    final response = await ApiHelper().apiCall(
        url: Urls.LOGIN,
        body: body,
        queryParameters: {},
        requestType: RequestType.POST);

    try {
      Utils().printMessage(response.data.toString());
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> responseMap = response.data;
          LoginModel model = LoginModel.fromJson(responseMap);
          return Resource(
              status: STATUS.SUCCESS, data: model.data, message: model.message);
        } else {
          Utils().printMessage(response.data["success"].toString());
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        return Resource.error(message: response.message);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: "Something went wrong!!");
    }
    // return Resource(status: status, data: data, message: message);
  }

  Future<Resource> verifyOtp({required body}) async {
    Utils().printMessage("VERIFY_OTP_BODY=>$body ");
    var response = await ApiHelper().apiCall(
        url: Urls.OTP_VERIFICATION,
        body: body,
        requestType: RequestType.POST,
        queryParameters: {});

    try {
      if (response != null && response.status == STATUS.SUCCESS) {
        Utils().printMessage(response.data.toString());
        if (response.data['success'] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response.data['data'],
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        return Resource.error(message: response.message);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: response.data["message"].toString());
    }
  }

  Future<Resource> PreSignupData() async {
    List<String> deviceDetails = await Utils.getDeviceDetails();
    var body = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2]
    };
    Utils().printMessage(body.toString());

    final response = await ApiHelper().apiCall(
        url: Urls.FETCH_PRE_REGISTER_DATA,
        body: body,
        queryParameters: {},
        requestType: RequestType.POST);
    // final response = await post(Urls.FETCH_PRE_REGISTER_DATA, json.encode(body));

    try {
      Utils().printMessage(response.data.toString());
      if (response.status == STATUS.SUCCESS &&
          response.data["success"] == true) {
        Map<String, dynamic> responseMap = response.data;
        PreRegistrationData model = PreRegistrationData.fromJson(responseMap);
        return Resource(
            status: STATUS.SUCCESS, data: model.data, message: model.message);
      } else {
        if (response.status == STATUS.SUCCESS) {
          Utils().printMessage(response.data["success"].toString());
          return Resource.error(message: response.data["message"].toString());
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: "Something went wrong!!");
    }
    // return Resource(status: status, data: data, message: message);
  }

  Future<Resource> SignupOtpSend(
      {required String user_id, required String email_id}) async {
    List<String> deviceDetails = await Utils.getDeviceDetails();
    var body = {
      "deviceId": deviceDetails[0],
      "deviceType": deviceDetails[1],
      "appVersion": deviceDetails[2],
      "userId": user_id,
      "emailId": email_id.isEmpty ? null : email_id,
    };
    Utils().printMessage(body.toString());

    final response = await ApiHelper().apiCall(
        url: Urls.REGISTRATION_OTP_SEND,
        body: body,
        queryParameters: {},
        requestType: RequestType.POST);
    // final response = await post(Urls.FETCH_PRE_REGISTER_DATA, json.encode(body));

    try {
      Utils().printMessage(response.data.toString());
      if (response.status == STATUS.SUCCESS &&
          response.data["success"] == true) {
        Map<String, dynamic> responseMap = response.data;
        SignupOtpModel model = SignupOtpModel.fromJson(responseMap);
        return Resource(
            status: STATUS.SUCCESS, data: model.data, message: model.message);
      } else {
        if (response.status == STATUS.SUCCESS) {
          Utils().printMessage(response.data["success"].toString());
          return Resource.error(message: response.data["message"].toString());
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: "Something went wrong!!");
    }
    // return Resource(status: status, data: data, message: message);
  }

  Future<Resource> verifySignUpOtp({required body}) async {
    Utils().printMessage("verifySignUpOtp_BODY=>$body ");
    var response = await ApiHelper().apiCall(
        url: Urls.VALIDATE_REGISTRATION_OTP,
        body: body,
        requestType: RequestType.POST);

    try {
      Utils().printMessage(response.data.toString());
      if (response.status == STATUS.SUCCESS &&
          response.data['success'] == true) {
        return Resource(
            status: STATUS.SUCCESS,
            data: response.data,
            message: response.data['message']);
      } else {
        if (response.status == STATUS.SUCCESS) {
          Utils().printMessage(response.data["success"].toString());
          return Resource.error(message: response.data["message"].toString());
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> signUp({required body}) async {
    Utils().printMessage("SIGNUP_BODY=>$body ");

    final response = await ApiHelper()
        .apiCall(url: Urls.SIGNUP, body: body, requestType: RequestType.POST);

    try {
      Utils().printMessage(response.data.toString());
      if (response != null && response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> responseMap = response.data;
          RegistrationSuccessModel model =
              RegistrationSuccessModel.fromJson(responseMap);
          return Resource(
              status: STATUS.SUCCESS,
              data: model.data.toString(),
              message: model.message);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        return Resource.error(message: response.message);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: "Something went wrong!!");
    }
    // return Resource(status: status, data: data, message: message);
  }

  Future<Resource> forgotPassword({required body}) async {
    Utils().printMessage("FORGOT_PASSWORD_BODY=>$body ");
    var response = await ApiHelper().apiCall(
        url: Urls.FORGOT_PASSWORD, body: body, requestType: RequestType.POST);

    try {
      if (response.status == STATUS.SUCCESS) {
        Utils().printMessage(response.data.toString());
        if (response.data['success'] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response.data['data'],
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        return Resource.error(message: response.message);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> verifyForgotPasswordOtp({required body}) async {
    Utils().printMessage("verifyForgotPassword_BODY=>$body ");
    var response = await ApiHelper().apiCall(
        url: Urls.VALIDATE_FORGOT_PASSWORD_OTP,
        body: body,
        requestType: RequestType.POST);

    try {
      Utils().printMessage(response.data.toString());
      if (response.status == STATUS.SUCCESS &&
          response.data['success'] == true) {
        return Resource(
            status: STATUS.SUCCESS,
            data: response.data,
            message: response.data['message']);
      } else {
        if (response.status == STATUS.SUCCESS) {
          Utils().printMessage(response.data["success"].toString());
          return Resource.error(message: response.data["message"].toString());
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> resetPassword({required body}) async {
    Utils().printMessage("resetPassword_BODY=>$body ");
    var response = await ApiHelper().apiCall(
        url: Urls.RESET_PASSWORD, body: body, requestType: RequestType.POST);

    try {
      Utils().printMessage(response.data.toString());
      if (response.status == STATUS.SUCCESS &&
          response.data['success'] == true) {
        return Resource(
            status: STATUS.SUCCESS,
            data: response.data,
            message: response.data['message']);
      } else {
        if (response.status == STATUS.SUCCESS) {
          Utils().printMessage(response.data["success"].toString());
          return Resource.error(message: response.data["message"].toString());
        } else {
          return Resource.error(message: response.message);
        }
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> forgotBusinessId({required body}) async {
    print("FORGOT BUSINESS CALLING");
    // Utils().printMessage("FORGOT_BUSINESS_ID_BODY=>${jsonDecode(body)}");
    log("FORGOT BUSINESS ID BODY : ${(body)}");
    var response = await ApiHelper().apiCall(
        url: Urls.FORGOT_BUSINESS_ID,
        body: body,
        requestType: RequestType.POST);

    Utils().printMessage(response.data.toString());
    // print("response.status : ${response.status}");
    // log("response : ----------->${response}");
    // log("GARP: ${response.data['success']}");
    // log("GARP MESSAGE: ${response.data['message']}");

    try {
      if (response.status == STATUS.SUCCESS) {
        Utils().printMessage(response.data.toString());
        // if (response.data['success'] == true
        //     // ||
        //     //     response.data['success'] == false
        //     ) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response.data,
              message: response.data['message']);
        // } else {
        //   return Resource.error(message: response.data["message"].toString());
        // }
      } else {
        return Resource.error(message: response.message);
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }

  Future<Resource> phoneNoRegCheck({required body}) async {
    Utils().printMessage("phoneNoRegCheck_BODY=>$body ");
    var response = await ApiHelper().apiCall(
        url: Urls.PHN_NO_REG_CHECK, body: body, requestType: RequestType.POST);

    print("response>>>>>>>>${response}");

    try {
      if (response.status == STATUS.SUCCESS) {
        Utils().printMessage(response.data.toString());
        if (response.data['success'] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response.data['data'],
              message: response.data['message']);
        } else {
          print("Response.message----->${response.data["message"].toString()}");
          return Resource.error(message: response.data["message"].toString());
        }
      } else {
        return Resource.error(message: response.data["message"].toString());
      }
    } catch (e) {
      Utils().printMessage(e.toString());
      return Resource.error(message: SomethingWentWrong);
    }
  }
}
