import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/Resource.dart';
import '../../../../core/common/Status.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../data/api/auth_api_client/auth_api_client.dart';

class LoginRepoImpl {
  final AuthApiClient apiClient;

  LoginRepoImpl({required this.apiClient});

  Future<Resource> login({required body}) async {
    Resource data = await apiClient.login(body: body);
    return data;
  }

  @override
  Future<Resource> verifyOtp(
      {required String userId,
      required String tenantId,
      required String otp,
      required String otpTimeStamp}) async {
    var body = {
      "userId": userId.length > 10
          ? userId
              .replaceAll('(', '')
              .replaceAll(')', '')
              .replaceAll('-', '')
              .removeAllWhitespace
          : userId,
      "tenantId": tenantId,
      "otp": otp,
      "otpTimeStamp": otpTimeStamp,
      "token": await GlobalHandler.getToken()
    };

    print("OtpBody====>$body");
    Resource data = await apiClient.verifyOtp(body: body);
    return data;
  }
}
