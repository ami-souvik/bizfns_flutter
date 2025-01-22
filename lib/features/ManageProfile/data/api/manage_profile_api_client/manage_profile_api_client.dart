import 'dart:convert';

import 'package:bizfns/core/api_helper/api_helper.dart';
import 'package:bizfns/features/auth/Login/model/login_otp_verification_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/connect.dart';

import '../../../../../core/common/Resource.dart';
import '../../../../../core/common/Status.dart';
import '../../../../../core/shared_pref/shared_pref.dart';
import '../../../../../core/utils/Utils.dart';
import '../../../../../core/utils/api_constants.dart';
import '../../../../../core/utils/const.dart';
import '../../../../auth/Login/model/login_model.dart';
import '../../../model/GetSequrityQuestionsResponse.dart';

class ManageProfileApiClient extends GetConnect {
  Future<Resource> getSequrityQuestion({required body}) async {
    // Utils().printMessage("SEQURITY_QUESTION_BODY=>$body ");
    String? token = await GlobalHandler.getToken();
    if (token == null) {
      OtpVerificationData? data = await GlobalHandler.getLoginData();
      token = data!.token ?? "";
      await GlobalHandler.setToken(token);
    }
    Utils().printMessage(token.toString());
    Utils().printMessage(Urls.FETCH_SEQURITY_QUESTIONS);
    final response = await ApiHelper().apiCall(
        url: Urls.FETCH_SEQURITY_QUESTIONS,
        body: body,
        header: {"Authorization": "Bearer " + token.toString()},
        requestType: RequestType.POST);

    try {
      Utils().printMessage(response.data.toString());
      if (response.status == STATUS.SUCCESS) {
        if (response.data["success"] == true) {
          Map<String, dynamic> responseMap = response.data;
          GetSequrityQuestionsResponse model =
              GetSequrityQuestionsResponse.fromJson(responseMap);
          return Resource(
              status: STATUS.SUCCESS, data: model.data, message: model.message);
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
    // return Resource(status: status, data: data, message: message);
  }

  Future<Resource> saveSequrityQuestion({required body}) async {
    Utils().printMessage("QUESTION BODY=>${jsonEncode(body)} ");
    String? token = await GlobalHandler.getToken();
    if (token == null) {
      OtpVerificationData? data = await GlobalHandler.getLoginData();
      token = data!.token ?? "";
      await GlobalHandler.setToken(token);
    }
    Utils().printMessage(token.toString());

    var response = await post(Urls.SAVE_SEQURITY_QUESTIONS, json.encode(body),
        headers: {"Authorization": "Bearer " + token.toString()});
    if (response != null && response.isOk) {
      try {
        Utils().printMessage(response.body.toString());
        if (response.body['success'] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response.body['data'],
              message: response.body['message']);
        } else {
          return Resource.error(message: response.body["message"].toString());
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: response.body["message"].toString());
      }
    } else {
      Utils().printMessage(response.status.code.toString());
      if (response.status.code.toString() == "403") {
        return Resource.error(message: TOKEN_EXPIRED);
      } else {
        return Resource.error(message: NoResponseMsg);
      }
    }
  }

  Future<Resource> verifySequrityQuestion({required body}) async {
    Utils().printMessage("QUESTION BODY=>$body ");
    Utils().printMessage("QUESTION BODY=>${Urls.VERIFY_SEQURITY_QUESTIONS} ");
    String? token = await GlobalHandler.getToken();
    if (token == null) {
      OtpVerificationData? data = await GlobalHandler.getLoginData();
      token = data!.token ?? "";
      await GlobalHandler.setToken(token);
    }
    Utils().printMessage(token.toString());

    var response = await post(Urls.VERIFY_SEQURITY_QUESTIONS, json.encode(body),
        headers: {"Authorization": "Bearer " + token.toString()});
    if (response != null && response.isOk) {
      try {
        Utils().printMessage(response.body.toString());
        if (response.body['success'] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response.body['data'],
              message: response.body['message']);
        } else {
          return Resource.error(message: response.body["message"].toString());
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: response.body["message"].toString());
      }
    } else {
      Utils().printMessage(response.status.code.toString());
      if (response.status.code.toString() == "403") {
        return Resource.error(message: TOKEN_EXPIRED);
      } else {
        return Resource.error(message: NoResponseMsg);
      }
    }
  }

  Future<Resource> changePassword({required body}) async {
    Utils().printMessage("ChangePassword BODY=>$body ");
    String? token = await GlobalHandler.getToken();
    if (token == null) {
      OtpVerificationData? data = await GlobalHandler.getLoginData();
      token = data!.token ?? "";
      await GlobalHandler.setToken(token);
    }
    Utils().printMessage(token.toString());
    // print("")
    var response = await ApiHelper().apiCall(
        url: Urls.CHANGE_PASSWORD,
        body: body,
        header: {"Authorization": "Bearer " + token.toString()},
        requestType: RequestType.POST);
    if (response != null && response.status == STATUS.SUCCESS) {
      try {
        Utils().printMessage(response.data.toString());
        if (response.data['success'] == true) {
          return Resource(
              status: STATUS.SUCCESS,
              data: response.data['data'],
              message: response.data['message']);
        } else {
          return Resource.error(message: response.data["message"].toString());
        }
      } catch (e) {
        Utils().printMessage(e.toString());
        return Resource.error(message: e.toString());
      }
    } else {
      Utils().printMessage(response.data.toString());
      if (response.data.toString() == "403") {
        return Resource.error(message: TOKEN_EXPIRED);
      } else {
        return Resource.error(message: response.message);
      }
    }
  }

  Future<Resource> verifyOtp({required body}) async {
    Utils().printMessage("verifyOtp_BODY=>$body ");
    String? token = await GlobalHandler.getToken();
    if (token == null) {
      OtpVerificationData? data = await GlobalHandler.getLoginData();
      token = data!.token ?? "";
      await GlobalHandler.setToken(token);
    }
    Utils().printMessage(token.toString());
    var response = await ApiHelper().apiCall(
        url: Urls.VALIDATE_CHANGE_PASSWORD_OTP,
        body: body,
        header: {"Authorization": "Bearer " + token.toString()},
        requestType: RequestType.POST);

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
        Utils().printMessage(response.data.toString());
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
  }

  Future<Resource> changeBusinessMobileNo({required body}) async {
    Utils().printMessage("changeBusinessMobileNo_BODY=>$body ");
    String? token = await GlobalHandler.getToken();
    if (token == null) {
      OtpVerificationData? data = await GlobalHandler.getLoginData();
      token = data!.token ?? "";
      await GlobalHandler.setToken(token);
    }
    Utils().printMessage(token.toString());
    var response = await ApiHelper().apiCall(
        url: Urls.CHANGE_BUSINESS_MOBILE_NO,
        body: body,
        header: {"Authorization": "Bearer " + token.toString()},
        requestType: RequestType.POST);

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
        Utils().printMessage(response.data.toString());
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
  }
}
