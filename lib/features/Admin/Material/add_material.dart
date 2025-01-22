import 'dart:developer';

import 'package:bizfns/features/Admin/Material/provider/material_provider.dart';
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

class AddMaterial extends StatefulWidget {
  final bool? isEdit;
  final String? materialId;
  final String? materialName;
  final String? materialType;
  final String? categoryId;
  final String? subCategoryId;
  final String? rate;
  final String? unitId;
  final int? activeStatus;
  const AddMaterial(
      {super.key,
      this.materialName,
      this.categoryId,
      this.subCategoryId,
      this.rate,
      this.unitId,
      this.isEdit,
      this.activeStatus,
      this.materialType,
      this.materialId});

  @override
  State<AddMaterial> createState() => _AddMaterialState();
}

class _AddMaterialState extends State<AddMaterial> {
  final _formKey = GlobalKey<FormState>();

  final _materialNameController = TextEditingController();
  final _rateController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _materialNameController.text = "";
    _rateController.text = "";
    initializeController();
    Provider.of<MaterialProvider>(context, listen: false)
        .clearCategoryListData();
    Provider.of<MaterialProvider>(context, listen: false)
        .clearSubcategoryListData();
    Provider.of<MaterialProvider>(context, listen: false)
        .getMaterialCategoryListApi(context, widget.activeStatus,
            widget.categoryId, widget.subCategoryId, widget.unitId);
    Provider.of<MaterialProvider>(context, listen: false)
        .getMaterialUnitListApi(context);
    log("ACTIVE STATUS : ${widget.activeStatus}");
    Provider.of<MaterialProvider>(context, listen: false)
        .initializeSwith(activeStatus: widget.activeStatus);
  }

  initializeController() {
    widget.materialName != null
        ? _materialNameController.text = widget.materialName!
        : _materialNameController.text = '';

    if (widget.rate != null && widget.rate!.isNotEmpty) {
      _rateController.text = widget.rate!;
    } else {
      _rateController.text = ""; // Assign empty string if null or empty
    }

    print("widget.categoryID => ${widget.categoryId}");
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MaterialProvider>(context, listen: false);

    return SafeArea(
        child: Scaffold(
      /*appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.BUTTON_COLOR,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: CommonText(
          text: "Add Material",
          textStyle: TextStyle(fontSize: 16),
        ),
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
                                value: Provider.of<MaterialProvider>(context,
                                        listen: false)
                                    .isSwitched,
                                onChanged: (value) {
                                  print("OnChange Value is widget : ${value}");
                                  Provider.of<MaterialProvider>(context,
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
                        text: "Material name *",
                        textStyle: CustomTextStyle(
                            fontSize: 14.fss, fontWeight: FontWeight.w700),
                      ),
                    ),
                    CommonTextFormField(
                      fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                      controller: _materialNameController,
                      onValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter material name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(gapPadding: 1),
                          enabledBorder: OutlineInputBorder(gapPadding: 1),
                          focusedBorder: OutlineInputBorder(gapPadding: 1),
                          hintText: "Material Name"),
                    ),
                    Gap(10.ss),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                      child: CommonText(
                        text: "Category ",
                        textStyle: CustomTextStyle(
                            fontSize: 14.fss, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 5.ss,
                    ),
                    CommonDropdown(
                      options: context.watch<MaterialProvider>().categoryList,
                      selectedValue:
                          context.watch<MaterialProvider>().selectedCategory,
                      onChange: (value) {
                        context.read<MaterialProvider>().selectedCategory =
                            value;
                        Provider.of<MaterialProvider>(context, listen: false)
                            .onChange();
                        if (int.parse(context
                                .read<MaterialProvider>()
                                .categoryList
                                .first
                                .id!) ==
                            -1) {
                          context
                              .read<MaterialProvider>()
                              .categoryList
                              .removeAt(0);
                        }
                        context.read<MaterialProvider>().notifyListeners();
                        Provider.of<MaterialProvider>(context, listen: false)
                            .getMaterialUnitListApi(context);
                      },
                    ),
                    Gap(10.ss),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                      child: CommonText(
                        text: "Sub-Category ",
                        textStyle: CustomTextStyle(
                            fontSize: 14.fss, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 5.ss,
                    ),
                    CommonDropdown(
                      options:
                          context.watch<MaterialProvider>().subcategoryList,
                      selectedValue:
                          context.watch<MaterialProvider>().selectedsubCategory,
                      onChange: (value) {
                        context.read<MaterialProvider>().selectedsubCategory =
                            value;

                        if (int.parse(context
                                .read<MaterialProvider>()
                                .categoryList
                                .first
                                .id!) ==
                            -1) {
                          context
                              .read<MaterialProvider>()
                              .categoryList
                              .removeAt(0);
                        }
                        context.read<MaterialProvider>().notifyListeners();
                      },
                    ),
                    SizedBox(
                      height: 20.ss,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                      child: CommonText(
                        text: "Rate *",
                        textStyle: CustomTextStyle(
                            fontSize: 14.fss, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 0.ss,
                    ),
                    Row(
                      children: [
                        CommonTextFormField(
                          width: (MediaQuery.of(context).size.width) - 20.ss,
                          controller: _rateController,
                          textInputType: TextInputType.number,
                          fontTextStyle: CustomTextStyle(fontSize: 16.fss),
                          onValidator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Material Rate';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(gapPadding: 1),
                            enabledBorder: OutlineInputBorder(gapPadding: 1),
                            focusedBorder: OutlineInputBorder(gapPadding: 1),
                            hintText: "Material Rate ",
                            prefixIcon: Icon(
                              Icons.attach_money_outlined,
                              color: AppColor.APP_BAR_COLOUR,
                            ),
                          ),
                        ),
                        /* CommonText(text: "/",),
                        CommonDropdown(
                          height: 50.ss,
                          width: (MediaQuery.of(context).size.width/2)-30,
                          options:  context.watch<MaterialProvider>().unitList,
                          selectedValue:  context.watch<MaterialProvider>().selectedUnit,
                          onChange: (value){
                            context.read<MaterialProvider>().selectedUnit = value;
                            context.read<MaterialProvider>().notifyListeners();
                          },
                        ),*/
                      ],
                    ),
                    SizedBox(
                      height: 10.ss,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0.ss),
                      child: CommonText(
                        text: "Rate per Unit *",
                        textStyle: CustomTextStyle(
                            fontSize: 14.fss, fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 5.ss,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CommonDropdown(
                            options: context
                                .watch<MaterialProvider>()
                                .materialUnitList,
                            selectedValue:
                                context.watch<MaterialProvider>().selectedUnit,
                            onChange: (value) {
                              context.read<MaterialProvider>().selectedUnit =
                                  value;
                              if (int.parse(context
                                      .read<MaterialProvider>()
                                      .materialUnitList
                                      .first
                                      .id!) ==
                                  -1) {
                                context
                                    .read<MaterialProvider>()
                                    .materialUnitList
                                    .removeAt(0);
                              }
                              context
                                  .read<MaterialProvider>()
                                  .notifyListeners();
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {

                            unitController.clear();

                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12.0)),
                                        color: Color(0xFFFFFF),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            // width: size.w,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            height: 55,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0)),
                                              color: AppColor.APP_BAR_COLOUR,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Add Unit",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                                GestureDetector(
                                                  onTap: () =>
                                                      Navigator.pop(context),
                                                  child: Container(
                                                    height: 22,
                                                    width: 22,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1.5),
                                                    ),
                                                    child: const Icon(
                                                      Icons.clear_rounded,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const Gap(15),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 18.0),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Enter Unit",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                )),
                                          ),
                                          // Gap(10.ss),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 8),
                                            child: TextField(
                                              controller: unitController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1.0),
                                                ),
                                                //hintText: 'Enter a search term',
                                              ),
                                            ),
                                          ),
                                          // const Gap(25),
                                          GestureDetector(
                                            onTap: () {
                                              provider.materialUnitValidity(
                                                  context: context,
                                                  unitName: unitController.text
                                                      .trim());
                                            },
                                            child: const Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 50.0,
                                                    vertical: 20.0),
                                                child: CustomButton(
                                                  title: 'Save',
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.ss,
                    ),
                    widget.isEdit == null
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0.0.ss, vertical: 20.ss),
                            child: InkWell(
                                onTap: () {
                                  provider.validity(
                                    // context,
                                    // _materialNameController.text.trim(),
                                    // _rateController.text.trim(),
                                    context: context,
                                    isEdit: widget.isEdit,
                                    material_name:
                                        _materialNameController.text.trim(),
                                    rate: _rateController.text.trim(),
                                    materialId: '',
                                    materialType: widget.materialType,
                                    // materialRateUnitId: widget.unitId
                                  );
                                },
                                child: CustomButton(title: "Submit")),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0.0.ss, vertical: 20.ss),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        provider.validity(
                                          // context,
                                          // _materialNameController.text.trim(),
                                          // _rateController.text.trim(),
                                          context: context,
                                          isEdit: widget.isEdit,
                                          materialId: widget.materialId,
                                          materialType: widget.materialType,
                                          material_name: _materialNameController
                                              .text
                                              .trim(),
                                          rate: _rateController.text.trim(),
                                          // materialRateUnitId: widget.unitId
                                        );
                                      },
                                      child: CustomButton(
                                          btnColor: Colors.green.shade700,
                                          title: "Update")),
                                ),
                                Expanded(
                                  child: InkWell(
                                      onTap: () {
                                        showCupertinoDialog(
                                            context: context,
                                            builder: (_) {
                                              return CupertinoAlertDialog(
                                                content: const Text(
                                                  'Are you sure, you want to delete the Material?',
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
                                                      Provider.of<MaterialProvider>(
                                                              context,
                                                              listen: false)
                                                          .deleteMaterial(
                                                        context: context,
                                                        materialId: widget
                                                            .materialId
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
                                )
                              ],
                            ),
                          ),
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
