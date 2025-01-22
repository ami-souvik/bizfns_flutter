import 'package:bizfns/core/widgets/common_text_form_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../../core/utils/Utils.dart';
import '../../../core/utils/alert_dialog.dart';
import '../../../core/utils/colour_constants.dart';
import '../../../core/utils/const.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/widgets/common_text.dart';
import '../../Admin/Staff/provider/staff_provider.dart';
import '../Login/provider/login_provider.dart';

class StaffLogin extends StatefulWidget {
  const StaffLogin({super.key});

  @override
  State<StaffLogin> createState() => _StaffLoginState();
}

class _StaffLoginState extends State<StaffLogin> {
  final ScrollController listController = ScrollController();
  // TextEditingController userId = TextEditingController();
  // TextEditingController tenantId = TextEditingController();
  // TextEditingController email = TextEditingController();
  // TextEditingController tempoPassword = TextEditingController();
  // TextEditingController confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<StaffProvider>(context, listen: false).initialController();
  }

  @override
  Widget build(BuildContext context) {
    // var controller = Provider.of<LoginProvider>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFf4feff),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height / 6,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/images/login_bottom_background.png",
                width: size.width, // Adjust the width as needed
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Form(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    kIsWeb ? MediaQuery.of(context).size.width / 4 : 0.0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.ss),
              child: ListView(
                shrinkWrap: true,
                // controller: listController,
                // physics: const ClampingScrollPhysics(),
                children: [
                  Gap(MediaQuery.of(context).size.height / 15.ss),
                  Padding(
                    padding: EdgeInsets.all(8.0.ss),
                    child: SizedBox(
                      height: 88.ss,
                      child: Center(
                        child: Image.asset("assets/images/logo.png"),
                      ),
                    ),
                  ),
                  Gap(45.ss),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: CommonText(
                      text: "Please Set Your Password",
                      textStyle: CustomTextStyle(
                          fontSize: 24.fss, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Gap(20.ss),
                  Padding(
                    padding: EdgeInsets.only(right: 8.0.ss, top: 0.ss),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                          child: CommonText(
                              text: "User Id",
                              textStyle: CustomTextStyle(
                                  fontSize: 14.fss,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  Gap(5.ss),
                  CommonTextFormField(
                    readOnly: true,
                    controller:
                        Provider.of<LoginProvider>(context, listen: false)
                            .userIdController,
                    // textInputType: TextInputType.phone,
                    onChanged: (val) async {
                      // controller
                      //     .changeDropDownOption(context);
                      // if (val!.length >= 10) {
                      //   await controller
                      //       .getBusinessId(context);
                      // }
                    },
                    onSave: (val) async {
                      // await controller.getBusinessId(context);
                    },
                    onValueChanged: (val) async {
                      // if (val.length >= 10) {
                      //   await controller.getBusinessId(context);
                      // }
                    },
                    // textInputAction: TextInputAction.next,
                    // onValidator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return "Please enter user Id";
                    //   } else {
                    //     return null;
                    //   }
                    // },
                    fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                    decoration: const InputDecoration(
                      hintText: "Registered Staff mobile no",
                      border: OutlineInputBorder(gapPadding: 1),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(gapPadding: 1),
                      focusedBorder: OutlineInputBorder(gapPadding: 1),
                    ),
                  ),
                  Gap(5.ss),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                  //   child: CommonText(
                  //       text: "Tenant Id",
                  //       textStyle: CustomTextStyle(
                  //           fontSize: 14.fss, fontWeight: FontWeight.w700)),
                  // ),
                  // Gap(5.ss),
                  // CommonTextFormField(
                  //   controller: tenantId,
                  //   textInputType: TextInputType.name,
                  //   onChanged: (val) async {
                  //     // controller
                  //     //     .changeDropDownOption(context);
                  //     // if (val!.length >= 10) {
                  //     //   await controller
                  //     //       .getBusinessId(context);
                  //     // }
                  //   },
                  //   onSave: (val) async {
                  //     // await controller.getBusinessId(context);
                  //   },
                  //   onValueChanged: (val) async {
                  //     // if (val.length >= 10) {
                  //     //   await controller.getBusinessId(context);
                  //     // }
                  //   },
                  //   textInputAction: TextInputAction.next,
                  //   onValidator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return "Please enter correct Tenant Id";
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  //   fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                  //   decoration: const InputDecoration(
                  //     hintText: "Please enter correct Tenant Id",
                  //     border: OutlineInputBorder(gapPadding: 1),
                  //     isDense: true,
                  //     enabledBorder: OutlineInputBorder(gapPadding: 1),
                  //     focusedBorder: OutlineInputBorder(gapPadding: 1),
                  //   ),
                  // ),
                  // Gap(5.ss),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                  //   child: CommonText(
                  //       text: "Staff Email",
                  //       textStyle: CustomTextStyle(
                  //           fontSize: 14.fss, fontWeight: FontWeight.w700)),
                  // ),
                  // Gap(5.ss),
                  // CommonTextFormField(
                  //   controller: email,
                  //   textInputType: TextInputType.name,
                  //   onChanged: (val) async {
                  //     // controller
                  //     //     .changeDropDownOption(context);
                  //     // if (val!.length >= 10) {
                  //     //   await controller
                  //     //       .getBusinessId(context);
                  //     // }
                  //   },
                  //   onSave: (val) async {
                  //     // await controller.getBusinessId(context);
                  //   },
                  //   onValueChanged: (val) async {
                  //     // if (val.length >= 10) {
                  //     //   await controller.getBusinessId(context);
                  //     // }
                  //   },
                  //   textInputAction: TextInputAction.next,
                  //   onValidator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return "Please enter correct Tenant Id";
                  //     } else {
                  //       return null;
                  //     }
                  //   },
                  //   fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                  //   decoration: const InputDecoration(
                  //     hintText: "Please enter staff Email",
                  //     border: OutlineInputBorder(gapPadding: 1),
                  //     isDense: true,
                  //     enabledBorder: OutlineInputBorder(gapPadding: 1),
                  //     focusedBorder: OutlineInputBorder(gapPadding: 1),
                  //   ),
                  // ),
                  Gap(5.ss),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                    child: Row(
                      children: [
                        CommonText(
                          text: "Temporary Password",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700),
                        ),
                        Gap(20.ss),
                        InkWell(
                            onTap: () {
                              ShowDialog(
                                  context: context,
                                  title: "Password rules",
                                  msg: PasswordRuleForDialog);
                            },
                            child: ImageIcon(
                              AssetImage(
                                  'assets/images/information_button.png'),
                              size: 16,
                              color: AppColor.APP_BAR_COLOUR,
                            ))
                      ],
                    ),
                  ),
                  Gap(5.ss),
                  CommonTextFormField(
                      obscureText: context
                          .watch<StaffProvider>()
                          .isTemporaryPasswordHidden,
                      controller:
                          Provider.of<StaffProvider>(context, listen: false)
                              .tempoPassword,
                      textInputAction: TextInputAction.done,
                      // controller: Provider.of<LoginProvider>(
                      //         context,
                      //         listen: false)
                      //     .passwordController,
                      // onValidator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "Please enter password";
                      //   } else if (!Utils().isValidPassword(value)) {
                      //     return "Please enter a valid password";
                      //   } else
                      //     return null;
                      // },
                      fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                      // obscureText: context
                      //     .watch<LoginProvider>()
                      //     .isPasswordHidden,
                      decoration: InputDecoration(
                        hintText: "Enter Temorary Password",
                        border: OutlineInputBorder(gapPadding: 1),
                        // isCollapsed: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                              context
                                      .watch<StaffProvider>()
                                      .isTemporaryPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColor.BUTTON_COLOR,
                              size: 24),
                          onPressed: () {
                            if (context
                                .read<StaffProvider>()
                                .isTemporaryPasswordHidden) {
                              context
                                  .read<StaffProvider>()
                                  .isTemporaryPasswordHidden = false;
                              context.read<StaffProvider>().notifyListeners();
                            } else {
                              context
                                  .read<StaffProvider>()
                                  .isTemporaryPasswordHidden = true;
                              context.read<StaffProvider>().notifyListeners();
                            }
                          },
                        ),
                        isDense: true,
                        //
                        enabledBorder: OutlineInputBorder(gapPadding: 1),
                        focusedBorder: OutlineInputBorder(gapPadding: 1),
                      )),
                  Gap(5.ss),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                    child: Row(
                      children: [
                        CommonText(
                          text: "New Password",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700),
                        ),
                        Gap(20.ss),
                        InkWell(
                            onTap: () {
                              ShowDialog(
                                  context: context,
                                  title: "Password rules",
                                  msg: PasswordRuleForDialog);
                            },
                            child: ImageIcon(
                              AssetImage(
                                  'assets/images/information_button.png'),
                              size: 16,
                              color: AppColor.APP_BAR_COLOUR,
                            ))
                      ],
                    ),
                  ),
                  Gap(5.ss),
                  CommonTextFormField(
                      controller:
                          Provider.of<StaffProvider>(context, listen: false)
                              .confirmPassword,
                      textInputAction: TextInputAction.done,
                      // controller: Provider.of<LoginProvider>(
                      //         context,
                      //         listen: false)
                      //     .passwordController,
                      // onValidator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return "Please enter password";
                      //   } else if (!Utils().isValidPassword(value)) {
                      //     return "Please enter a valid password";
                      //   } else
                      //     return null;
                      // },
                      fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                      obscureText:
                          context.watch<LoginProvider>().isPasswordHidden,
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        border: OutlineInputBorder(gapPadding: 1),
                        // isCollapsed: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                              context.watch<LoginProvider>().isPasswordHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColor.BUTTON_COLOR,
                              size: 24),
                          onPressed: () {
                            if (context
                                .read<LoginProvider>()
                                .isPasswordHidden) {
                              context.read<LoginProvider>().isPasswordHidden =
                                  false;
                              context.read<LoginProvider>().notifyListeners();
                            } else {
                              context.read<LoginProvider>().isPasswordHidden =
                                  true;
                              context.read<LoginProvider>().notifyListeners();
                            }
                          },
                        ),
                        isDense: true,
                        //
                        enabledBorder: OutlineInputBorder(gapPadding: 1),
                        focusedBorder: OutlineInputBorder(gapPadding: 1),
                      )),
                  Gap(10.ss),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0.ss),
                    child: InkWell(
                        onTap: () async {
                          Provider.of<StaffProvider>(context, listen: false)
                              .validateReturn(context)
                              .then((value) async {
                            if (value == true) {
                              await Provider.of<StaffProvider>(context,
                                      listen: false)
                                  .staffUserLogin(
                                context: context,
                                // temporaryPassword: tempoPassword.text,
                                // newPassword: confirmPassword.text,
                              );
                            }
                          });
                        },
                        child: const CustomButton(title: "Set Password")),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
