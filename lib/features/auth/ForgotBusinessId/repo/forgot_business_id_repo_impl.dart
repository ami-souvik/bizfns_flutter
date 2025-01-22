

import 'dart:convert';

import 'package:bizfns/core/utils/const.dart';
import 'package:bizfns/features/auth/ForgotPassword/model/ForgotPasswordModel.dart';
import 'package:bizfns/features/auth/ForgotPassword/model/ForgotPasswordVerifyOtpModel.dart';
import 'package:flutter/material.dart';


import '../../../../core/common/Resource.dart';
import '../../../../core/common/Status.dart';
import '../../data/api/auth_api_client/auth_api_client.dart';


class ForgotBusinessIdRepoImpl{

  final AuthApiClient apiClient;

  ForgotBusinessIdRepoImpl({required this.apiClient});

  Future<Resource> ForgotBusinessId({required body}) async{
    Resource data = await apiClient.forgotBusinessId(body: body);
    if(data.status ==STATUS.SUCCESS) {
      // try {
      //   // var mData = data.data;
      //   // data.data = forgotPasswordData;
      // } catch (e) {
      //   data.status = STATUS.ERROR;
      //   data.message = SomethingWentWrong;
      // }
    }
    return data;
  }



}