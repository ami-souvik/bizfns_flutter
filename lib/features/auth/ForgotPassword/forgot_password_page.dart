import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/auth/ForgotPassword/provider/forgot_password_provider.dart';
import 'package:bizfns/features/auth/Login/provider/login_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizing/sizing.dart';
import 'package:provider/provider.dart';

import '../../../core/route/RouteConstants.dart';
import '../../../core/utils/colour_constants.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/route_function.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/widgets/common_dropdown.dart';
import '../../../core/widgets/common_text_form_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  void initState() {
    // Provider.of<ForgotPasswordProvider>(context, listen: false)
    //     .DisposeForgotPasswordController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // var controller =
    //     Provider.of<ForgotPasswordProvider>(context, listen: false);
    var controller = Provider.of<LoginProvider>(context, listen: false);
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFf4feff),
        body: context.watch<ForgotPasswordProvider>().loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColor.APP_BAR_COLOUR,
                ),
              )
            : SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: kIsWeb
                              ? MediaQuery.of(context).size.width / 4
                              : 20.ss),
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: Provider.of<ForgotPasswordProvider>(context,
                                listen: false)
                            .forgotPasswordFormKey,
                        child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(size.height / 20.ss),
                            Padding(
                              padding: EdgeInsets.all(8.0.ss),
                              child: SizedBox(
                                height: 75.ss,
                                child: Center(
                                  child: Image.asset("assets/images/logo.png"),
                                ),
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     CommonText(
                            //       text: "Simple Services",
                            //       textStyle: CustomTextStyle(
                            //           fontSize: 18.fss, color: Colors.black),
                            //     ),
                            //   ],
                            // ),
                            Gap(10.ss),
                            Gap(size.height / 20.ss),
                            CommonText(
                                text: "Forgot Password",
                                textStyle: CustomTextStyle(
                                    fontSize: 24.fss,
                                    fontWeight: FontWeight.w700)),
                            CommonText(
                                text: "Hello There! Welcome Back",
                                textStyle: CustomTextStyle(
                                    fontSize: 14.fss,
                                    fontWeight: FontWeight.w500)),
                            Gap(30.ss),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 8.0.ss, top: 0.ss),
                              child: InkWell(
                                onTap: () {
                                  // Navigate(context,forgot_password);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0.ss),
                                      child: CommonText(
                                          text: "User Id",
                                          textStyle: CustomTextStyle(
                                              fontSize: 14.fss,
                                              fontWeight: FontWeight.w700)),
                                    ),

                                    //TODO: [Discussion] Forgot Business Id has to be deleted`

                                    /*InkWell(
                                            onTap: () {
                                              Navigate(
                                                  context, forgot_business_id);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.0.ss),
                                              child: CommonText(
                                                text: "Forgot Business Id?",
                                                textStyle: TextStyle(
                                                    fontSize: 12.fss,
                                                    fontWeight: FontWeight.w500,
                                                    // decoration: TextDecoration.underline,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),*/
                                  ],
                                ),
                              ),
                            ),
                            Gap(5.ss),
                            Focus(
                              child: CommonTextFormField(
                                onChanged: (val) async {
                                  controller.changeDropDownOption(context);
                                  if (val!.length >= 10) {
                                    await controller.getBusinessId(context);
                                  }
                                },
                                onSave: (val) async {
                                  await controller.getBusinessId(context);
                                },
                                onValueChanged: (val) async {
                                  if (val.length >= 10) {
                                    await controller.getBusinessId(context);
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                controller: Provider.of<LoginProvider>(context,
                                        listen: false)
                                    .userIdController,
                                onValidator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter user Id";
                                  } else {
                                    return null;
                                  }
                                },
                                fontTextStyle:
                                    CustomTextStyle(fontSize: 16.fss),
                                decoration: const InputDecoration(
                                  hintText: "Registered email / mobile no",
                                  border: OutlineInputBorder(gapPadding: 1),
                                  isDense: true,
                                  enabledBorder:
                                      OutlineInputBorder(gapPadding: 1),
                                  focusedBorder:
                                      OutlineInputBorder(gapPadding: 1),
                                ),
                              ),
                              onFocusChange: (hasFocus) async {
                                if (!hasFocus &&
                                    controller
                                        .userIdController.text.isNotEmpty) {
                                  await controller.getBusinessId(context);
                                }
                              },
                            ),
                            Gap(5.ss),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 10.0.ss),
                              child: CommonText(
                                  text: "Business Name",
                                  textStyle: CustomTextStyle(
                                      fontSize: 14.fss,
                                      fontWeight: FontWeight.w700)),
                            ),
                            Gap(5.ss),
                            CommonDropdown(
                              options: context
                                  .watch<LoginProvider>()
                                  .businessNameDropdownOptions,
                              selectedValue: context
                                  .watch<LoginProvider>()
                                  .selectedBusiness,
                              onChange: (value) {
                                context.read<LoginProvider>().selectedBusiness =
                                    value;

                                context
                                    .read<LoginProvider>()
                                    .changeBusinessDropDown(value);
                                /*Provider.of<LoginProvider>(context,
                                              listen: false)
                                          .sselectedBusiness = null;
                                      Provider.of<LoginProvider>(context,
                                              listen: false)
                                          .sselectedBusiness = value.id; */

                                print("Dropdown value===>${value.dependentid}");
                                if (context
                                        .read<LoginProvider>()
                                        .businessNameDropdownOptions
                                        .first
                                        .id ==
                                    -1) {
                                  context
                                      .read<LoginProvider>()
                                      .businessNameDropdownOptions
                                      .removeAt(0);
                                }
                                context.read<LoginProvider>().notifyListeners();
                              },
                            ),
                            Gap(30.ss),
                            InkWell(
                                onTap: () {
                                  // Fluttertoast.showToast(msg: "Clicked");
                                  //showMyDialog(context);
                                  //  context.go(Routes.VERIFY_OTP, arguments: {'phno': "9064818788"});
                                  Provider.of<ForgotPasswordProvider>(context,
                                          listen: false)
                                      .validition(
                                          context,
                                          Provider.of<LoginProvider>(context,
                                                  listen: false)
                                              .userIdController
                                              .text,
                                          Provider.of<LoginProvider>(context,
                                                  listen: false)
                                              .selectedBusiness
                                              .id
                                              .toString());
                                  // context.go(Routes.VERIFY_OTP);
                                },
                                child: const CustomButton(title: "Submit"))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
//)
      ),
    );
  }
}
