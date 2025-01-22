

import 'package:flutter/material.dart';


import '../../../../core/common/Resource.dart';
import '../../../../core/common/Status.dart';
import '../data/api/home_api_client/home_api_client.dart';


class ManageProfileRepoImpl{

  final HomeApiClient apiClient;

  ManageProfileRepoImpl({required this.apiClient});

  /*Future<Resource> getSequrityQuestion({required body}) async{
    Resource data = await apiClient.getSequrityQuestion(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("logedin true");

      // sharedPref.setLoginState(true);
    } else {
      Utils().printMessage("logedin false");
      // sharedPref.setLoginState(false);
    }
    return data;
  }*/


/*  @override
  Future<Resource> verifyOtp({required body}) async {
    Resource data = await apiClient.verifyForgotPasswordOtp(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("verify otp true");
    } else {
      Utils().printMessage("verify otp false");
    }
    return data;
  }*/



}