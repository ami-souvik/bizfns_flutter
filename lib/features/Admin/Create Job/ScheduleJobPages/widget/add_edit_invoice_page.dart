import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../../../../core/utils/Utils.dart';
import '../../../../../core/utils/colour_constants.dart';
import '../../../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../../../../core/widgets/AddModifyScheduleCustomField/custom_field.dart';
import '../../../../../provider/job_schedule_controller.dart';
import '../../model/add_schedule_model.dart';
import '../../model/get_edit_invoice_model.dart';

class AddEditInvoice extends StatefulWidget {
  final AddScheduleModel addScheduleModel;
  final List<int> customerIdList;
  final GetEditInvoiceModel? model;
  const AddEditInvoice({
    super.key,
    required this.addScheduleModel,
    required this.customerIdList,
    this.model,
  });

  @override
  State<AddEditInvoice> createState() => _AddEditInvoiceState();
}

class _AddEditInvoiceState extends State<AddEditInvoice> {
  List<CustomerData> customer = [];
  int totalServicePrice = 0;
  double totalMaterialPrice = 0.0;
  double totalSpecialChargesPrice = 0.0;
  double totalLaborChargesPrice = 0.0;
  double totalTripTravelChargesPrice = 0.0;
  double totalTaxPercentage = 0.0;
  double totalTaxAmount = 0.0;
  double grandtotal = 0.0;
  double discountValue = 0.0;
  String hintText = '%';
  Map<String, int> serviceQuantityMap = {};
  Map<String, double> materialQuantityMap = {};
  Map<String, double> specialChargesMap = {};
  String? invoiceDate;
  String? dueDate;
  String? pd;
  String? paymentDurErrorText;
  String? paylaterDurErrorText;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        invoiceDate = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  _validatePaymentDurDropDown() {
    setState(() {
      paymentDurErrorText =
          Provider.of<JobScheduleProvider>(context, listen: false)
                      .selectedValue ==
                  null
              ? 'Please Select Payment Duration*'
              : null;
      if (Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedValue ==
          null) {
        Utils().ShowWarningSnackBar(
            context, 'Validation', 'Please Select Payment Duration Dropdown');
      }
    });
  }

  _validatePaylaterDurDropdown() {
    setState(() {
      paylaterDurErrorText =
          Provider.of<JobScheduleProvider>(context, listen: false)
                      .selectedPayLetterDurationValue ==
                  null
              ? 'Please Select PayLater Duration*'
              : null;
      if (Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedPayLetterDurationValue ==
          null) {
        Utils().ShowWarningSnackBar(
            context, 'Validation', 'Please Select Paylater Duration Dropdown');
      }
    });
  }

  String formatDateString(String inputDate) {
    // Parse the input date string to a DateTime object
    DateTime parsedDate = DateTime.parse(inputDate);

    // Format the parsed date to the desired format (MM/dd/yyyy)
    String formattedDate = DateFormat('MM/dd/yyyy').format(parsedDate);

    // Return the formatted date string
    return formattedDate;
  }

  List<TextEditingController> allServiceController = [];
  List<TextEditingController> allMaterialController = [];
  TextEditingController laborChargesController = TextEditingController();
  TextEditingController tripTravelChargesController = TextEditingController();
  List<TextEditingController> allSpecialChargesNameController = [];
  List<TextEditingController> allSpecialChargesRateController = [];
  TextEditingController discountController = TextEditingController();

  List<bool> isSelected = [true, false];

  final List<String> timeData = ['OnReceipt', 'PayLater'];

  final List<String> payLetterData = [
    'Next 30 Days',
    'Next 60 Days',
    'Next 90 Days',
    // 'Next 180 Days',
    // 'Monthly Invoice'
  ];

  @override
  void initState() {
    super.initState();
    log("DEPOSIT: ${widget.addScheduleModel.deposit}");
    log("CUSTOMER LIST : ${widget.customerIdList}");
    intializeCustomer();
    // totalCalculation();
    //------service-calculation-------//
    for (var i = 0; i < widget.addScheduleModel.newServiceList!.length; i++) {
      final controller = TextEditingController();
      controller.addListener(() {
        _updateServiceTotalPrice();
        _updateServiceQuantityMap();
      });
      allServiceController.add(controller);
    }

    //------material-calculation--------//
    for (var i = 0; i < widget.addScheduleModel.newMaterialList!.length; i++) {
      final controller = TextEditingController();
      controller.addListener(() {
        _updateMaterialTotalPrice();
        _updateMaterialQuantityMap();
      });
      allMaterialController.add(controller);
    }

    //-----special-charge-calculation------//
    // Add listeners to the individual controllers
    laborChargesController.addListener(() {
      _calculateTotalSpecialCharge();
    });
    tripTravelChargesController.addListener(() {
      _calculateTotalSpecialCharge();
    });

    // Add listeners to each controller in the list
    allSpecialChargesRateController.forEach((controller) {
      controller.addListener(() {
        _calculateTotalSpecialCharge();
        _updateSpecialChargeMap();
      });
    });
    log("widget.model : ${widget.model}");
    if (widget.model != null) {
      //---------setting dynamic time----------//
      if (widget.model!.invoiceDate != null &&
          widget.model!.invoiceDate!.isNotEmpty) {
        invoiceDate = formatDateString(widget.model!.invoiceDate!);
        if (widget.model!.paymentDuration != null &&
            widget.model!.paymentDuration!.isNotEmpty) {
          pd = widget.model!.paymentDuration;
          getDates(int.parse(widget.model!.paymentDuration!));
        } else {
          getDates(1);
        }
      } else {
        invoiceDate =
            DateFormat('MM/dd/yyyy').format(DateTime.now()).toString();
        getDates(1);
      }
      //-----------------------------------------//
      _populateControllersWithServicePredefinedValues();
      _populateControllersWithMaterialPredefinedValues();
      laborChargesController.text = widget.model!.laborCharge!
              .toString()
              .isNotEmpty
          ? double.tryParse(widget.model!.laborCharge!.toString()).toString() ??
              '0.0'
          : '0.0';

      tripTravelChargesController.text =
          widget.model!.tripTravelCharge.toString().isNotEmpty
              ? double.tryParse(widget.model!.tripTravelCharge.toString())
                      .toString() ??
                  '0.0'
              : '0.0';

      discountController.text =
          widget.model!.discount.discountValue.toString().isNotEmpty
              ? (widget.model!.discount.discountValue).toString() ?? '0.0'
              : '0.0';

      if (widget.model!.discount.discountMethod.toString() != "None") {
        if (widget.model!.discount.discountMethod.toString() != "percentage") {
          // setState(() {
          isSelected = [false, true];
          // });
        }
        // else{

        // }
      }

      // discountController.addListener(() {

      // });

      _populateControllersWithSpecialChargePredefinedValues();
      // Provider.of<JobScheduleProvider>(context, listen: false).selectedValue =
      //     null;
      // Provider.of<JobScheduleProvider>(context, listen: false)
      //     .selectedPayLetterDurationValue = null;
    } else {
      invoiceDate = DateFormat('MM/dd/yyyy').format(DateTime.now()).toString();
      log("Payment duration : ${widget.addScheduleModel!.paymentDuration}");
      if (widget.addScheduleModel!.paymentDuration != null &&
          widget.addScheduleModel!.paymentDuration!.isNotEmpty) {
        log("Payment duration : ${widget.addScheduleModel!.paymentDuration}");
        pd = widget.addScheduleModel!.paymentDuration!;

        //-----------new imp------------//
        // Provider.of<JobScheduleProvider>(context, listen: false).selectedValue =
        //     null;
        // Provider.of<JobScheduleProvider>(context, listen: false)
        //     .selectedPayLetterDurationValue = null;
        // log("widget.addScheduleModel!.paymentDuration : ${widget.addScheduleModel!.paymentDuration}");
        log("PD : ${pd}");
        if (pd == "1") {
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedValue = "OnReceipt";
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedPayLetterDurationValue = null;
          setState(() {});
        } else if (pd == "2") {
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedValue = "PayLater";
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedPayLetterDurationValue = "Next 30 Days";
        } else if (pd == "3") {
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedValue = "PayLater";
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedPayLetterDurationValue = "Next 60 Days";
        } else if (pd == "4") {
          log("HEre inside Next 90 days");
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedValue = "PayLater";
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedPayLetterDurationValue = "Next 90 Days";
        }
        //------------------------------//

        getDates(int.parse(widget.addScheduleModel!.paymentDuration!));
      } else {
        getDates(1);
        Provider.of<JobScheduleProvider>(context, listen: false).selectedValue =
            null;
        Provider.of<JobScheduleProvider>(context, listen: false)
            .selectedPayLetterDurationValue = null;
      }
    }
    // log("widget.addScheduleModel!.paymentDuration : ${widget.addScheduleModel!.paymentDuration}");
    if (widget.model != null) {
      if (widget.model!.paymentDuration != null &&
          widget.model!.paymentDuration!.isNotEmpty) {
        Provider.of<JobScheduleProvider>(context, listen: false).selectedValue =
            null;
        Provider.of<JobScheduleProvider>(context, listen: false)
            .selectedPayLetterDurationValue = null;
        // log("widget.addScheduleModel!.paymentDuration : ${widget.addScheduleModel!.paymentDuration}");
        if (widget.model!.paymentDuration == "1") {
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedValue = "OnReceipt";
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedPayLetterDurationValue = null;
        } else if (widget.model!.paymentDuration == "2") {
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedValue = "PayLater";
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedPayLetterDurationValue = "Next 30 Days";
        } else if (widget.model!.paymentDuration == "3") {
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedValue = "PayLater";
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedPayLetterDurationValue = "Next 60 Days";
        } else if (widget.model!.paymentDuration == "4") {
          log("HEre inside Next 90 days");
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedValue = "PayLater";
          Provider.of<JobScheduleProvider>(context, listen: false)
              .selectedPayLetterDurationValue = "Next 90 Days";
        }
      }
    } else {
      // Provider.of<JobScheduleProvider>(context, listen: false).selectedValue =
      //     null;
      // Provider.of<JobScheduleProvider>(context, listen: false)
      //     .selectedPayLetterDurationValue = null;
    }

    if (discountController.text.isNotEmpty) {
      calculatePercentage();
    }
  }

  setDynamicDueDate() {
    log("Provider.of<JobScheduleProvider>context, listen: false : ${Provider.of<JobScheduleProvider>(context, listen: false).selectedValue}");
    // if (Provider.of<JobScheduleProvider>(context, listen: false)
    //         .selectedValue ==
    //     'OnReceipt') {
    //   // depositAmount.clear();
    //   Provider.of<JobScheduleProvider>(context, listen: false)
    //       .selectedPayLetterDurationValue = null;
    // }

    if (Provider.of<JobScheduleProvider>(context, listen: false)
            .selectedValue ==
        "OnReceipt") {
      setState(() {
        pd = "1";
      });
    }

    if (Provider.of<JobScheduleProvider>(context, listen: false)
            .selectedPayLetterDurationValue ==
        "Next 30 Days") {
      setState(() {
        pd = "2";
      });
    } else if (Provider.of<JobScheduleProvider>(context, listen: false)
            .selectedPayLetterDurationValue ==
        "Next 60 Days") {
      setState(() {
        pd = "3";
      });
    } else if (Provider.of<JobScheduleProvider>(context, listen: false)
            .selectedPayLetterDurationValue ==
        "Next 90 Days") {
      setState(() {
        pd = "4";
      });
    }

    setState(() {
      getDates(int.parse(pd!));
    });
  }

  void getDates(int value) {
    DateTime currentDateTime = DateFormat('MM/dd/yyyy').parse(invoiceDate!);
    DateTime DueDate;
    log("getDates : ${value}");
    if (value == 1) {
      DueDate = currentDateTime; // Same day
    } else if (value == 2) {
      DueDate = currentDateTime.add(const Duration(days: 30)); // Next 30 days
    } else if (value == 3) {
      DueDate = currentDateTime.add(const Duration(days: 60)); // Next 60 days
    } else if (value == 4) {
      DueDate = currentDateTime.add(const Duration(days: 90)); // Next 90 days
    } else {
      throw Exception("Invalid value. It should be 1, 2, 3, or 4.");
    }
    dueDate = DateFormat('MM/dd/yyyy').format(DueDate).toString();
  }

  void _calculateTotalSpecialCharge() {
    totalLaborChargesPrice = 0.0;
    totalTripTravelChargesPrice = 0.0;
    totalLaborChargesPrice =
        double.tryParse(laborChargesController.text) ?? 0.0;
    totalTripTravelChargesPrice =
        double.tryParse(tripTravelChargesController.text) ?? 0.0;
    double specialChargesSum =
        allSpecialChargesRateController.fold(0.0, (sum, controller) {
      return sum + (double.tryParse(controller.text) ?? 0.0);
    });

    setState(() {
      totalSpecialChargesPrice = totalLaborChargesPrice +
          totalTripTravelChargesPrice +
          specialChargesSum;
      calculateGrandTotal();
    });
  }

  calculateGrandTotal() {
    double serviceTotalPrice = totalServicePrice.toDouble();
    double materialTotalPrice = totalMaterialPrice.toDouble();
    grandtotal =
        serviceTotalPrice + materialTotalPrice + totalSpecialChargesPrice;

    log("GRAND TOTAL AMOUNT -------||${grandtotal}||");
  }

  bool _validateServiceFields() {
    bool isValid = true;

    for (var controller in allServiceController) {
      if (controller.text.trim().isEmpty) {
        isValid = false;
        break;
      }
    }

    if (!isValid) {
      Utils().ShowWarningSnackBar(
          context, 'Validation', 'Please fill all service fields.');
    }

    return isValid;
  }

  void _updateServiceTotalPrice() {
    setState(() {
      totalServicePrice = 0;
      for (var i = 0; i < widget.addScheduleModel.newServiceList!.length; i++) {
        int rate = widget.addScheduleModel.newServiceList![i].rATE ?? 0;
        int quantity = int.tryParse(allServiceController[i].text) ?? 0;
        totalServicePrice += rate * quantity;
      }
      calculateGrandTotal();
    });
  }

  void _updateMaterialTotalPrice() {
    setState(() {
      totalMaterialPrice = 0.0;
      for (var i = 0;
          i < widget.addScheduleModel.newMaterialList!.length;
          i++) {
        double rate = double.tryParse(
                widget.addScheduleModel.newMaterialList![i].rATE.toString()) ??
            0.0;
        double quantity = double.tryParse(allMaterialController[i].text) ?? 0.0;
        totalMaterialPrice += rate * quantity;
      }
      calculateGrandTotal();
    });
  }

  double calculateTotalTaxPrice() {
    calculateGrandTotal();
    final taxList =
        Provider.of<JobScheduleProvider>(context, listen: false).taxList;

    totalTaxPercentage = 0.0;

    for (var tax in taxList) {
      totalTaxPercentage += tax.taxrate!; // Summing up the tax rates
    }
    log("GRANDTOTAL : ${grandtotal}");
    totalTaxAmount = (totalTaxPercentage / 100) * grandtotal;

    log("Total tax amount : ${totalTaxAmount}");

    return totalTaxAmount;
  }

  //-------updating service quantity map-------//
  void _updateServiceQuantityMap() {
    serviceQuantityMap.clear();
    for (var i = 0; i < widget.addScheduleModel.newServiceList!.length; i++) {
      String serviceId =
          widget.addScheduleModel.newServiceList![i].iD.toString();
      int quantity = int.tryParse(allServiceController[i].text) ?? 0;
      if (quantity > 0) {
        serviceQuantityMap[serviceId] = quantity;
      }
    }
    print(jsonEncode(serviceQuantityMap)); // Print the JSON object to console
  }
  //------------------------------------------//

  //--------populate-service quantity map-------//
  // Map<String, int> predefinedMap = {
  //   "demo service 03": 2,
  //   "demoService02": 3,
  //   "room": 1,
  // };
  void _populateControllersWithServicePredefinedValues() {
    print("_populateControllersWithServicePredefinedValues calling");
    for (var i = 0; i < widget.addScheduleModel.newServiceList!.length; i++) {
      String sericeName =
          widget.addScheduleModel.newServiceList![i].sERVICENAME.toString();

      // Check if this service ID exists in the predefined map
      if (widget.model!.services!.containsKey(sericeName)) {
        // Set the corresponding controller's text to the value from the predefined map
        allServiceController[i].text =
            widget.model!.services![sericeName]!.toString();
      }
    }
  }
  //--------------------------------------------//

  //--------populate-material quantity map--------//
  _populateControllersWithMaterialPredefinedValues() {
    print("_populateControllersWithMaterialPredefinedValues calling");
    for (var i = 0; i < widget.addScheduleModel.newMaterialList!.length; i++) {
      String materialName =
          widget.addScheduleModel.newMaterialList![i].mATERIALNAME.toString();

      // Check if this service ID exists in the predefined map
      if (widget.model!.materials!.containsKey(materialName)) {
        // Set the corresponding controller's text to the value from the predefined map
        allMaterialController[i].text =
            widget.model!.materials![materialName]!.toString();
      }
    }
  }

  //---------populate-special-quantity-map--------//
  _populateControllersWithSpecialChargePredefinedValues() {
    int index = 0;
    widget.model!.specialCharges.forEach((key, value) {
      generateSpecialTextField();
      if (index < allSpecialChargesNameController.length &&
          index < allSpecialChargesRateController.length) {
        // Update the name controller with the key
        allSpecialChargesNameController[index].text = key;

        // Update the rate controller with the value
        allSpecialChargesRateController[index].text =
            value.toString().isNotEmpty
                ? double.tryParse(value.toString()).toString() ?? '0.0'
                : '0.0';
        index++;
      }
    });
  }

  //------updating material quantity map-------//
  void _updateMaterialQuantityMap() {
    materialQuantityMap.clear();
    for (var i = 0; i < widget.addScheduleModel.newMaterialList!.length; i++) {
      String materialID =
          widget.addScheduleModel.newMaterialList![i].pKMATERIALID.toString();
      double quantity = allMaterialController[i].text.toString().isNotEmpty
          ? double.tryParse(allMaterialController[i].text) ?? 0.0
          : 0.0;
      if (quantity > 0.0) {
        materialQuantityMap[materialID] = quantity;
      }
    }
    print(jsonEncode(materialQuantityMap)); // Print the JSON object to console
  }

  //-----updating extra service charge map-----//
  _updateSpecialChargeMap() {
    specialChargesMap.clear();
    log("ALL SPECIAL CHARGES NAME CONTROLLER : ${allSpecialChargesNameController.length}");
    for (var i = 0; i < allSpecialChargesNameController.length; i++) {
      String specialChargeName =
          allSpecialChargesNameController[i].text.toString().isNotEmpty
              ? allSpecialChargesNameController[i].text.toString()
              : 'specialCharge${i.toString()}';
      double specialChargeRate =
          allSpecialChargesRateController[i].text.toString().isNotEmpty
              ? double.tryParse(
                      allSpecialChargesRateController[i].text.toString())! ??
                  0.0
              : 0.0;
      if (specialChargeRate > 0.0) {
        specialChargesMap[specialChargeName] = specialChargeRate;
      }
    }
    log('_updateSpecialChargeMap JSON: |||${jsonEncode(specialChargesMap)}|||');
    setState(() {});
  }

  void calculatePercentage() {
    calculateGrandTotal();
    double inputValue = double.tryParse(discountController.text) ?? 0.0;
    double cloneGrandTotal = grandtotal;
    log("In calculatePercentage blick : ${grandtotal}");
    // setState(() {
    if (isSelected[0]) {
      // Percentage selected
      discountValue = (grandtotal * (inputValue / 100));
    } else {
      // Dollar selected
      discountValue = inputValue;
    }
    setState(() {});
    // });

    log("DISCOUNT VAL : ${discountValue}");
  }

  intializeCustomer() {
    // print("widget.customerIdList : ${widget.customerIdList.length}");
    // print(
    //     "widget.addScheduleModel.customer! : ${widget.addScheduleModel.customer}");
    // // widget.customerIdList.map((e) => )
    // widget.addScheduleModel.customer.where((element) => element.customerId == widget.customerIdList.map((e) => e))
    //  customer= widget.customerIdList.map((e) => widget.addScheduleModel.customer!.map((elem) => elem.customerId ==e.toString())).toList();
    if (widget.addScheduleModel.customer != null) {
      for (var i = 0; i < widget.customerIdList.length; i++) {
        for (var j = 0; j < widget.addScheduleModel.customer!.length; j++) {
          if (widget.addScheduleModel.customer![j].customerId.toString() ==
              widget.customerIdList[i].toString()) {
            customer!.add(widget.addScheduleModel.customer![j]);
            setState(() {});
          }
        }
      }
    }

    print("customer : ${customer}");
  }

  generateSpecialTextField() {
    TextEditingController specialChargesNameController =
        TextEditingController();
    TextEditingController specialChargesRateController =
        TextEditingController();
    specialChargesRateController.addListener(_calculateTotalSpecialCharge);
    setState(() {
      allSpecialChargesNameController.add(specialChargesNameController);
      allSpecialChargesRateController.add(specialChargesRateController);
    });
  }

  Widget getServiceTextField(int index) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          width: 50,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: allServiceController[index],
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Allows only digits
            ],
            decoration: const InputDecoration(
              hintText: 'Qty 0',
              hintStyle: TextStyle(
                color: Colors.grey, // Color of the dollar sign
              ),
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
              // prefixText: '\$ ', // Dollar sign as prefix
              // prefixStyle: TextStyle(
              //   color: Colors.grey, // Color of the dollar sign
              //   fontSize: 15.0, // Font size of the dollar sign
              // ),
            ),
          ),
        ),
        if (allServiceController[index].text.toString().trim().isEmpty)
          const Text(
            "Add qty*",
            style: TextStyle(fontSize: 8, color: Colors.red),
          )
      ],
    );
  }

  Widget getMaterialTextField(int index) {
    return SizedBox(
      height: 30,
      width: 50,
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(
                r'^\d*\.?\d*'), // Regular expression to allow only numbers and one decimal point
          ),
        ],
        controller: allMaterialController[index],
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: '0.0',
          hintStyle: TextStyle(
            color: Colors.grey, // Color of the dollar sign
          ),
          contentPadding: EdgeInsets.all(5),
          // prefixText: '\$ ', // Dollar sign as prefix
          // prefixStyle: TextStyle(
          //   color: Colors.grey, // Color of the dollar sign
          //   fontSize: 15.0, // Font size of the dollar sign
          // ),
        ),
        onTapOutside: (event) {
          if (allMaterialController[index].text.isNotEmpty &&
              int.tryParse(allMaterialController[index].text) != null) {
            setState(() {
              allMaterialController[index].text =
                  '${allMaterialController[index].text}.0';
              allMaterialController[index].selection =
                  TextSelection.fromPosition(
                TextPosition(offset: allMaterialController[index].text.length),
              );
            });
          }
          _updateMaterialQuantityMap();
        },
      ),
    );
  }
  // void _onTapOutside() {
  //   String value = _controller.text;

  //   // If the text is a valid integer, convert it to a double by appending .0
  //   if (value.isNotEmpty && int.tryParse(value) != null) {
  //     setState(() {
  //       _controller.text = '$value.0';
  //       _controller.selection = TextSelection.fromPosition(
  //         TextPosition(offset: _controller.text.length),
  //       );
  //     });
  //   }
  // }

  Widget getSpecialChargesTextField(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 30,
            width: 200,
            child: TextField(
              onChanged: (value) {
                _updateSpecialChargeMap();
              },
              keyboardType: TextInputType.name,
              controller: allSpecialChargesNameController[index],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'type new special charge name',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0)),
            ),
          ),
          SizedBox(
            height: 30,
            width: 90,
            child: TextField(
              onTapOutside: (event) {
                if (allSpecialChargesRateController[index].text.isNotEmpty &&
                    int.tryParse(allSpecialChargesRateController[index].text) !=
                        null) {
                  setState(() {
                    allSpecialChargesRateController[index].text =
                        '${allSpecialChargesRateController[index].text}.0';
                    allSpecialChargesRateController[index].selection =
                        TextSelection.fromPosition(
                      TextPosition(
                          offset: allSpecialChargesRateController[index]
                              .text
                              .length),
                    );
                  });
                  _updateSpecialChargeMap();
                }
              },
              onChanged: (value) {
                _updateSpecialChargeMap();
              },
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(
                      r'^\d*\.?\d*'), // Regular expression to allow only numbers and one decimal point
                ),
              ],
              controller: allSpecialChargesRateController[index],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '\$ 0.0',
                hintStyle: TextStyle(
                  color: Colors.grey, // Color of the dollar sign
                ),
                contentPadding: EdgeInsets.all(5),
                // prefixText: '\$', // Dollar sign as prefix
                // prefixStyle: TextStyle(
                //   color: Colors.grey, // Color of the dollar sign
                //   fontSize: 15.0, // Font size of the dollar sign
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  totalCalculation() {
    totalServicePrice = widget.addScheduleModel.newServiceList!
        .map((service) => service.rATE ?? 0)
        .reduce((value, element) => value + element);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.withOpacity(0.05),
        body: SingleChildScrollView(
          child: Container(
            // height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                border: Border.all(color: Colors.white)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Invoice Date :'),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black26),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        invoiceDate!,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Icon(
                                        Icons.calendar_today,
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Due Date :'),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black26),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        dueDate!,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Icon(
                                        Icons.calendar_today,
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //--------------------Customer-view-part----------------------//
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("To : "),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children:
                                    List.generate(customer.length, (index) {
                                  return TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${customer[index].customerName}: ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: customer[index]
                                            .serviceEntityName!
                                            .join(', '),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      if (index != customer.length - 1)
                                        const TextSpan(
                                            text:
                                                '\n'), // Adds a newline between items
                                    ],
                                  );
                                }),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //----------------------------------------------------------------------//
                //-------------------payment selection start------------------//
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text(
                                    "Payment Duration",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '*',
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0, bottom: 10.0),
                          child: Container(
                            height: 30,
                            child: DropdownButtonFormField2(
                              value: Provider.of<JobScheduleProvider>(context,
                                      listen: false)
                                  .selectedValue,
                              decoration: InputDecoration(
                                //Add isDense true and zero Padding.
                                //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                //Add more decoration as you want here
                                //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                              ),
                              hint: const Text(
                                'Select Payment Duration',
                                style: TextStyle(fontSize: 14),
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
                                Provider.of<JobScheduleProvider>(context,
                                        listen: false)
                                    .selectedValueOnChange(value);
                                _validatePaymentDurDropDown();
                                log("value onchange : ${value}");
                                if (value == "OnReceipt") {
                                  Provider.of<JobScheduleProvider>(context,
                                          listen: false)
                                      .selectedPayLetterDurationValue = null;
                                }

                                // Provider.of<JobScheduleProvider>(context, listen: false)
                                //     .depositAmount = 0;
                                // Provider.of<JobScheduleProvider>(context).selectedValue ==
                                //     'PayLater' ?
                                setDynamicDueDate();
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
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (paymentDurErrorText !=
                            null) // Display error message if it's not null
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              paymentDurErrorText!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12.0),
                            ),
                          ),
                        // const Gap(8),
                        Visibility(
                          visible: Provider.of<JobScheduleProvider>(context)
                                  .selectedValue ==
                              'PayLater',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  left: 8.0,
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          "Duration",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyle(color: Colors.red),
                                        )
                                      ],
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 6),
                                child: Container(
                                  height: 30,
                                  child: DropdownButtonFormField2(
                                    value: Provider.of<JobScheduleProvider>(
                                            context,
                                            listen: false)
                                        .selectedPayLetterDurationValue,
                                    hint: const Text(
                                      'Select Paylater Duration',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    decoration: InputDecoration(
                                      //Add isDense true and zero Padding.
                                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
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
                                          .selectedPayLetterDurationValueOnChange(
                                              value);
                                      _validatePaylaterDurDropdown();

                                      setDynamicDueDate();
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
                                      padding:
                                          EdgeInsets.only(left: 20, right: 10),
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
                              ),
                            ],
                          ),
                        ),
                        if (paylaterDurErrorText !=
                            null) // Display error message if it's not null
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              paylaterDurErrorText!,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12.0),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                //--------------------payment selection end-------------------//

                //--------------------------Services-Part-start-------------------------//
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.0),
                                  topRight: Radius.circular(5.0))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15.0),
                            child: Text(
                              'Services',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              children: List.generate(
                                  widget.addScheduleModel!.serviceList!.length,
                                  (index) {
                                // generateServiceTextField();
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 8,
                                        fit: FlexFit.tight,
                                        child: Text(
                                            "${widget.addScheduleModel.newServiceList![index].sERVICENAME.toString()} : "),
                                      ),
                                      Flexible(
                                          flex: 5,
                                          fit: FlexFit.tight,
                                          child: getServiceTextField(index)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Text('X')),
                                      Flexible(
                                        flex: 5,
                                        fit: FlexFit.tight,
                                        child: Text(
                                            "\$${widget.addScheduleModel.newServiceList![index].rATE}/${widget.addScheduleModel.newServiceList![index].rATEUNITNAME.toString()}"),
                                      )
                                      // Text(widget.addScheduleModel!.serviceList![index]..toString())
                                    ],
                                  ),
                                );
                              }),
                            )),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15.0),
                            child: Row(
                              children: [
                                const Flexible(
                                    flex: 8,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      'Sub Total',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                const Flexible(
                                    flex: 5,
                                    fit: FlexFit.tight,
                                    child: Text('')),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Text('')),
                                Flexible(
                                  flex: 5,
                                  fit: FlexFit.tight,
                                  child: Text(
                                    "\$${double.tryParse(totalServicePrice.toString())}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //------------------------------Services-Part-End-----------------------------//
                // SizedBox(
                //   height: 20,
                // ),
                //-----------------------------Material-Part-Start----------------------------//
                Visibility(
                  visible: widget.addScheduleModel.newMaterialList != null &&
                      widget.addScheduleModel.newMaterialList!.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0))),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 15.0),
                              child: Text(
                                'Materials',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                children: List.generate(
                                    widget.addScheduleModel!.newMaterialList!
                                        .length, (index) {
                                  // generateServiceTextField();
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 8,
                                          fit: FlexFit.tight,
                                          child: Text(
                                              "${widget.addScheduleModel.newMaterialList![index].mATERIALNAME.toString()} : "),
                                        ),
                                        Flexible(
                                            flex: 5,
                                            fit: FlexFit.tight,
                                            child: getMaterialTextField(index)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: Text('X')),
                                        Flexible(
                                          flex: 5,
                                          fit: FlexFit.tight,
                                          child: Text(
                                              "\$${widget.addScheduleModel.newMaterialList![index].rATE}/${widget.addScheduleModel.newMaterialList![index].mATERIALUNITNAME.toString()}"),
                                        )
                                        // Text(widget.addScheduleModel!.serviceList![index]..toString())
                                      ],
                                    ),
                                  );
                                }),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5.0),
                                    bottomRight: Radius.circular(5.0))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 15.0),
                              child: Row(
                                children: [
                                  const Flexible(
                                      flex: 8,
                                      fit: FlexFit.tight,
                                      child: Text(
                                        'Sub Total',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  const Flexible(
                                      flex: 5,
                                      fit: FlexFit.tight,
                                      child: Text('')),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Flexible(
                                      flex: 1,
                                      fit: FlexFit.tight,
                                      child: Text('')),
                                  Flexible(
                                    flex: 5,
                                    fit: FlexFit.tight,
                                    child: Text(
                                      "\$${totalMaterialPrice.toString()}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //----------------------------Material-Part-End---------------------------//

                //--------------------------Special-Charges-part--------------------------//
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.0),
                                  topRight: Radius.circular(5.0))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15.0),
                            child: Text(
                              'Special Charges',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Labor Charges : '),
                                    SizedBox(
                                      height: 30,
                                      width: 90,
                                      child: TextField(
                                        onTapOutside: (event) {
                                          if (laborChargesController
                                                  .text.isNotEmpty &&
                                              int.tryParse(
                                                      laborChargesController
                                                          .text) !=
                                                  null) {
                                            setState(() {
                                              laborChargesController.text =
                                                  '${laborChargesController.text}.0';
                                              laborChargesController.selection =
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        laborChargesController
                                                            .text.length),
                                              );
                                            });
                                          }
                                        },
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(
                                                r'^\d*\.?\d*'), // Regular expression to allow only numbers and one decimal point
                                          ),
                                        ],
                                        controller: laborChargesController,
                                        decoration: const InputDecoration(
                                          hintText: '\$ 0.0',
                                          hintStyle: TextStyle(
                                            color: Colors
                                                .grey, // Color of the dollar sign
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(),
                                          // prefixText:
                                          //     '\$ ', // Dollar sign as prefix
                                          // prefixStyle: TextStyle(
                                          //   color: Colors
                                          //       .grey, // Color of the dollar sign
                                          //   fontSize:
                                          //       15.0, // Font size of the dollar sign
                                          // ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Trip/Travel Charges : '),
                                    SizedBox(
                                      height: 30,
                                      width: 90,
                                      child: TextField(
                                        onTapOutside: (event) {
                                          if (tripTravelChargesController
                                                  .text.isNotEmpty &&
                                              int.tryParse(
                                                      tripTravelChargesController
                                                          .text) !=
                                                  null) {
                                            setState(() {
                                              tripTravelChargesController.text =
                                                  '${tripTravelChargesController.text}.0';
                                              tripTravelChargesController
                                                      .selection =
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        tripTravelChargesController
                                                            .text.length),
                                              );
                                            });
                                          }
                                        },
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(
                                                r'^\d*\.?\d*'), // Regular expression to allow only numbers and one decimal point
                                          ),
                                        ],
                                        controller: tripTravelChargesController,
                                        decoration: const InputDecoration(
                                          hintText: '\$ 0.0',
                                          hintStyle: TextStyle(
                                            color: Colors
                                                .grey, // Color of the dollar sign
                                          ),
                                          contentPadding: EdgeInsets.all(5),
                                          border: OutlineInputBorder(),
                                          // prefixText:
                                          //     '\$ ', // Dollar sign as prefix
                                          // prefixStyle: TextStyle(
                                          //   color: Colors
                                          //       .grey, // Color of the dollar sign
                                          //   fontSize:
                                          //       15.0, // Font size of the dollar sign
                                          // ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                children: List.generate(
                                    allSpecialChargesNameController.length,
                                    (index) {
                                  return getSpecialChargesTextField(index);
                                }),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        Colors.grey[300], // Background color
                                    onPrimary: Colors.black, // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Rounded corners
                                    ),
                                    elevation: 0, // No shadow
                                  ),
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.green, // Icon color
                                  ),
                                  label: const Text(
                                    'Add New Special Charge',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  onPressed: () {
                                    // Add your onPressed code here!
                                    generateSpecialTextField();
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Sub Total',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "\$${totalSpecialChargesPrice.toString()}",
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //-------------------------special-charges-end------------------------//

                //---------------------------discount-start---------------------------//
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.0),
                                  topRight: Radius.circular(5.0))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15.0),
                            child: Text(
                              'Discounts',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Discount'),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 90,
                                      child: TextField(
                                        onChanged: (value) {
                                          calculatePercentage();
                                        },
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(
                                                r'^\d*\.?\d*'), // Regular expression to allow only numbers and one decimal point
                                          ),
                                        ],
                                        controller: discountController,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 5.0,
                                                    horizontal: 10.0),
                                            hintText: '${hintText} 0.0',
                                            border: const OutlineInputBorder()),
                                        onTapOutside: (event) {
                                          if (discountController
                                                  .text.isNotEmpty &&
                                              int.tryParse(discountController
                                                      .text) !=
                                                  null) {
                                            setState(() {
                                              discountController.text =
                                                  '${discountController.text}.0';
                                              discountController.selection =
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: discountController
                                                        .text.length),
                                              );
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    ToggleButtons(
                                      isSelected: isSelected,
                                      onPressed: (int index) {
                                        setState(() {
                                          // Update selection state
                                          for (int i = 0;
                                              i < isSelected.length;
                                              i++) {
                                            isSelected[i] = i == index;
                                          }
                                          // Update hint text based on selected button
                                          if (index == 0) {
                                            hintText = '%';
                                          } else if (index == 1) {
                                            hintText = '\$';
                                          }

                                          calculatePercentage();
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(5.0),
                                      selectedBorderColor: Colors.grey,
                                      selectedColor: Colors.white,
                                      fillColor: Colors.green,
                                      color: Colors.black,
                                      constraints: const BoxConstraints(
                                        minHeight: 30.0,
                                        minWidth: 40.0,
                                      ),
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Text('%',
                                              style: TextStyle(fontSize: 18)),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Text('\$',
                                              style: TextStyle(fontSize: 18)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //-----------------------discount calculation end----------------------//

                //------------------------tax calculation start------------------------//
                Visibility(
                  visible:
                      Provider.of<JobScheduleProvider>(context, listen: false)
                          .taxList!
                          .isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0))),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 15.0),
                              child: Text(
                                'Taxes',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              children: List.generate(
                                  Provider.of<JobScheduleProvider>(context,
                                          listen: false)
                                      .taxList
                                      .length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          '${Provider.of<JobScheduleProvider>(context, listen: false).taxList[index].taxtypename}'),
                                      Text(
                                          '${Provider.of<JobScheduleProvider>(context, listen: false).taxList[index].taxrate}')
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5.0),
                                    bottomRight: Radius.circular(5.0))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Sub Total',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "\$${calculateTotalTaxPrice().toStringAsFixed(2)}",
                                    style: const TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                //-------------------------tax calculation end-------------------------//

                //-----------------------grand-total-calculation-----------------------//
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total'),
                              Text(((grandtotal - discountValue) +
                                      (totalTaxAmount))
                                  .toStringAsFixed(2))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Deposit'),
                              widget.addScheduleModel.deposit != null &&
                                      widget
                                          .addScheduleModel.deposit!.isNotEmpty
                                  ? Text(
                                      '${double.tryParse(widget.addScheduleModel.deposit ?? '0.0')}')
                                  : Text('0.0')
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Balance Due',
                                  style: TextStyle(color: Colors.white),
                                ),
                                // widget.addScheduleModel.deposit != null &&
                                //         widget
                                //             .addScheduleModel.deposit!.isNotEmpty
                                //     ?
                                Text(
                                  "\$${(((grandtotal + (totalTaxAmount)) - ((double.tryParse(widget.addScheduleModel.deposit?.isEmpty == true ? '0.0' : widget.addScheduleModel.deposit!) ?? 0.0) + discountValue))).toStringAsFixed(2)}",
                                  style: const TextStyle(color: Colors.white),
                                )
                                // :
                                // Text(grandtotal.toStringAsFixed(2))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //------------------------grand-calculation-end------------------------//

                //-------------------------------BUTTON--------------------------------//
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          // print(
                          //     "widget.addScheduleModel.deposit : ${widget.addScheduleModel.deposit}");
                          if (_validateServiceFields()) {
                            if (Provider.of<JobScheduleProvider>(context,
                                        listen: false)
                                    .selectedValue ==
                                null) {
                              _validatePaymentDurDropDown();
                            } else if (Provider.of<JobScheduleProvider>(context,
                                            listen: false)
                                        .selectedValue !=
                                    "OnReceipt" &&
                                Provider.of<JobScheduleProvider>(context,
                                            listen: false)
                                        .selectedPayLetterDurationValue ==
                                    null) {
                              _validatePaylaterDurDropdown();
                            } else {
                              if (widget.model != null) {
                                Provider.of<JobScheduleProvider>(context,
                                        listen: false)
                                    .updateInvoice(
                                        customerIds: widget.customerIdList,
                                        services: serviceQuantityMap,
                                        materials: materialQuantityMap,
                                        laborCharge: totalLaborChargesPrice,
                                        tripTavelCharge:
                                            totalTripTravelChargesPrice,
                                        specialCharges: specialChargesMap,
                                        discountValue: double.tryParse(
                                                discountController.text) ??
                                            0.0,
                                        discountMethod: isSelected[0] == true
                                            ? "percentage"
                                            : "fixedamount",
                                        deposit: widget.addScheduleModel
                                                        .deposit !=
                                                    null &&
                                                widget.addScheduleModel.deposit!
                                                    .isNotEmpty
                                            ? double.tryParse(widget
                                                    .addScheduleModel.deposit ??
                                                '0.0')!
                                            : 0.0,
                                        jobId: widget.addScheduleModel.jobId!,
                                        context: context,
                                        paymentTerm: pd! ?? "1");
                              } else {
                                Provider.of<JobScheduleProvider>(context,
                                        listen: false)
                                    .saveEditInvoice(
                                        customerIds: widget.customerIdList,
                                        services: serviceQuantityMap,
                                        materials: materialQuantityMap,
                                        laborCharge: totalLaborChargesPrice,
                                        tripTavelCharge: totalLaborChargesPrice,
                                        specialCharges: specialChargesMap,
                                        discountValue: double.tryParse(
                                                discountController.text) ??
                                            0.0,
                                        discountMethod: isSelected[0] == true
                                            ? "percentage"
                                            : "fixedamount",
                                        deposit: widget.addScheduleModel
                                                        .deposit !=
                                                    null &&
                                                widget.addScheduleModel.deposit!
                                                    .isNotEmpty
                                            ? double.tryParse(widget
                                                    .addScheduleModel.deposit ??
                                                '0.0')!
                                            : 0.0,
                                        jobId: widget.addScheduleModel.jobId!,
                                        context: context,
                                        paymentTerm: pd!);
                              }
                            }
                          }
                        },
                        child: widget.model == null
                            ? const CustomButton(
                                title: "Preview Invoice",
                                btnColor: AppColor.APP_BAR_COLOUR,
                              )
                            : const CustomButton(
                                title: "Update Invoice",
                                btnColor: AppColor.APP_BAR_COLOUR,
                              ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            GoRouter.of(context).pop();
                          },
                          child: const CustomButton(
                            title: "Cancel",
                            btnColor: AppColor.APP_BAR_COLOUR,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class CustomDetailsFieldWhite extends StatelessWidget {
  final String data;

  const CustomDetailsFieldWhite({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.white),
          child: Text(
            data,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        Gap(0.ss),
      ],
    );
  }
}
