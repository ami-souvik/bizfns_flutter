import 'package:bizfns/core/route/NavRouter.dart';
import 'package:bizfns/core/widgets/common_text.dart';
import 'package:bizfns/features/ManageProfile/provider/manage_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizing/sizing.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/colour_constants.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/widgets/common_text_form_field.dart';
import '../../core/utils/Utils.dart';
import '../../core/utils/api_constants.dart';
import '../../core/utils/const.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // Provider.of<ManageProfileProvider>(context, listen: false)
    //     .clearChangePasswordController();
    Provider.of<ManageProfileProvider>(context, listen: false)
        .getCompanyDetails();

    print("url==========>${Urls.CHANGE_PASSWORD}");
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
                    key: changePasswordFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gap(10.ss),
                        // IconButton(
                        //   onPressed: () {
                        //     Navigator.pop(context);
                        //     // goRouter.pop();
                        //   },
                        //   icon: Icon(Icons.arrow_back),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 80.ss,
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
                        //           fontSize: 18, color: Colors.black),
                        //     ),
                        //   ],
                        // ),
                        Gap(10.ss),
                        Gap(MediaQuery.of(context).size.height / 15.ss),
                        CommonText(
                            text: "Set New Password",
                            textStyle: CustomTextStyle(
                                fontSize: 24.fss, fontWeight: FontWeight.w700)),
                        Gap(30.ss),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: CommonText(
                              text: "Old Password",
                              textStyle: CustomTextStyle(
                                  fontSize: 14.fss,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Gap(10.ss),
                        CommonTextFormField(
                            // onValueChanged: null,
                            onValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please old enter password";
                              } else if (!Utils().isValidPassword(value)) {
                                return "Please enter a valid password";
                              } else
                                return null;
                            },
                            textInputAction: TextInputAction.next,
                            controller: Provider.of<ManageProfileProvider>(
                                    context,
                                    listen: false)
                                .oldPasswordController,
                            obscureText: context
                                .watch<ManageProfileProvider>()
                                .isOldPasswordHidden,
                            fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                            textInputType: TextInputType.text,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Old Password",
                              counterText: "",
                              border: OutlineInputBorder(gapPadding: 1),
                              enabledBorder: OutlineInputBorder(gapPadding: 1),
                              focusedBorder: OutlineInputBorder(gapPadding: 1),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    context
                                            .watch<ManageProfileProvider>()
                                            .isOldPasswordHidden
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColor.BUTTON_COLOR,
                                    size: 24),
                                onPressed: () {
                                  if (context
                                      .read<ManageProfileProvider>()
                                      .isOldPasswordHidden) {
                                    context
                                        .read<ManageProfileProvider>()
                                        .isOldPasswordHidden = false;
                                    context
                                        .read<ManageProfileProvider>()
                                        .notifyListeners();
                                  } else {
                                    context
                                        .read<ManageProfileProvider>()
                                        .isOldPasswordHidden = true;
                                    context
                                        .read<ManageProfileProvider>()
                                        .notifyListeners();
                                  }
                                },
                              ),
                            )),
                        Gap(10.ss),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: CommonText(
                              text: "New Password",
                              textStyle: CustomTextStyle(
                                  fontSize: 14.fss,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Gap(10.ss),
                        CommonTextFormField(
                          onValidator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please new enter password";
                            } else if (!Utils().isValidPassword(value)) {
                              return "Please enter a valid password";
                            } else if (Provider.of<ManageProfileProvider>(
                                        context,
                                        listen: false)
                                    .oldPasswordController
                                    .text ==
                                value) {
                              return "Older and new password should be different";
                            } else
                              return null;
                          },
                          textInputAction: TextInputAction.next,
                          controller: Provider.of<ManageProfileProvider>(
                                  context,
                                  listen: false)
                              .newPassswordController,
                          obscureText: context
                              .watch<ManageProfileProvider>()
                              .isNewPasswordHidden,
                          textInputType: TextInputType.text,
                          fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                          decoration: InputDecoration(
                            hintText: "New Password",
                            counterText: "",
                            border: OutlineInputBorder(gapPadding: 1),
                            isDense: true,
                            // isDense: false,
                            // isCollapsed: true,
                            suffixIcon: IconButton(
                              icon: Icon(
                                  context
                                          .watch<ManageProfileProvider>()
                                          .isNewPasswordHidden
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColor.BUTTON_COLOR,
                                  size: 24),
                              onPressed: () {
                                if (context
                                    .read<ManageProfileProvider>()
                                    .isNewPasswordHidden) {
                                  context
                                      .read<ManageProfileProvider>()
                                      .isNewPasswordHidden = false;
                                  context
                                      .read<ManageProfileProvider>()
                                      .notifyListeners();
                                } else {
                                  context
                                      .read<ManageProfileProvider>()
                                      .isNewPasswordHidden = true;
                                  context
                                      .read<ManageProfileProvider>()
                                      .notifyListeners();
                                }
                              },
                            ),
                            enabledBorder: OutlineInputBorder(gapPadding: 1),
                            focusedBorder: OutlineInputBorder(gapPadding: 1),
                          ),
                        ),
                        Gap(5.ss),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.ss),
                          child: CommonText(
                              text: PasswordRule,
                              textStyle: CustomTextStyle(
                                  fontSize: 10.fss, color: AppColor.GERY)),
                        ),
                        Gap(10.ss),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: CommonText(
                              text: "Confirm Password",
                              textStyle: CustomTextStyle(
                                  fontSize: 14.fss,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Gap(10.ss),
                        CommonTextFormField(
                            textInputAction: TextInputAction.done,
                            textInputType: TextInputType.text,
                            controller: Provider.of<ManageProfileProvider>(
                                    context,
                                    listen: false)
                                .confirmPasswordController,
                            obscureText: context
                                .watch<ManageProfileProvider>()
                                .isConfirmPasswordHidden,
                            onValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please confirm enter password";
                              } else if (!Utils().isValidPassword(value)) {
                                return "Please enter a valid password";
                              } else if (Provider.of<ManageProfileProvider>(
                                          context,
                                          listen: false)
                                      .oldPasswordController
                                      .text ==
                                  value) {
                                return "Older and new password should be different";
                              } else if (Provider.of<ManageProfileProvider>(
                                          context,
                                          listen: false)
                                      .newPassswordController
                                      .text !=
                                  value) {
                                return "New and confirm password should be same";
                              } else
                                return null;
                            },
                            fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                            decoration: InputDecoration(
                              isDense: true,
                              suffixIcon: IconButton(
                                icon: Icon(
                                    context
                                            .watch<ManageProfileProvider>()
                                            .isConfirmPasswordHidden
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColor.BUTTON_COLOR,
                                    size: 24),
                                onPressed: () {
                                  if (context
                                      .read<ManageProfileProvider>()
                                      .isConfirmPasswordHidden) {
                                    context
                                        .read<ManageProfileProvider>()
                                        .isConfirmPasswordHidden = false;
                                    context
                                        .read<ManageProfileProvider>()
                                        .notifyListeners();
                                  } else {
                                    context
                                        .read<ManageProfileProvider>()
                                        .isConfirmPasswordHidden = true;
                                    context
                                        .read<ManageProfileProvider>()
                                        .notifyListeners();
                                  }
                                },
                              ),
                              hintText: "Confirm Password",
                              counterText: "",
                              border: OutlineInputBorder(gapPadding: 1),
                              // isDense: false,
                              // isCollapsed: true,

                              enabledBorder: OutlineInputBorder(gapPadding: 1),
                              focusedBorder: OutlineInputBorder(gapPadding: 1),
                            )),
                        Gap(30.ss),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: InkWell(
                              onTap: () {
                                // Fluttertoast.showToast(msg: "Clicked");
                                //showMyDialog(context);
                                //  context.go(Routes.VERIFY_OTP, arguments: {'phno': "9064818788"});
                                controller.validitionChangePassword(context);
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
