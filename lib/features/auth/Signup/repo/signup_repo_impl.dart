import 'package:flutter/material.dart';

import '../../../../core/common/Resource.dart';
import '../../../../core/common/Status.dart';
import '../../../../core/utils/Utils.dart';
import '../../data/api/auth_api_client/auth_api_client.dart';

class SignupRepoImpl {
  final AuthApiClient apiClient;

  SignupRepoImpl({required this.apiClient});

  Future<Resource> signup({required Map body}) async {
    Resource data = await apiClient.signUp(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("logedin true");

      // sharedPref.setLoginState(true);
    } else {
      Utils().printMessage("logedin false");
      // sharedPref.setLoginState(false);
    }
    return data;
  }

  Future<Resource> preSignupData() async {
    Resource data = await apiClient.PreSignupData();
    return data;
  }

  Future<Resource> signupSendOtp(
      {required String userId, required String emailId}) async {
    Resource data =
        await apiClient.SignupOtpSend(user_id: userId, email_id: emailId);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("logedin true");

      // sharedPref.setLoginState(true);
    } else {
      Utils().printMessage("logedin false");
      // sharedPref.setLoginState(false);
    }
    return data;
  }

  Future<Resource> verifySignupOtp({required Map body}) async {
    Resource data = await apiClient.verifySignUpOtp(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("logedin true");

      // sharedPref.setLoginState(true);
    } else {
      Utils().printMessage("logedin false");
      // sharedPref.setLoginState(false);
    }
    return data;
  }

  Future<Resource> phoneNoRegCheck({required Map body}) async {
    Resource data = await apiClient.phoneNoRegCheck(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("number is available");

      // sharedPref.setLoginState(true);
    } else {
      Utils().printMessage("number is not available");
      // sharedPref.setLoginState(false);
    }
    return data;
  }
}
