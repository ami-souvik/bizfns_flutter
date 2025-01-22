

import 'dart:convert';

import 'package:bizfns/core/utils/const.dart';
import 'package:bizfns/features/auth/ForgotPassword/model/ForgotPasswordModel.dart';
import 'package:bizfns/features/auth/ForgotPassword/model/ForgotPasswordVerifyOtpModel.dart';
import 'package:flutter/material.dart';


import '../../../../core/common/Resource.dart';
import '../../../../core/common/Status.dart';
import '../../data/api/auth_api_client/auth_api_client.dart';


class ForgotPasswordRepoImpl{

  final AuthApiClient apiClient;

  ForgotPasswordRepoImpl({required this.apiClient});

  Future<Resource> forgotPassword({required body}) async{
    Resource data = await apiClient.forgotPassword(body: body);
    if(data.status ==STATUS.SUCCESS) {
      try {
        var mData = data.data;
        ForgotPasswordData forgotPasswordData = ForgotPasswordData.fromJson(
            mData);
        data.data = forgotPasswordData;
      } catch (e) {
        data.status = STATUS.ERROR;
        data.message = SomethingWentWrong;
      }
    }
    return data;
  }


  @override
  Future<Resource> verifyOtp({required body}) async {
    Resource data = await apiClient.verifyForgotPasswordOtp(body: body);
    if (data.status == STATUS.SUCCESS) {
     try{
       Map<String, dynamic> response = jsonDecode(data.data);

       ForgotPasswordVerifyOtpModel forgotPasswordVerifyOtpModel = ForgotPasswordVerifyOtpModel.fromJson(response);
       data.data =forgotPasswordVerifyOtpModel;
     }catch(e){
       // data.message =SomethingWentWrong+e.toString();
       // data.data =null;
       // data.status= STATUS.ERROR;
     }
    } else {
    }
    return data;
  }

  Future<Resource> resetPassword({required body}) async{
    Resource data = await apiClient.resetPassword(body: body);
    if (data.status == STATUS.SUCCESS) {
// ForgotPasswordVerifyOtpModel otpModel = ForgotPasswordVerifyOtpModel.fromJson(jsonDecode(data.data));
// data.data=otpModel;

    } else {

    }
    return data;
  }

}