import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/ManageProfile/provider/manage_profile_provider.dart';
import 'package:bizfns/features/auth/ForgotPassword/provider/forgot_password_provider.dart';
import 'package:bizfns/features/auth/Login/provider/login_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:sizing/sizing.dart';
import 'package:provider/provider.dart';

import '../../../core/route/RouteConstants.dart';
import '../../../core/utils/colour_constants.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/route_function.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/widgets/common_text_form_field.dart';

class ChangePhoneNoPage extends StatefulWidget {
  const ChangePhoneNoPage({Key? key}) : super(key: key);

  @override
  State<ChangePhoneNoPage> createState() => _ChangePhoneNoPageState();
}

class _ChangePhoneNoPageState extends State<ChangePhoneNoPage> {
  @override
  void dispose() {
    // Provider.of<ManageProfileProvider>(context,listen: false).clearController();
    super.dispose();
  }

  @override
  void initState() {
    Provider.of<ManageProfileProvider>(context, listen: false)
        .clearController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var controller = Provider.of<ManageProfileProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFf4feff),
        body: controller.loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.APP_BAR_COLOUR,
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: Provider.of<ManageProfileProvider>(context,
                            listen: false)
                        .changePhNoFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gap(10.ss),
                        // IconButton(
                        //   onPressed: () {
                        //     Navigator.pop(context);
                        //   },
                        //   icon: Icon(Icons.arrow_back),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 20,
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
                                  fontSize: 18,
                                  fontFamily: "Roboto",
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        Gap(10.ss),
                        Gap(MediaQuery.of(context).size.height / 15.ss),
                        CommonText(
                            text: "Change Mobile No",
                            textStyle: CustomTextStyle(
                                fontSize: 24.fss, fontWeight: FontWeight.w700)),
                        Gap(30.ss),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                          child: CommonText(
                              text: "Enter Current Mobile No",
                              textStyle: CustomTextStyle(
                                  fontSize: 14.fss,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Gap(0.ss),
                        CommonTextFormField(
                            textInputType: TextInputType.number,
                            maxLength: 10,
                            textInputAction: TextInputAction.next,
                            onValidator: (value) {
                              if (value != null && value.isEmpty) {
                                return "Please enter 10 digit mobile no";
                              } else if (value != null &&
                                  !value.isEmpty &&
                                  value.length < 10) {
                                return "Please enter 10 digit mobile no";
                              } else
                                return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            controller: context
                                .watch<ManageProfileProvider>()
                                .currentPhoneNoController,
                            fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                            decoration: InputDecoration(
                              hintText: "Current Mobile No",
                              counterText: "",
                              border: OutlineInputBorder(gapPadding: 1),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(gapPadding: 1),
                              focusedBorder: OutlineInputBorder(gapPadding: 1),
                            )),
                        Gap(20.ss),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                          child: CommonText(
                              text: "Enter New Mobile No",
                              textStyle: CustomTextStyle(
                                  fontSize: 14.fss,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Gap(0.ss),
                        CommonTextFormField(
                            textInputAction: TextInputAction.done,
                            controller: context
                                .watch<ManageProfileProvider>()
                                .newPhoneNoController,
                            fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                            textInputType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            maxLength: 10,
                            onValidator: (value) {
                              if (value != null && value.isEmpty) {
                                return "Please enter 10 digit mobile no";
                              } else if (value != null &&
                                  !value.isEmpty &&
                                  value.length < 10) {
                                return "Please enter 10 digit mobile no";
                              } else if (value != null &&
                                  !value.isEmpty &&
                                  value.length < 10) {
                                return "Please enter 10 digit mobile no";
                              } else if (context
                                      .read<ManageProfileProvider>()
                                      .currentPhoneNoController
                                      .text ==
                                  value) {
                                return "Current and new mobile no should be different";
                              } else
                                return null;
                            },
                            decoration: InputDecoration(
                              hintText: "New Mobile No",
                              counterText: "",
                              border: OutlineInputBorder(gapPadding: 1.ss),
                              isDense: true,
                              enabledBorder:
                                  OutlineInputBorder(gapPadding: 1.ss),
                              focusedBorder:
                                  OutlineInputBorder(gapPadding: 1.ss),
                            )),
                        Gap(30.ss),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.0.ss),
                          child: InkWell(
                              onTap: () {
                                // Fluttertoast.showToast(msg: "Clicked");
                                //showMyDialog(context);
                                //  context.go(Routes.VERIFY_OTP, arguments: {'phno': "9064818788"});
                                controller.validitionForPhoneNoChange(context);
                                // context.go(Routes.VERIFY_OTP);
                              },
                              child: const CustomButton(title: "Submit")),
                        )
                      ],
                    ),
                  ),
                ),
              ),
//)
      ),
    );
  }
}
