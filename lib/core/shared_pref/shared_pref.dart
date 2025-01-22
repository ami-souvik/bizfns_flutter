import 'dart:convert';

import 'package:bizfns/core/shared_pref/shared_key.dart';
import 'package:bizfns/features/auth/Login/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/Login/model/login_otp_verification_model.dart';
import '../utils/Utils.dart';
class GlobalHandler {

  ///Save the user id written in the login screen
  static Future setUserId(String token) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString(userId, token);
    });
  }

  ///get the saved user id
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(userId);
    if (token == null){
      return null;
    }else{
      if(token.contains('(')){
        return token.toString().replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').removeAllWhitespace.trim();
      }else{
        return token;
      }
    }
  }

  /// Save the valid company id by which login is done
  static Future setCompanyId(String token) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString(companyId, token);
    });
  }

  /// Get the saved company id
  static Future<String?> getCompanyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(companyId);
    return token;
  }


  /// Save the valid company name by which login is done
  static Future setCompanyName(String token) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString(companyName, token);
    });
  }

  /// Get the saved company name
  static Future<String?> getCompanyName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(companyName);
    return token;
  }


  /// Get the saved token for pass in to the header for call any api
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var logintoken = prefs.getString(token);
    return logintoken;
  }


  /// Save the token which is getting after successfully verify the otp in time of login
  static Future setToken(String mToken) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString(token, mToken);
    });
  }


  /// Save the FCM token
  static Future setFcmToken(String token) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString(fcmToken, token);
    });
  }

  /// Fetch the FCM token
  static Future<String?> getFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(fcmToken);
    return token;
  }

  /// Clear the shared preferences data from the device
  static Future clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.clear();
    return data;
  }



  /// Save the info is user logged in or not
  static Future setLogedIn(bool loogedin) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(loggedIn, loogedin);
    });
  }

  /// Fetch the info is user logged in or not
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loggedin = prefs.getBool(loggedIn);
    if(loggedin == null) loggedin = false;
    return loggedin;
  }

  /// Save the info is security questions or temporary password changed or not for the first time login only
  /// security questions is applicable for admin user
  /// temporary password change is applicable for customer and stuffs
  static Future setSequrityQuestionAnswered(bool answered) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(isSequrityQuestionAnswered, answered);
    });
  }

  /// Get the info is security questions or temporary password changed or not for the first time login only
  /// security questions is applicable for admin user
  /// temporary password change is applicable for customer and stuffs
  static Future<bool> getSequrityQuestionAnswered() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var answered = prefs.getBool(isSequrityQuestionAnswered);
    if(answered == null) answered = false;
    return answered;
  }



  ///Save the users data after login for further use
  static Future setLoginData(OtpVerificationData? data) async {
    await SharedPreferences.getInstance().then((prefs) {
      // Utils().printMessage("Login data===>>>>"+ jsonEncode(data!));
      if(data!=null) prefs.setString(loginData, jsonEncode(data??""));
    });
  }

  ///Fetch the users data saved after successful login
  static Future<OtpVerificationData?> getLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(loginData);
    Utils().printMessage(data??'');
    OtpVerificationData? loginDatamodel;
    try {
      loginDatamodel = OtpVerificationData.fromJson(jsonDecode(data!));
    }catch(e){

    }
    return loginDatamodel;
  }


}