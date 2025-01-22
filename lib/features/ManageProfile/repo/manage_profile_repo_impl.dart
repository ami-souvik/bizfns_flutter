

import 'dart:convert';

import 'package:bizfns/core/utils/Utils.dart';
import 'package:bizfns/core/utils/const.dart';
import 'package:flutter/material.dart';


import '../../../../core/common/Resource.dart';
import '../../../../core/common/Status.dart';
import '../../../core/utils/route_function.dart';
import '../data/api/manage_profile_api_client/manage_profile_api_client.dart';
import '../model/ChangePasswordResponse.dart';
import '../model/GetSequrityQuestionsResponse.dart';


class ManageProfileRepoImpl{

  final ManageProfileApiClient apiClient;

  ManageProfileRepoImpl({required this.apiClient});

  Future<Resource> getSequrityQuestion({required body}) async{
    Resource data = await apiClient.getSequrityQuestion(body: body);
    if(data.status ==STATUS.SUCCESS){

    }else{

    }
    return data;
  }
 Future<Resource> saveSequrityQuestion({required body}) async{
    Resource data = await apiClient.saveSequrityQuestion(body: body);
    if(data.status ==STATUS.SUCCESS){

    }else{

    }
    return data;
  }

  Future<Resource> verifySequrityQuestion({required body}) async{
    Resource data = await apiClient.verifySequrityQuestion(body: body);
    if(data.status ==STATUS.SUCCESS){

    }else{

    }
    return data;
  }
  Future<Resource> changePasswordAndSendOtp({required body}) async{
    Resource data = await apiClient.changePassword(body: body);
    Utils().printMessage(body.toString());
    if(data.status == STATUS.SUCCESS){
      try{
        ChangePasswordData? changePasswordData = ChangePasswordData.fromJson(data.data);
        data.data= changePasswordData;

      }catch(e){
        data.message= SomethingWentWrong;
        data.status = STATUS.ERROR;
      }
    }else{

    }
    return data;
  }


  @override
  Future<Resource> verifyOtp({required body}) async {
    Resource data = await apiClient.verifyOtp(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("verify otp true");
    } else {
      Utils().printMessage("verify otp false");
    }
    return data;
  }

  @override
  Future<Resource> changeMobileNo({required body}) async {
    Resource data = await apiClient.changeBusinessMobileNo(body: body);
    if (data.status == STATUS.SUCCESS) {
      Utils().printMessage("verify otp true");
    } else {
      Utils().printMessage("verify otp false");
    }
    return data;
  }



}