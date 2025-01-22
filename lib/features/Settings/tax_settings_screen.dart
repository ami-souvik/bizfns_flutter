import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/utils/Utils.dart';
import '../../core/utils/colour_constants.dart';
import '../../provider/job_schedule_controller.dart';
import '../Admin/Create Job/model/tax_model.dart';

class TaxSettings extends StatefulWidget {
  const TaxSettings({super.key});

  @override
  State<TaxSettings> createState() => _TaxSettingsState();
}

class _TaxSettingsState extends State<TaxSettings> {
  List<TextEditingController> allTaxNameController = [];
  List<TextEditingController> allTaxRateController = [];
  List<bool> isEditable = [];
  List<bool> isEditTaxName = [];
  Map<String, String> taxUpdateMap = {"TaxTypeId": "", "TaxRate": ""};

  bool anyFieldIsBlank() {
    for (var controller in allTaxNameController) {
      if (controller.text.trim().isEmpty) {
        return true;
      }
    }
    for (var controller in allTaxRateController) {
      if (controller.text.trim().isEmpty) {
        return true;
      }
    }
    return false;
  }

  bool shouldReturnTrue(List<bool> isEditTaxName) {
    // Check if any value in the list is true
    for (bool value in isEditTaxName) {
      if (value) {
        return false; // Return false if any value is true
      }
    }
    return true; // Return true if all values are false
  }

  generateTaxTextField() {
    TextEditingController taxNameController = TextEditingController();
    TextEditingController taxRateController = TextEditingController();
    // specialChargesRateController.addListener(_calculateTotalSpecialCharge);
    setState(() {
      allTaxNameController.add(taxNameController);
      allTaxRateController.add(taxRateController);
      isEditable.add(true);
      isEditTaxName.add(true);
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<JobScheduleProvider>(context, listen: false)
        .getTaxValue(context: context)
        .then((value) {
      initializeTaxValue();
    });
  }

  void updateListAtIndex(List<bool> list, int index) {
    // Loop through the list and set all values to false
    for (int i = 0; i < list.length; i++) {
      list[i] = i == index;
    }
    setState(() {});
  }

  void setAllToFalse(List<bool> list) {
    // Loop through the list and set all values to false
    for (int i = 0; i < list.length; i++) {
      list[i] = false;
    }
    setState(() {});
  }

  initializeTaxValue() async {
    allTaxNameController.clear();
    allTaxRateController.clear();
    isEditable.clear();
    isEditTaxName.clear();
    if (Provider.of<JobScheduleProvider>(context, listen: false)
        .taxList
        .isNotEmpty) {
      for (var tax
          in Provider.of<JobScheduleProvider>(context, listen: false).taxList) {
        TextEditingController taxNameController =
            TextEditingController(text: tax.taxtypename);
        TextEditingController taxRateController =
            TextEditingController(text: tax.taxrate.toString());
        isEditable.add(false);
        isEditTaxName.add(false);
        allTaxNameController.add(taxNameController);
        allTaxRateController.add(taxRateController);
      }
      setState(() {});
    } else {
      allTaxNameController.clear();
      allTaxRateController.clear();
      isEditable.clear();
      isEditTaxName.clear();
    }
  }

  @override
  void dispose() {
    allTaxNameController.forEach((element) {
      element.dispose();
    });
    allTaxRateController.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  //taxList//
  Widget getSpecialChargesTextField(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 30,
                width: 200,
                child: TextField(
                  enabled: isEditTaxName[index],
                  onChanged: (value) {
                    // _updateSpecialChargeMap();
                  },
                  keyboardType: TextInputType.name,
                  controller: allTaxNameController[index],
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'type tax name',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0)),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              SizedBox(
                height: 30,
                width: 90,
                child: TextField(
                  enabled: isEditable[index],
                  onChanged: (value) {
                    // _updateSpecialChargeMap();
                  },
                  keyboardType: TextInputType.number,
                  controller: allTaxRateController[index],
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    hintText: '% 0.0',
                    hintStyle: TextStyle(
                      color: Colors.grey, // Color of the dollar sign
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          isEditable[index] == true
              ? Row(
                  children: [
                    Offstage(
                      offstage: Provider.of<JobScheduleProvider>(context,
                                      listen: false)
                                  .taxList
                                  .length ==
                              allTaxRateController.length &&
                          isEditable[index] == true,
                      child: InkWell(
                          onTap: () {
                            allTaxNameController.removeAt(index);
                            allTaxRateController.removeAt(index);
                            isEditTaxName.removeAt(index);
                            isEditable.removeAt(index);
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ),
                    InkWell(
                        onTap: () {
                          if (Provider.of<JobScheduleProvider>(context,
                                      listen: false)
                                  .taxList
                                  .length ==
                              allTaxRateController.length) {
                            if (allTaxNameController[index].text.isNotEmpty &&
                                allTaxRateController[index].text.isNotEmpty) {
                              taxUpdateMap['TaxTypeId'] =
                                  Provider.of<JobScheduleProvider>(context,
                                          listen: false)
                                      .taxList[index]
                                      .taxtypeid
                                      .toString();
                              taxUpdateMap['TaxRate'] =
                                  allTaxRateController[index].text.toString();

                              Provider.of<JobScheduleProvider>(context,
                                      listen: false)
                                  .updateTaxTable(
                                      taxUpdates: taxUpdateMap,
                                      context: context)
                                  .then(((value) {
                                Provider.of<JobScheduleProvider>(context,
                                        listen: false)
                                    .getTaxValue(context: context)
                                    .then((value) {
                                  log("LENGHTH : ${Provider.of<JobScheduleProvider>(context, listen: false).taxList.length}");
                                  initializeTaxValue();
                                  setState(() {});
                                });
                              }));
                            } else if (allTaxRateController[index]
                                .text
                                .isEmpty) {
                              Utils().ShowWarningSnackBar(
                                  context, 'Validation', 'Please add tax rate');
                            } else if (allTaxNameController[index]
                                .text
                                .isEmpty) {
                              Utils().ShowWarningSnackBar(
                                  context, 'Validation', 'Please add tax name');
                            } else {
                              Utils().ShowWarningSnackBar(context, 'Validation',
                                  'Please add tax name & rate');
                            }

                            // initializeTaxValue();
                            // setState(() {});
                            // log("Tax json : ${taxUpdateMap}");
                          } else {
                            if (allTaxNameController[index].text.isNotEmpty &&
                                allTaxRateController[index].text.isNotEmpty) {
                              Provider.of<JobScheduleProvider>(
                                      context,
                                      listen: false)
                                  .addTaxTable(
                                      taxMasterName:
                                          allTaxNameController[index].text,
                                      taxMasterRate:
                                          allTaxRateController[index].text,
                                      context: context)
                                  .then((value) {
                                Provider.of<JobScheduleProvider>(context,
                                        listen: false)
                                    .getTaxValue(context: context)
                                    .then((value) {
                                  log("LENGHTH : ${Provider.of<JobScheduleProvider>(context, listen: false).taxList.length}");
                                  initializeTaxValue();
                                  // isEditable[index] = !isEditable[index];
                                  setState(() {});
                                  // initializeTaxValue();
                                });
                              });
                            } else if (allTaxRateController[index]
                                .text
                                .isEmpty) {
                              Utils().ShowWarningSnackBar(
                                  context, 'Validation', 'Please add tax rate');
                            } else if (allTaxNameController[index]
                                .text
                                .isEmpty) {
                              Utils().ShowWarningSnackBar(
                                  context, 'Validation', 'Please add tax name');
                            } else {
                              Utils().ShowWarningSnackBar(context, 'Validation',
                                  'Please add tax name & rate');
                            }
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColor.APP_BAR_COLOUR),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Provider.of<JobScheduleProvider>(context,
                                                  listen: false)
                                              .taxList
                                              .length ==
                                          allTaxRateController.length &&
                                      isEditable[index] == true
                                  ? const Text('Update',
                                      style: TextStyle(color: Colors.white))
                                  : const Text(
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ))),
                  ],
                )
              : Row(
                  children: [
                    AbsorbPointer(
                      absorbing: !shouldReturnTrue(isEditTaxName),
                      child: InkWell(
                        onTap: () {
                          if (allTaxNameController[index].text.isEmpty &&
                              allTaxRateController[index].text.isEmpty) {
                            allTaxNameController.removeAt(index);
                            allTaxRateController.removeAt(index);
                            setState(() {});
                          } else {
                            showCupertinoDialog(
                                context: context,
                                builder: (_) {
                                  return CupertinoAlertDialog(
                                    content: const Text(
                                      'Are you sure, you want to delete the Tax?',
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
                                          Provider.of<JobScheduleProvider>(
                                                  context,
                                                  listen: false)
                                              .deleteTaxTable(
                                                  taxTypeId: Provider.of<
                                                              JobScheduleProvider>(
                                                          context,
                                                          listen: false)
                                                      .taxList[index]
                                                      .taxtypeid
                                                      .toString(),
                                                  context: context)
                                              .then((value) async {
                                            await Provider.of<
                                                        JobScheduleProvider>(
                                                    context,
                                                    listen: false)
                                                .getTaxValue(
                                              context: context,
                                            )
                                                .then((value) async {
                                              initializeTaxValue();
                                              setState(() {});
                                            });
                                          });
                                          context.pop();
                                        },
                                      ),
                                      CupertinoButton(
                                        child: const Text(
                                          'No',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          context.pop();
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: Container(
                          width:
                              20, // Adjust the width to control the size of the container
                          height:
                              20, // Adjust the height to control the size of the container
                          decoration: BoxDecoration(
                            color: Colors.grey
                                .shade300, // Background color of the container
                            shape:
                                BoxShape.circle, // Makes the container circular
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    AbsorbPointer(
                      absorbing: !shouldReturnTrue(isEditTaxName),
                      child: InkWell(
                        onTap: () {
                          // setState(() {
                          //   isEditable[index] = !isEditable[index];
                          // });
                          updateListAtIndex(isEditable, index);
                        },
                        child: Container(
                            width:
                                20, // Adjust the width to control the size of the container
                            height:
                                20, // Adjust the height to control the size of the container
                            decoration: const BoxDecoration(
                              color: AppColor
                                  .APP_BAR_COLOUR, // Background color of the container
                              shape: BoxShape
                                  .circle, // Makes the container circular
                            ),
                            child: Icon(
                              isEditable[index] ? Icons.check : Icons.edit,
                              color: Colors.white,
                              size: 15,
                            )),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (shouldReturnTrue(isEditTaxName)) {
          setAllToFalse(isEditable);
        }
      },
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: List.generate(allTaxNameController.length, (index) {
              return getSpecialChargesTextField(index);
            }),
          ),
          Visibility(
            visible: !anyFieldIsBlank(),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[300], // Background color
                  onPrimary: Colors.black, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Rounded corners
                  ),
                  elevation: 0, // No shadow
                ),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.green, // Icon color
                ),
                label: const Text(
                  'Add New Tax',
                  style: TextStyle(fontSize: 14.0),
                ),
                onPressed: () {
                  // Add your onPressed code here!
                  setAllToFalse(isEditable);
                  generateTaxTextField();
                },
              ),
            ),
          )
        ],
      )),
    );
  }
}
