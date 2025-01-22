import 'dart:async';

import 'package:bizfns/core/utils/fonts.dart';
import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/auth/ForgotPassword/provider/forgot_password_provider.dart';
import 'package:bizfns/features/auth/Login/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:sizing/sizing.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/colour_constants.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/widgets/otp_input.dart';

class VerifyForgotPasswordOTP extends StatelessWidget {
  //var phno = Get.arguments['phno'];
  final String phno;

  VerifyForgotPasswordOTP({super.key, required this.phno});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var provider = Provider.of<ForgotPasswordProvider>(context, listen: false);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // centerTitle: true,
        title: const Text(
          "Verify OTP",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 22,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        //color: Colors.red,
        width: size.width,
        child: provider.loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(30),
                    const Text(
                      "Enter verification code",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const Gap(8),
                    Text(
                      provider.forgotpasswordMsgController.text,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(20),
                    Pinput(
                      androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                      length: 6,
                      controller: Provider.of<ForgotPasswordProvider>(context,
                              listen: false)
                          .pinController,
                    ),
                    Gap(10.ss),
                    Gap(10.ss),
                    Visibility(
                      visible:
                          context.watch<ForgotPasswordProvider>().enableResend
                              ? false
                              : true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: CommonText(
                                text:
                                    "Resend OTP after ${context.watch<ForgotPasswordProvider>().secondsRemaining} seconds"),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible:
                          context.watch<ForgotPasswordProvider>().enableResend,
                      child: InkWell(
                        onTap: () {
                          provider.resendCode(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: CommonText(
                            text: "Resend OTP",
                            textStyle:
                                CustomTextStyle(color: AppColor.APP_BAR_COLOUR),
                          ),
                        ),
                      ),
                    ),
                    const Gap(20),
                    InkWell(
                      child: CustomButton(title: "Verify OTP"),
                      onTap: () {
                        var otp = "";
                        Provider.of<ForgotPasswordProvider>(context,
                                listen: false)
                            .validitionOtpPage(context);
                      },
                    )
                  ],
                ),
              ),
      ),
    ));
  }
}
