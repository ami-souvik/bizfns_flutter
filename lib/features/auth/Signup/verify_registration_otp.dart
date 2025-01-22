import 'dart:async';

import 'package:bizfns/core/utils/fonts.dart';
import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/ManageProfile/provider/manage_profile_provider.dart';
import 'package:bizfns/features/auth/Login/provider/login_provider.dart';
import 'package:bizfns/features/auth/Signup/provider/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:sizing/sizing.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/colour_constants.dart';
import '../../../core/widgets/otp_input.dart';


class VerifyRegistrationOTP extends StatefulWidget {


  VerifyRegistrationOTP({super.key});

  @override
  State<VerifyRegistrationOTP> createState() => _VerifyRegistrationOTPState();
}

class _VerifyRegistrationOTPState extends State<VerifyRegistrationOTP> {


  @override
  void dispose() {
    // if( Provider.of<SignupProvider>(context,listen: false).timer!=null) Provider.of<SignupProvider>(context,listen: false).timer!.cancel();

    // Provider.of<SignupProvider>(context,listen: false).otpController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    Provider.of<SignupProvider>(context, listen: false).otpController.text ="";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // var controller = Get.put(VerifyOtpController());

    var provider = Provider.of<SignupProvider>(context, listen: false);


    return SafeArea(
        child: Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   // centerTitle: true,
      //   title: Center(
      //     child:  Text(
      //       "Verify OTP",
      //       style: TextStyle(color: Colors.black, fontSize: 16.fss),
      //     ),
      //   ),
      //   // leading: IconButton(
      //   //   icon: const Icon(
      //   //     Icons.arrow_back,
      //   //     size: 22,
      //   //     color: Colors.black,
      //   //   ),
      //   //   onPressed: () {
      //   //     Navigator.pop(context);
      //   //   },
      //   // ),
      //   automaticallyImplyLeading: false,
      // ),

      body: provider.loading
          ?SizedBox(
        //color: Colors.red,
        width: size.width,
        child:  const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ))
            : SingleChildScrollView(
              child: Container(
                height: size.height,
                child: Column(
                  // shrinkWrap: true,

                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.ss),
                        child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Gap(size.height/12.ss),
                        Padding(
                          padding:  EdgeInsets.all(8.0.ss),
                          child: SizedBox(
                            height: 20.ss,
                            child: Center(
                              child: Image.asset("assets/images/logo.png"),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Simple Services",
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Roboto", color: Colors.black),
                            ),
                          ],
                        ),

                        Gap(10.ss),
                        CommonText(text: "OTP Sent",textStyle: CustomTextStyle(fontSize: 24.fss,fontWeight: FontWeight.w700)),
                        Gap(10.ss),
                        // Gap(30.ss),
                        Text(
                          provider.model!.otpMessage??"",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),

                        Gap(20.ss),


                        Pinput(
                          androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                          length: 6,
                          controller: Provider.of<SignupProvider>(context,listen: false).otpController,
                        ),
                        Gap(10.ss),
                        Visibility(
                          visible: Provider.of<SignupProvider>(context,listen: true).enableResend?false:true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,

                                child: CommonText(text:"Resend otp after ${context.watch<SignupProvider>().secondsRemaining} seconds",
                                  textStyle: CustomTextStyle(color: AppColor.APP_BAR_COLOUR),),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: Provider.of<SignupProvider>(context,listen: true).enableResend,
                          child: InkWell(
                            onTap: (){
                              provider.resendCode(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: CommonText(text:"Resend",textStyle: CustomTextStyle(color: AppColor.APP_BAR_COLOUR,fontSize: 16.ss)),
                            ),
                          ),
                        ),
                        Gap(20.ss),
                        Center(
                          child: InkWell(
                              onTap: () {},
                              child: SizedBox(
                                height: 50.ss,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Provider.of<SignupProvider>(context,listen: true).otpController.text.isNotEmpty &&
                                        Provider.of<SignupProvider>(context,listen: true).otpController.text.length==6
                                        ? AppColor.APP_BAR_COLOUR
                                        : Colors.grey,
                                    padding:  EdgeInsets.symmetric(
                                      horizontal: 20.ss,
                                    ),
                                  ),
                                  onPressed: () {

                                    // Utils().printMessage("_fieldSix.text.isNotEmpty=>${_fieldSix.text.isNotEmpty}");
                                    Provider.of<SignupProvider>(context,listen: false).otpController.text.length==6?provider.otpPagevalidation(context, provider.otpController.text):null;
                                  },
                                  child: const Text(
                                    "Verify OTP",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    )),

                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: size.height/4.ss,
                            decoration: BoxDecoration(
                                image: DecorationImage(fit: BoxFit.fitWidth,
                                    image: AssetImage("assets/images/login_bottom_background.png")
                                )
                            ),
                          ),
                        ],
                      ),
                    )



                  ],
                ),
              ),
            ),
      ),
    );
  }
}
