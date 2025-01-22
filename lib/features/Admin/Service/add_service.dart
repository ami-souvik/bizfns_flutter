import 'package:bizfns/features/Admin/Service/provider/service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';
import '../../../core/utils/colour_constants.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../core/widgets/common_dropdown.dart';
import '../../../core/widgets/common_text.dart';
import '../../../core/widgets/common_text_form_field.dart';

class AddService extends StatefulWidget {
  final bool? isEdit;
  final String? serviceName;
  final String? serviceRate;
  final String? serviceUnit;
  final String? serviceId;
  final int? activeStatus;
  const AddService({
    super.key,
    this.isEdit,
    this.serviceName,
    this.serviceRate,
    this.serviceUnit,
    this.serviceId,
    this.activeStatus,
  });
  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _serviceNameController = TextEditingController();
  TextEditingController _rateController = TextEditingController();

  @override
  void initState() {
    intializeController();
    Provider.of<ServiceProvider>(context, listen: false).getServiceUnitList(
      context,
      widget.activeStatus,
      widget.serviceUnit,
    );
    super.initState();
  }

  intializeController() {
    widget.serviceName != null
        ? _serviceNameController.text = widget.serviceName!
        : _serviceNameController.text = "";
    print("widget.serviceRate: ${widget.serviceRate}");
    if (widget.serviceRate != null && widget.serviceRate!.isNotEmpty) {
      _rateController.text = widget.serviceRate!;
    } else {
      _rateController.text = ""; // Assign empty string if null or empty
    }
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ServiceProvider>(context, listen: false);
    return SafeArea(
        top: true,
        child: Scaffold(
          /*appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColor.BUTTON_COLOR,
            leading: InkWell(
              onTap: () {
                context.pop();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: CommonText(
              text: "Add Service",
              textStyle: const TextStyle(fontSize: 16),
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
                    child: context.watch<ServiceProvider>().loading
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Center(
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Gap(10.ss),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          activeTrackColor:
                                              Colors.lightGreenAccent,
                                          activeColor: Colors.green,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Gap(5.ss),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10.0.ss),
                                child: CommonText(
                                  text: "Service name *",
                                  textStyle: CustomTextStyle(
                                      fontSize: 14.fss,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              CommonTextFormField(
                                fontTextStyle:
                                    CustomTextStyle(fontSize: 16.fss),
                                controller: _serviceNameController,
                                onValidator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter service name';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(gapPadding: 1),
                                    enabledBorder:
                                        OutlineInputBorder(gapPadding: 1),
                                    focusedBorder:
                                        OutlineInputBorder(gapPadding: 1),
                                    hintText: "Service Name"),
                              ),
                              Gap(10.ss),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10.0.ss),
                                child: CommonText(
                                  text: "Rate *",
                                  textStyle: CustomTextStyle(
                                      fontSize: 14.fss,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Gap(5.ss),
                              Row(
                                children: [
                                  CommonTextFormField(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        20.ss,
                                    controller: _rateController,
                                    textInputType: TextInputType.number,
                                    fontTextStyle:
                                        CustomTextStyle(fontSize: 16.fss),
                                    onValidator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Service Rate';
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
                                      hintText: "Service Rate ",
                                      prefixIcon: Icon(
                                        Icons.attach_money_outlined,
                                        color: AppColor.APP_BAR_COLOUR,
                                      ),
                                    ),
                                  ),
                                  CommonText(
                                    text: "/",
                                  ),
                                  CommonDropdown(
                                    height: 50.ss,
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        30,
                                    options: context
                                        .watch<ServiceProvider>()
                                        .unitList,
                                    selectedValue: context
                                        .watch<ServiceProvider>()
                                        .selectedUnit,
                                    onChange: (value) {
                                      context
                                          .read<ServiceProvider>()
                                          .selectedUnit = value;
                                      context
                                          .read<ServiceProvider>()
                                          .notifyListeners();
                                    },
                                  ),
                                ],
                              ),
                              Gap(10.ss),
                              widget.isEdit != null && widget.isEdit! == true
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0.0.ss),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                                onTap: () {
                                                  print(
                                                      "update button hitting");
                                                  provider.validity(
                                                    // context,
                                                    // _serviceNameController.text
                                                    //     .trim(),
                                                    // _rateController.text.trim(),
                                                    // provider.selectedUnit.id!,
                                                    context: context,
                                                    serviceName:
                                                        _serviceNameController
                                                            .text
                                                            .trim(),
                                                    isEdit: widget.isEdit!,
                                                    rateUnit: provider
                                                        .selectedUnit.id!,
                                                    serviceId:
                                                        widget.serviceId!,
                                                    serviceRate:
                                                        _rateController.text,
                                                    // activeStatus:,
                                                  );
                                                },
                                                child: CustomButton(
                                                    btnColor:
                                                        Colors.green.shade700,
                                                    title: "Update")),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                                onTap: () {
                                                  print(
                                                      "delete button hitting");
                                                  showCupertinoDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return CupertinoAlertDialog(
                                                          content: const Text(
                                                            'Are you sure, you want to delete the Service?',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xff093d52),
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                          actions: [
                                                            CupertinoButton(
                                                              child: const Text(
                                                                'Yes, Delete',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                //-----Delete will be here----//
                                                                Provider.of<ServiceProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .deleteService(
                                                                  context:
                                                                      context,
                                                                  serviceId: widget
                                                                      .serviceId
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
                                                                    color: Colors
                                                                        .red),
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
                                                    btnColor:
                                                        Colors.red.shade300,
                                                    title: "Delete")),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0.0.ss),
                                      child: InkWell(
                                          onTap: () {
                                            provider.validity(
                                              context: context,
                                              isEdit: widget.isEdit,
                                              rateUnit:
                                                  provider.selectedUnit.id!,
                                              serviceId: widget.serviceId,
                                              serviceName:
                                                  _serviceNameController.text
                                                      .trim(),
                                              serviceRate: _rateController.text,
                                              // activeStatus:
                                              //     widget.activeStatus
                                            );
                                          },
                                          child: CustomButton(title: "Submit")),
                                    )
                            ],
                          ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
