import 'dart:async';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import 'package:go_router/go_router.dart';

import '../../core/route/RouteConstants.dart';
import '../../core/shared_pref/shared_pref.dart';
import '../../core/utils/EncryptionUtils.dart';
import '../../core/utils/route_function.dart';
import '../auth/Login/model/login_otp_verification_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    // Future.delayed(const Duration(milliseconds: 3000),() => context.go(login));
    Future.delayed(Duration(microseconds: 3000)).then((value) async {
      TestEncryption();
      var loogedin = await GlobalHandler.isLoggedIn();
      if (!loogedin)
        Navigate.NavigateAndReplace(context, login, params: {});
      else {
        var answered = await GlobalHandler.getSequrityQuestionAnswered();
        if (answered)
          GoRouter.of(context)
              .pushNamed('home'); //Navigate.NavigateAndReplace(context, home);
        // else  Navigate.NavigateAndReplace(context,security_question_page);
        OtpVerificationData? data = await GlobalHandler.getLoginData();
        bool isSequrityQuestionAnswered =
            await GlobalHandler.getSequrityQuestionAnswered();
        if (data != null && data!.userType != null && data!.userType == "1") {
          if (isSequrityQuestionAnswered != null && isSequrityQuestionAnswered)
            context
                .goNamed('home'); //Navigate.NavigateAndReplace(context, home);
          else {
            Navigate.NavigateAndReplace(context, security_question_page,
                params: {"forWhat": ""});
          }
        }
        //  else if (data!.userType != null && data!.userType == "2") {
        else if (data!.userType != null && data!.userType == "2") {
          if (isSequrityQuestionAnswered != null && isSequrityQuestionAnswered)
            context
                .goNamed('home'); //Navigate.NavigateAndReplace(context, home);
          else {
            // Navigate(context, change_password);
            Navigate.NavigateAndReplace(context, login);
          }
        } else {
          await GlobalHandler.setSequrityQuestionAnswered(true);
          context.goNamed(home); //Navigate.NavigateAndReplace(context, home);
        }
      }
    });

    /*Timer.periodic(
      Duration(seconds: 3),
          (Timer timer) async {
            context.go(login);
      },
    );*/

    return Scaffold(
      body: Container(
          height: size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF00ACD8), Color(0xFF093E52)])),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  bottom: 0,
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Image.asset("assets/images/image.png")),
              const Positioned(
                  bottom: 0,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        )),
                  )),
            ],
          )),
    );
  }

  void TestEncryption() async {
    String encryptedData = EncryptionUtils.encrypt("2343215612");
    String decryptedData = await EncryptionUtils.decrypt(encryptedData);
    // String decryptedData = await EncryptionUtils.decrypt("Nx4h59mvGRxPLzIJXTq7HsWislkwJerHyJIXikYw+A8=");

    print(encryptedData); // This is the encrypted data
    print(decryptedData); // This is the decrypted data
  }
}
