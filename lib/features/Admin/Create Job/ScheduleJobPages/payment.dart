import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../../../core/route/RouteConstants.dart';
import '../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../core/utils/colour_constants.dart';
import '../../../../core/utils/route_function.dart';
import '../../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../../provider/job_schedule_controller.dart';
import '../model/add_schedule_model.dart';

class Payment extends StatefulWidget {
  const 
  Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final List<String> timeData = ['OnReceipt', 'PayLater'];

  final List<String> payLetterData = [
    'Next 30 Days',
    'Next 60 Days',
    'Next 90 Days',
    // 'Next 180 Days',
    // 'Monthly Invoice'
  ];

  TextEditingController depositAmount = TextEditingController();
  AddScheduleModel? addScheduleModel = AddScheduleModel.addSchedule;

  // String? selectedValue;
  // String? payLetterDuration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TitleProvider>(context, listen: false).title =
        'Schedule New Modify';
    log("addScheduleModel!.paymentDuration : ${addScheduleModel!.paymentDuration}");
    if (addScheduleModel!.paymentDuration != null &&
        addScheduleModel!.paymentDuration!.isNotEmpty) {
      if (addScheduleModel!.paymentDuration == "1") {
        Provider.of<JobScheduleProvider>(context, listen: false).selectedValue =
            "OnReceipt";
      } else if (addScheduleModel!.paymentDuration == "2") {
        Provider.of<JobScheduleProvider>(context, listen: false).selectedValue =
            "PayLater";
        Provider.of<JobScheduleProvider>(context, listen: false)
            .selectedPayLetterDurationValue = "Next 30 Days";
      } else if (addScheduleModel!.paymentDuration == "3") {
        Provider.of<JobScheduleProvider>(context, listen: false).selectedValue =
            "PayLater";
        Provider.of<JobScheduleProvider>(context, listen: false)
            .selectedPayLetterDurationValue = "Next 60 Days";
      } else if (addScheduleModel!.paymentDuration == "4") {
        Provider.of<JobScheduleProvider>(context, listen: false).selectedValue =
            "PayLater";
        Provider.of<JobScheduleProvider>(context, listen: false)
            .selectedPayLetterDurationValue = "Next 90 Days";
      }
    } else {
      Provider.of<JobScheduleProvider>(context, listen: false).selectedValue =
          null;
      Provider.of<JobScheduleProvider>(context, listen: false)
          .selectedPayLetterDurationValue = null;
    }

    if (addScheduleModel!.deposit != null) {
      depositAmount.text = addScheduleModel!.deposit.toString();
    } else {
      Provider.of<JobScheduleProvider>(context, listen: false).depositAmount =
          null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          color: Color(0xFFFFFF),
        ),
        // height: size.height / 1.8,
        child: Column(
          children: [
            Container(
              // width: size.w,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 55,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: AppColor.APP_BAR_COLOUR,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payment Terms",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white, width: 1.5),
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ExpansionTile(
                    title: const Text("Payment Option",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 5),
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFFCCEEF7)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/paypal-logo.png",
                                  height: 24,
                                  width: 24,
                                ),
                                Gap(10.ss),
                                const Text(
                                  "PayPal",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 5),
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFFCCEEF7)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/stripe.png",
                                  height: 24,
                                  width: 24,
                                ),
                                Gap(10.ss),
                                const Text(
                                  "Stripe",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 5),
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xFFCCEEF7)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/mobile-payment.png",
                                  height: 24,
                                  width: 24,
                                ),
                                Gap(10.ss),
                                const Text(
                                  "Others",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const Gap(15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "When",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
                  child: DropdownButtonFormField2(
                    value:
                        Provider.of<JobScheduleProvider>(context, listen: false)
                            .selectedValue,
                    decoration: InputDecoration(
                      //Add isDense true and zero Padding.
                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      //Add more decoration as you want here
                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                    ),
                    isExpanded: true,
                    // hint: const Text(
                    //   'Select Your Gender',
                    //   style: TextStyle(fontSize: 14),
                    // ),
                    items: timeData
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    /*validator: (value) {
                            if (value == null) {
                              return 'Please select gender.';
                            }
                            return null;
                          },*/
                    onChanged: (value) {
                      Provider.of<JobScheduleProvider>(context, listen: false)
                          .selectedValueOnChange(value);

                      Provider.of<JobScheduleProvider>(context, listen: false)
                          .depositAmount = 0;
                      // Provider.of<JobScheduleProvider>(context).selectedValue ==
                      //     'PayLater' ?
                      if (Provider.of<JobScheduleProvider>(context,
                                  listen: false)
                              .selectedValue ==
                          'OnReceipt') {
                        depositAmount.clear();
                        Provider.of<JobScheduleProvider>(context, listen: false)
                            .selectedPayLetterDurationValue = null;
                      }
                      // print("onChanged value ====>$selectedValue");
                      //Do something when changing the item if you want.
                    },
                    // onSaved: (value) {
                    //
                    //   selectedValue = value.toString();
                    //   print("onsaved value ====>$selectedValue");
                    // },
                    buttonStyleData: const ButtonStyleData(
                      height: 60,
                      padding: EdgeInsets.only(left: 20, right: 10),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const Gap(15),
                Visibility(
                  visible:
                      Provider.of<JobScheduleProvider>(context).selectedValue ==
                          'PayLater',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Duration",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 6),
                        child: DropdownButtonFormField2(
                          value: Provider.of<JobScheduleProvider>(context,
                                  listen: false)
                              .selectedPayLetterDurationValue,
                          decoration: InputDecoration(
                            //Add isDense true and zero Padding.
                            //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            //Add more decoration as you want here
                            //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                          ),
                          isExpanded: true,
                          // hint: const Text(
                          //   'Select Your Gender',
                          //   style: TextStyle(fontSize: 14),
                          // ),
                          items: payLetterData
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          /*validator: (value) {
                              if (value == null) {
                                return 'Please select gender.';
                              }
                              return null;
                            },*/
                          onChanged: (value) {
                            Provider.of<JobScheduleProvider>(context,
                                    listen: false)
                                .selectedPayLetterDurationValueOnChange(value);
                            // print("onChanged value ====>$payLetterDuration");
                            //Do something when changing the item if you want.
                          },
                          // onSaved: (value) {
                          //
                          //   selectedValue = value.toString();
                          //   print("onsaved value ====>$selectedValue");
                          // },
                          buttonStyleData: const ButtonStyleData(
                            height: 60,
                            padding: EdgeInsets.only(left: 20, right: 10),
                          ),
                          iconStyleData: const IconStyleData(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 30,
                          ),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                /*const Gap(15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Term",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
              child: DropdownButtonFormField2(
                decoration: InputDecoration(
                  //Add isDense true and zero Padding.
                  //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  //Add more decoration as you want here
                  //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                ),
                isExpanded: true,
                // hint: const Text(
                //   'Select Your Gender',
                //   style: TextStyle(fontSize: 14),
                // ),
                items: timeData
                    .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
                    .toList(),
                */ /*validator: (value) {
                            if (value == null) {
                              return 'Please select gender.';
                            }
                            return null;
                          },*/ /*
                onChanged: (value) {
                  //Do something when changing the item if you want.
                },
                onSaved: (value) {
                  selectedValue = value.toString();
                },
                buttonStyleData: const ButtonStyleData(
                  height: 60,
                  padding: EdgeInsets.only(left: 20, right: 10),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 30,
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),*/
                const Gap(15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Deposit",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
                  child: TextFormField(
                    controller: depositAmount,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Allow only digits
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter deposit amount';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixText: '\$',
                        prefixStyle: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                        hintText: "Deposit Amount"),
                  ),
                ),
                // const Gap(25),
                GestureDetector(
                  onTap: () {
                    Provider.of<JobScheduleProvider>(context, listen: false)
                        .validateReturn(context)
                        .then((value) {
                      if (value == true) {
                        if (depositAmount.text.isNotEmpty) {
                          Provider.of<JobScheduleProvider>(context,
                                  listen: false)
                              .setDepositAmount(int.parse(depositAmount.text));
                        }

                        Provider.of<JobScheduleProvider>(context, listen: false)
                            .doneYourPayment();

                        Navigator.pop(context);
                      }
                    });

                    //Navigator.pop(context);
                    // context.go(PREVIEW);
                    // Navigate(context,PREVIEW);
                    // Provider.of<JobScheduleProvider>(context, listen: false)
                    //     .doneYourPayment();

                    // Provider.of<JobScheduleProvider>(context, listen: false)
                    //             .selectedValue ==
                    //         "PayLater"

                    // : null;
                  },
                  child: const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 20.0),
                      child: CustomButton(
                        title: 'Done',
                      ),
                    ),
                  ),
                )
              ],
            )
            // const Gap(15),
          ],
        ),
      ),
    );
  }
}
