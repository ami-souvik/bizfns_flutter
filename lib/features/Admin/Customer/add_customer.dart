import 'dart:developer';

import 'package:bizfns/core/widgets/common_text_form_field.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/add_schedule_model.dart';
import 'package:bizfns/features/Admin/Customer/provider/customer_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/route/RouteConstants.dart';
import '../../../../core/utils/colour_constants.dart';
import '../../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/utils/Utils.dart';
import '../../../core/utils/bizfns_layout_widget.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/widgets/common_text.dart';
import '../../../provider/job_schedule_controller.dart';
import '../Create Job/ScheduleJobPages/service_entity.dart';

class AddCustomer extends StatefulWidget {
  final bool? isEdit;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobile;
  final String? companyAdress;
  final int? acticeStatus;
  final int? customerId;
  final String? companyName;

  const AddCustomer(
      {Key? key,
      this.firstName,
      this.lastName,
      this.email,
      this.mobile,
      this.isEdit,
      this.acticeStatus,
      this.customerId,
      this.companyAdress,
      this.companyName})
      : super(key: key);

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final AddScheduleModel _model = AddScheduleModel.addSchedule;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _companyNameController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await callServiceEntityList();
    });
    initialController();

    Provider.of<CustomerProvider>(context, listen: false)
        .getCustomerList(context);
    log("WIDGET>ACTIVESTATUS : >>>>${widget.acticeStatus}");
    Provider.of<CustomerProvider>(context, listen: false)
        .initializeSwith(activeStatus: widget.acticeStatus);
    //
    if (widget.isEdit != null) {
      print("Getting customer id => ${widget.customerId.toString()}");
    }
    if (widget.isEdit == null) {}
    log("service entity list : ${Provider.of<CustomerProvider>(context, listen: false).customerServiceEntity.length}");
    super.initState();
  }

  callServiceEntityList() async {
    if (widget.isEdit == null) {
      Provider.of<CustomerProvider>(context, listen: false)
          .customerServiceEntity
          .clear();
      // if (widget.customerId != null) {
      //   Provider.of<CustomerProvider>(context, listen: false)
      //       .customerServiceEntity
      //       .clear();
      //   await Provider.of<CustomerProvider>(context, listen: false)
      //       .getCustomerServiceEntity(context,
      //           customerID: widget.customerId.toString());
      //   // setState(() {});
      // }
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("did change dependency called");
    // Provider.of<CustomerProvider>(context, listen: false)
    //     .getCustomerServiceEntity(context,
    //         customerID: widget.customerId.toString());
  }

  initialController() {
    widget.firstName != null
        ? _firstNameController.text = widget.firstName!
        : _firstNameController.text = "";
    widget.lastName != null
        ? _lastNameController.text = widget.lastName!
        : _lastNameController.text = "";
    widget.email != null
        ? _emailController.text = widget.email!
        : _emailController.text = "";
    widget.mobile != null
        ? _phoneController.text = maskFormatter.maskText(widget.mobile!)
        : _phoneController.text = "";
    widget.companyAdress != null
        ? _addressController.text = widget.companyAdress!
        : _addressController.text = "";
    widget.companyName != null
        ? _companyNameController.text = widget.companyName!
        : _companyNameController.text = "";
  }

  final maskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    var provider = Provider.of<CustomerProvider>(context, listen: false);

    // callServiceEntityList();

    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        Provider.of<TitleProvider>(context, listen: false).changeTitle('Admin');
        return true;
      },
      child: Scaffold(
        /*appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.BUTTON_COLOR,
          leading: InkWell(
            onTap: (){
              context.pop();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: CommonText(
            text: "Add Customer",
            textStyle: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
              ),*/
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(8.0.ss),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Gap(10.ss),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(''),
                          Visibility(
                            visible: widget.acticeStatus != null,
                            child: Row(
                              children: [
                                Text(
                                  'Active Status :',
                                  style: CustomTextStyle(
                                      fontSize: 14.fss,
                                      fontWeight: FontWeight.w700),
                                ),
                                Switch(
                                  value: Provider.of<CustomerProvider>(context,
                                          listen: false)
                                      .isSwitched,
                                  onChanged: (value) {
                                    print(
                                        "OnChange Value is widget : ${value}");
                                    Provider.of<CustomerProvider>(context,
                                            listen: false)
                                        .toggleSwitch(value);
                                    setState(() {});
                                  },
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
                      CommonTextFormField(
                        fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                        controller: _firstNameController,
                        // onValidator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter first name';
                        //   }
                        //   return null;
                        // },
                        decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(gapPadding: 1),
                            enabledBorder: OutlineInputBorder(gapPadding: 1),
                            focusedBorder: OutlineInputBorder(gapPadding: 1),
                            hintText: "First Name"),
                      ),
                      Gap(10.ss),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                        child: CommonText(
                          text: "Last name *",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700),
                        ),
                      ),
                      CommonTextFormField(
                        fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                        controller: _lastNameController,
                        onValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter last name';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(gapPadding: 1),
                            enabledBorder: OutlineInputBorder(gapPadding: 1),
                            focusedBorder: OutlineInputBorder(gapPadding: 1),
                            hintText: "Last Name"),
                      ),
                      Gap(10.ss),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                        child: CommonText(
                          text: "Company name ",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700),
                        ),
                      ),
                      CommonTextFormField(
                        fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                        controller: _companyNameController,
                        // onValidator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter first name';
                        //   }
                        //   return null;
                        // },
                        decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(gapPadding: 1),
                            enabledBorder: OutlineInputBorder(gapPadding: 1),
                            focusedBorder: OutlineInputBorder(gapPadding: 1),
                            hintText: "Company Name"),
                      ),
                      Gap(10.ss),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                        child: CommonText(
                          text: "Address",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: CommonTextFormField(
                          maxLine: 5,
                          fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                          controller: _addressController,
                          // onValidator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter first name';
                          //   }
                          //   return null;
                          // },
                          decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(gapPadding: 1),
                              enabledBorder: OutlineInputBorder(gapPadding: 1),
                              focusedBorder: OutlineInputBorder(gapPadding: 1),
                              hintText: "Address "),
                        ),
                      ),
                      Gap(10.ss),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                        child: CommonText(
                          text: "Email Id",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700),
                        ),
                      ),
                      CommonTextFormField(
                        fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                        controller: _emailController,
                        textInputType: TextInputType.emailAddress,
                        /*onValidator: (value) {
                          if (value != null &&
                              !value.isEmpty &&
                              value.isNotEmpty &&
                              !Utils.IsValidEmail(value)) {
                            return "Please enter a valid email id";
                          } else
                            return null;
                        },*/
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: "Email Id",
                          border: OutlineInputBorder(gapPadding: 1),
                          enabledBorder: OutlineInputBorder(gapPadding: 1),
                          focusedBorder: OutlineInputBorder(gapPadding: 1),
                        ),
                      ),
                      Gap(10.ss),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                        child: CommonText(
                          text: "Mobile Number *",
                          textStyle: CustomTextStyle(
                              fontSize: 14.fss, fontWeight: FontWeight.w700),
                        ),
                      ),
                      CommonTextFormField(
                        fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                        controller: _phoneController,
                        textInputType: TextInputType.phone,
                        onValidator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Please enter 10 digit mobile no";
                          } else if (value != null &&
                              !value.isEmpty &&
                              value.length < 14) {
                            return "Please enter 10 digit mobile no";
                          } else {
                            return null;
                          }
                        },
                        inputFormatters: [
                          MaskTextInputFormatter(
                              mask: '(###) ###-####',
                              filter: {"#": RegExp(r'[0-9]')},
                              type: MaskAutoCompletionType.lazy),
                        ],
                        maxLength: 14,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            counterText: "",
                            isDense: true,
                            border: OutlineInputBorder(gapPadding: 1),
                            enabledBorder: OutlineInputBorder(gapPadding: 1),
                            focusedBorder: OutlineInputBorder(gapPadding: 1),
                            hintText: "Mobile Number"),
                      ),
                      Gap(10.ss),
                      Visibility(
                        visible: widget.isEdit != null,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Your onPressed code here!
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                      child: StatefulBuilder(
                                        builder: (_, StateSetter setter) {
                                          return ServiceEntityWidget(
                                            customerName:
                                                '${_firstNameController.text} ${_lastNameController.text}',
                                            phoneNumber:
                                                '${_phoneController.text}',
                                            hasDetails: false,
                                            customerID:
                                                widget.customerId!.toString(),
                                            entityID: '',
                                            onEntityAdd: (val) async {
                                              Provider.of<TitleProvider>(
                                                      context,
                                                      listen: false)
                                                  .changeTitle('');
                                              await Provider.of<
                                                          CustomerProvider>(
                                                      context,
                                                      listen: false)
                                                  .getCustomerServiceEntity(
                                                context,
                                                customerID: widget.customerId!
                                                    .toString(),
                                              );

                                              Provider.of<CustomerProvider>(
                                                      context,
                                                      listen: false)
                                                  .addServiceEntity(
                                                      context,
                                                      widget.customerId!
                                                          .toString());

                                              // await Provider.of<CustomerProvider>(
                                              //         context,
                                              //         listen: false)
                                              //     .getCustomerServiceEntity(
                                              //   context,
                                              //   customerID: tempCustomerID,
                                              // );
                                              setState(() {});
                                            },
                                          );
                                        },
                                      ));
                                },
                              ).then((value) async {
                                await Provider.of<CustomerProvider>(context,
                                        listen: false)
                                    .getCustomerServiceEntity(
                                  context,
                                  customerID: widget.customerId!.toString(),
                                );
                                setState(() {});
                              });
                              // .then((value) async {
                              //   await Provider.of<CustomerProvider>(context,
                              //           listen: false)
                              //       .getCustomerServiceEntity(
                              //     context,
                              //     customerID: widget.customerId!.toString(),
                              //   );
                              //   setState(() {});
                              //   setState(() {});
                              // });
                            },
                            icon: Icon(Icons.add_circle_outline,
                                color: Colors.black), // Add icon
                            label: Text(
                              'Add Service Object',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30.0), // Rounded edges
                              ),
                              side: BorderSide(
                                  color: Colors.grey), // Grey border color
                              backgroundColor: Colors
                                  .grey[300], // Light grey background color
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 10.0), // Button padding
                            ),
                          ),
                        ),
                      ),
                      // ListView.builder(
                      //   itemBuilder: itemBuilder),
                      Visibility(
                        visible: Provider.of<CustomerProvider>(context,
                                listen: false)
                            .customerServiceEntity
                            .isNotEmpty,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            // height: Provider.of<CustomerProvider>(context,
                            //                 listen: false)
                            //             .customerServiceEntity
                            //             .length >
                            //         15
                            //     ? 500
                            //     : 0,
                            // height:  ,
                            // height: 100,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.0),
                                border: Border.all(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: Provider.of<CustomerProvider>(
                                          context,
                                          listen: false)
                                      .customerServiceEntity
                                      .asMap()
                                      .entries
                                      .map((e) {
                                    int index = e.key;
                                    var element = e.value;
                                    return Column(
                                      children: [
                                        Visibility(
                                            visible: index != 0,
                                            child: Divider(
                                              color: Colors.black,
                                            )),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              element.serviceentityname
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Provider.of<JobScheduleProvider>(
                                                            context,
                                                            listen: false)
                                                        .entityType = "Edit";

                                                    showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return Dialog(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                            ),
                                                            child:
                                                                StatefulBuilder(
                                                              builder: (_,
                                                                  StateSetter
                                                                      setter) {
                                                                return ServiceEntityWidget(
                                                                  hasDetails:
                                                                      true,
                                                                  customerID: widget
                                                                      .customerId!
                                                                      .toString(),
                                                                  entityID: element
                                                                      .pkserviceentityid!,
                                                                  customerName:
                                                                      '${_firstNameController.text} ${_lastNameController.text}',
                                                                  phoneNumber:
                                                                      '${_phoneController.text}',
                                                                  onEntityAdd:
                                                                      (val) async {
                                                                    Provider.of<TitleProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .changeTitle(
                                                                            '');
                                                                    await Provider.of<CustomerProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .getCustomerServiceEntity(
                                                                      context,
                                                                      customerID: widget
                                                                          .customerId!
                                                                          .toString(),
                                                                    );

                                                                    Provider.of<CustomerProvider>(context, listen: false).updateServiceEntity(
                                                                        context:
                                                                            context,
                                                                        customerID: widget
                                                                            .customerId
                                                                            .toString(),
                                                                        serviceEntityId: element
                                                                            .pkserviceentityid
                                                                            .toString());

                                                                    setState(
                                                                        () {});
                                                                  },
                                                                );
                                                              },
                                                            ));
                                                      },
                                                    ).then((value) async {
                                                      await Provider.of<
                                                                  CustomerProvider>(
                                                              context,
                                                              listen: false)
                                                          .getCustomerServiceEntity(
                                                        context,
                                                        customerID: widget
                                                            .customerId!
                                                            .toString(),
                                                      );
                                                      setState(() {});
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.black,
                                                    ),
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    //service object delete will be here

                                                    showCupertinoDialog(
                                                        context: context,
                                                        builder: (_) {
                                                          return CupertinoAlertDialog(
                                                            content: const Text(
                                                              'Are you sure, you want to delete the Service Object?',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xff093d52),
                                                                fontSize: 17,
                                                              ),
                                                            ),
                                                            actions: [
                                                              CupertinoButton(
                                                                child:
                                                                    const Text(
                                                                  'Yes, Delete',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  //-----Delete will be here----//
                                                                  await Provider.of<CustomerProvider>(context, listen: false).deleteServiceEntity(
                                                                      context:
                                                                          context,
                                                                      customerID: widget
                                                                          .customerId
                                                                          .toString(),
                                                                      serviceEntityId: element
                                                                          .pkserviceentityid
                                                                          .toString());
                                                                  setState(
                                                                      () {});
                                                                  context.pop(
                                                                      true);
                                                                },
                                                              ),
                                                              CupertinoButton(
                                                                child:
                                                                    const Text(
                                                                  'No',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                                onPressed: () {
                                                                  context.pop(
                                                                      false);
                                                                  // setState(
                                                                  //     () {});
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        }).then((value) async {
                                                      print("value : ${value}");
                                                      // if (value == true) {
                                                      await Provider.of<
                                                                  CustomerProvider>(
                                                              context,
                                                              listen: false)
                                                          .getCustomerServiceEntity(
                                                        context,
                                                        customerID: widget
                                                            .customerId!
                                                            .toString(),
                                                      );
                                                      setState(() {});
                                                      // }
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.black12,
                                                    ),
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 15,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                      //   child: Container(
                      //     height: 50,
                      //     ,
                      //   ),
                      // ),
                      Gap(10.ss),
                      widget.isEdit == null
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.0.ss),
                              child: InkWell(
                                onTap: () {
                                  /*provider.validity(
                                context,
                                _firstNameController.text.trim(),
                                _lastNameController.text.trim(),
                                _emailController.text.trim(),
                                _phoneController.text.trim(),
                              );*/
                                  if (_model.serviceEntity == null) {
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: StatefulBuilder(
                                              builder: (_, StateSetter setter) {
                                                return ServiceEntityWidget(
                                                  customerName:
                                                      '${_firstNameController.text} ${_lastNameController.text}',
                                                  phoneNumber:
                                                      '${_phoneController.text}',
                                                  hasDetails: false,
                                                  customerID: "",
                                                  entityID: "",
                                                  onEntityAdd: (val) {
                                                    GoRouter.of(context).pop();
                                                  },
                                                );
                                              },
                                            ));
                                      },
                                    );
                                  } else {
                                    provider.validity(
                                        context: context,
                                        customerId:
                                            widget.customerId.toString(),
                                        email: _emailController.text.trim(),
                                        firstName:
                                            _firstNameController.text.trim(),
                                        isEdit: widget.isEdit,
                                        lastName:
                                            _lastNameController.text.trim(),
                                        phone: _phoneController.text
                                            .trim()
                                            .replaceAll('(', '')
                                            .replaceAll(')', '')
                                            .replaceAll('-', '')
                                            .removeAllWhitespace,
                                        serviceEntity: _model.serviceEntity!,
                                        custCompanyName:
                                            _companyNameController.text.trim(),
                                        customerAddress:
                                            _addressController.text.trim()
                                        // context,
                                        // _firstNameController.text.trim(),
                                        // _lastNameController.text.trim(),
                                        // _emailController.text.trim(),
                                        // _phoneController.text
                                        //     .trim()
                                        //     .replaceAll('(', '')
                                        //     .replaceAll(')', '')
                                        //     .replaceAll('-', '')
                                        //     .removeAllWhitespace,
                                        // _model.serviceEntity!,
                                        );
                                  }
                                },
                                child: CustomButton(
                                    title: _model.serviceEntity == null
                                        ? "Proceed"
                                        : "Save"),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0.0.ss),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        provider.validity(
                                            context: context,
                                            customerId:
                                                widget.customerId.toString(),
                                            email: _emailController.text.trim(),
                                            firstName: _firstNameController.text
                                                .trim(),
                                            isEdit: widget.isEdit,
                                            lastName:
                                                _lastNameController.text.trim(),
                                            custCompanyName:
                                                _companyNameController.text
                                                    .trim(),
                                            customerAddress:
                                                _addressController.text.trim(),
                                            phone: _phoneController.text
                                                .trim()
                                                .replaceAll('(', '')
                                                .replaceAll(')', '')
                                                .replaceAll('-', '')
                                                .removeAllWhitespace,
                                            serviceEntity: {}

                                            // context,
                                            // _firstNameController.text.trim(),
                                            // _lastNameController.text.trim(),
                                            // _emailController.text.trim(),
                                            // _phoneController.text
                                            //     .trim()
                                            //     .replaceAll('(', '')
                                            //     .replaceAll(')', '')
                                            //     .replaceAll('-', '')
                                            //     .removeAllWhitespace,
                                            // _model.serviceEntity!,
                                            );
                                        /*provider.validity(
                                      context,
                                      _firstNameController.text.trim(),
                                      _lastNameController.text.trim(),
                                      _emailController.text.trim(),
                                      _phoneController.text.trim(),
                                    );*/
                                        // if (_model.serviceEntity == null) {
                                        //   showDialog(
                                        //     context: context,
                                        //     builder: (_) {
                                        //       return Dialog(
                                        //           shape: RoundedRectangleBorder(
                                        //             borderRadius:
                                        //                 BorderRadius.circular(12.0),
                                        //           ),
                                        //           child: StatefulBuilder(
                                        //             builder: (_, StateSetter setter) {
                                        //               return ServiceEntityWidget(
                                        //                 hasDetails: false,
                                        //                 customerID: "",
                                        //                 entityID: "",
                                        //                 onEntityAdd: (val) {
                                        //                   GoRouter.of(context).pop();
                                        //                 },
                                        //               );
                                        //             },
                                        //           ));
                                        //     },
                                        //   );
                                        // } else {

                                        // }
                                      },
                                      child: CustomButton(
                                        title: "Update",
                                        btnColor: Colors.green.shade700,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                        onTap: () {
                                          showCupertinoDialog(
                                              context: context,
                                              builder: (_) {
                                                return CupertinoAlertDialog(
                                                  content: const Text(
                                                    'Are you sure, you want to delete the Customer?',
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
                                                        Provider.of<CustomerProvider>(
                                                                context,
                                                                listen: false)
                                                            .deleteCustomer(
                                                          context: context,
                                                          customerId: widget
                                                              .customerId
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

                                          //         context: context);
                                        },
                                        child: CustomButton(
                                          title: "Delete",
                                          btnColor: Colors.red.shade300,
                                        )),
                                  )
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
