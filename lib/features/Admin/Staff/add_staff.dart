import 'dart:developer';

import 'package:bizfns/core/widgets/common_dropdown.dart';
import 'package:bizfns/core/widgets/common_text_form_field.dart';
import 'package:bizfns/features/Admin/Staff/provider/staff_provider.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/route/RouteConstants.dart';
import '../../../../core/utils/colour_constants.dart';
import '../../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/model/dropdown_model.dart';
import '../../../core/utils/Utils.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/widgets/common_text.dart';

class AddStaff extends StatefulWidget {
  final bool? isEdit;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? rate;
  final String? staffId;
  final String? staffType;
  final String? friquencyId;
  final int? activeStatus;
  const AddStaff(
      {super.key,
      this.firstName,
      this.isEdit,
      this.lastName,
      this.email,
      this.phone,
      this.rate,
      this.staffId,
      this.friquencyId,
      this.activeStatus, 
      this.staffType});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await callFunc();
    });

    // WidgetsBinding.instance.addPostFrameCallback((_){

    // });

    // initializeText();
    // setState(() {});
    super.initState();
  }

  callFunc() async {
    await Provider.of<StaffProvider>(context, listen: false)
        .getPreStaffCreationData(
            frequencyID: widget.friquencyId ?? '',
            context: context,
            staffType: widget.staffType ?? '',
            firstName: widget.firstName ?? "",
            lastName: widget.lastName ?? "",
            email: widget.email ?? "",
            phone: widget.phone ?? "",
            rate: widget.rate ?? "",
            activeStatus: widget.activeStatus);
    //     .then((value) {
    //       print("staffTypeList----->${context
    //     .read<StaffProvider>().staffTypeDetailsList.length}");
    //   initializeText();
    // });
  }

  initializeText() async {
    if (widget.isEdit == true) {
      Provider.of<StaffProvider>(context, listen: false)
          .firstNameController
          .text = widget.firstName ?? "";
      Provider.of<StaffProvider>(context, listen: false)
          .lastNameController
          .text = widget.lastName ?? "";
      Provider.of<StaffProvider>(context, listen: false).emailController.text =
          widget.email ?? "";
      Provider.of<StaffProvider>(context, listen: false).phoneController.text =
          widget.phone ?? "";
      print("widget.stafftype : ${widget.staffId}");

      // staffTy

      // Provider.of<StaffProvider>(context, listen: false).selectedStaffType = Provider.of<StaffProvider>(context, listen: false).staffTypeList.firstWhere((element) => element.id.toString().contains(widget.staffId.toString()));
      setState(() {});
      // setState(() {

      // });

      // setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<StaffProvider>(context, listen: false);
    print(GoRouter.of(context).routerDelegate.currentConfiguration.fullPath);
    return SafeArea(
        child: Scaffold(
      /*appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.BUTTON_COLOR,
        leading: InkWell(
          onTap: (){
            context.pop();
            //Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: CommonText(
          text: "Add Staff",
          textStyle: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
      ),*/
      body: SingleChildScrollView(
        child: context.watch<StaffProvider>().loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: provider.formKey,
                child: Padding(
                  padding: EdgeInsets.all(8.0.ss),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Gap(10.ss),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(''),
                          Visibility(
                            visible: widget.activeStatus != null,
                            child: Row(
                              children: [
                                Text(
                                  'Active Status :',
                                  style: CustomTextStyle(
                                      fontSize: 14.fss,
                                      fontWeight: FontWeight.w700),
                                ),
                                Switch(
                                  value: provider.isSwitched,
                                  onChanged: provider.toggleSwitch,
                                  activeTrackColor: Colors.lightGreenAccent,
                                  activeColor: Colors.green,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap(5.ss),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                        child: CommonText(
                          text: "First name ",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Gap(5.ss),
                      CommonTextFormField(
                        fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                        controller: provider.firstNameController,
                        onValidator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'Please enter first name';
                          // }
                          // return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(gapPadding: 1),
                          enabledBorder: OutlineInputBorder(gapPadding: 1),
                          focusedBorder: OutlineInputBorder(gapPadding: 1),
                          hintText: "First Name ",
                          isDense: true,
                        ),
                      ),
                      Gap(20.ss),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                        child: CommonText(
                          text: "Last name *",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Gap(5.ss),
                      CommonTextFormField(
                        controller: provider.lastNameController,
                        fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                        onValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(gapPadding: 1),
                          enabledBorder: OutlineInputBorder(gapPadding: 1),
                          focusedBorder: OutlineInputBorder(gapPadding: 1),
                          hintText: "Last Name ",
                          isDense: true,
                        ),
                      ),
                      Gap(20.ss),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                        child: CommonText(
                          text: "Email Id ",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Gap(5.ss),
                      CommonTextFormField(
                        controller: provider.emailController,
                        textInputType: TextInputType.emailAddress,
                        fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                        onValidator: (value) {
                          if (value != null &&
                              !value.isEmpty &&
                              value.isNotEmpty &&
                              !Utils.IsValidEmail(value)) {
                            return "Please enter a valid email id";
                          } else
                            return null;
                        },
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: "Email Address ",
                          border: OutlineInputBorder(gapPadding: 1),
                          enabledBorder: OutlineInputBorder(gapPadding: 1),
                          focusedBorder: OutlineInputBorder(gapPadding: 1),
                        ),
                      ),
                      Gap(20.ss),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                        child: CommonText(
                          text: "Mobile Number *",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Gap(5.ss),
                      CommonTextFormField(
                          controller: provider.phoneController,
                          textInputType: TextInputType.phone,
                          fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                          onValidator: (value) {
                            if (value != null && value.isEmpty) {
                              return "Please enter 10 digit mobile no";
                            } else if (value != null &&
                                !value.isEmpty &&
                                value.length < 14) {
                              return "Please enter 10 digit mobile no";
                            } else
                              return null;
                          },
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            MaskTextInputFormatter(
                                mask: '(###) ###-####',
                                filter: {"#": RegExp(r'[0-9]')},
                                type: MaskAutoCompletionType.lazy),
                          ],
                          maxLength: 14,
                          decoration: InputDecoration(
                            hintText: "Mobile Number",
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
                          text: "Staff Type *",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Gap(8.ss),
                      CommonDropdown(
                        options: context.watch<StaffProvider>().staffTypeList,
                        selectedValue:
                            context.watch<StaffProvider>().selectedStaffType,
                        onChange: (value) {
                          context.read<StaffProvider>().selectedStaffType =
                              value;
                          context.read<StaffProvider>().notifyListeners();
                        },
                      ),
                      Gap(20.ss),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                        child: CommonText(
                          text: "Enter Rate *",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Gap(5.ss),
                      Row(
                        children: [
                          CommonTextFormField(
                            width:
                                (MediaQuery.of(context).size.width / 2) - 20.ss,
                            controller: provider.rateController,
                            textInputType: TextInputType.number,
                            fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                            onValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Staff Rate';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                isDense: true,
                                border: OutlineInputBorder(gapPadding: 1),
                                enabledBorder:
                                    OutlineInputBorder(gapPadding: 1),
                                focusedBorder:
                                    OutlineInputBorder(gapPadding: 1),
                                hintText: "Staff Rate ",
                                prefixIcon: Icon(
                                  Icons.attach_money_outlined,
                                  color: AppColor.APP_BAR_COLOUR,
                                )),
                          ),
                          CommonText(
                            text: "/",
                          ),
                          CommonDropdown(
                            height: 50.ss,
                            width: (MediaQuery.of(context).size.width / 2) - 30,
                            options:
                                context.watch<StaffProvider>().frequencyList,
                            selectedValue: context
                                .watch<StaffProvider>()
                                .selectedFrequency,
                            onChange: (value) {
                              context.read<StaffProvider>().selectedFrequency =
                                  value;
                              context.read<StaffProvider>().notifyListeners();
                            },
                          ),
                        ],
                      ),
                      Gap(20.ss),
                      widget.isEdit == null
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.0.ss),
                              child: InkWell(
                                  onTap: () {
                                    if (provider.formKey.currentState!
                                        .validate()) {
                                      provider.formKey.currentState!.save();
                                    } else {
                                      provider.notifyListeners();
                                    }
                                    provider.validity(
                                        context,
                                        provider.firstNameController.text
                                            .trim(),
                                        provider.lastNameController.text.trim(),
                                        provider.emailController.text.trim(),
                                        provider.phoneController.text.trim(),
                                        false,
                                        widget.staffId);
                                  },
                                  child: CustomButton(title: "Submit")),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.0.ss),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          if (provider.formKey.currentState!
                                              .validate()) {
                                            provider.formKey.currentState!
                                                .save();
                                          } else {
                                            provider.notifyListeners();
                                          }
                                          provider.validity(
                                              context,
                                              provider.firstNameController.text
                                                  .trim(),
                                              provider.lastNameController.text
                                                  .trim(),
                                              provider.emailController.text
                                                  .trim(),
                                              provider.phoneController.text
                                                  .trim(),
                                              true,
                                              widget.staffId);
                                        },
                                        child: CustomButton(
                                            btnColor: Colors.green.shade700,
                                            title: "Update")),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          //delete will here
                                          showCupertinoDialog(
                                              context: context,
                                              builder: (_) {
                                                return CupertinoAlertDialog(
                                                  content: const Text(
                                                    'Are you sure, you want to delete the Staff?',
                                                    style: TextStyle(
                                                      color: Color(0xff093d52),
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  actions: [
                                                    CupertinoButton(
                                                      child: const Text(
                                                        'Yes, Delete',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        //-----Delete will be here----//
                                                        Provider.of<StaffProvider>(
                                                                context,
                                                                listen: false)
                                                            .deleteStaff(
                                                          context: context,
                                                          staffPhoneNo: widget
                                                              .phone
                                                              .toString(),
                                                        );

                                                        context.pop();
                                                        setState(() {});
                                                      },
                                                    ),
                                                    CupertinoButton(
                                                      child: const Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                      onPressed: () {
                                                        context.pop();
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: CustomButton(
                                            btnColor: Colors.red.shade300,
                                            title: "Delete")),
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              ),
      ),
    ));
  }
}

// class ToggleSwitch extends StatefulWidget {
//   const ToggleSwitch({super.key});

//   @override
//   _ToggleSwitchState createState() => _ToggleSwitchState();
// }

// class _ToggleSwitchState extends State<ToggleSwitch> {
  

//   @override
//   Widget build(BuildContext context) {
//     return Switch(
//       value: isSwitched,
//       onChanged: _toggleSwitch,
//       activeTrackColor: Colors.lightGreenAccent,
//       activeColor: Colors.green,
//     );
//   }
// }
