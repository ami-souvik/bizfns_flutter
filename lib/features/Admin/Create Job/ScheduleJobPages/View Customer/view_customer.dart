import 'dart:developer';

import 'package:bizfns/features/Admin/Create%20Job/ScheduleJobPages/service_entity.dart';
import 'package:bizfns/features/Admin/Customer/model/customerListResponseModel.dart';
import 'package:bizfns/features/Admin/Customer/provider/customer_provider.dart';
import 'package:bizfns/provider/job_schedule_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';

import '../../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../../core/utils/colour_constants.dart';
import '../../model/add_schedule_model.dart';

class CustomerViewPage extends StatefulWidget {
  final ValueChanged onCustomerAdd;

  const CustomerViewPage({
    Key? key,
    required this.onCustomerAdd,
  }) : super(key: key);

  @override
  State<CustomerViewPage> createState() => _CustomerViewPageState();
}

class _CustomerViewPageState extends State<CustomerViewPage> {
  // var controller = Get.put(ViewCustomerController());
  //late ViewCustomerProvider controller;
  late CustomerProvider controller;

  late FocusNode focusNode;

  TextEditingController _searchController = TextEditingController();

  bool serviceEntityAdd = false;

  String customerID = '';
  String entityID = '';

  int? selectedCustomerIndex;

  // List selectedCustomerIndexArray = [];

  AddScheduleModel model = AddScheduleModel.addSchedule;

  final ScrollController _scrollController = ScrollController();

  bool hasDetails = false;

  String tempCustomerName = "";
  String tempCustomerID = "";
  List<String> tempServiceEntityID = [];
  List<String> deletedIDList = [];
  List<String> tempServicyEntityName = [];
  List<String> deletedNameList = [];

  List<CustomerData> deletedCustomer = [];

  //ViewCustomerProvider
  @override
  void initState() {
    Provider.of<TitleProvider>(context, listen: false).title =
        'Schedule New Modify';
    serviceEntityAdd = false;

    context.read<CustomerProvider>().customerServiceEntity.clear();

    /*controller = Provider.of<ViewCustomerProvider>(context,listen: false);
    controller.fetchCustomer();*/

    context.read<CustomerProvider>().getCustomerList(context);

    // if (model.customer.) {

    // }

    focusNode = FocusNode();

    /*todo: Implement Later if (model.customer != null) {
      tempCustomerName = model.customer!.customerName!;
      tempCustomerID = model.customer!.customerId!;
      tempServiceEntityID = model.customer!.serviceEntityID!;
    }*/

    setState(() {});

    /*if (model.customer != null) {
      dropdownValue.add(
        CustomerListData(
          customerAddress: '',
          customerPhoneNo: '',
          customerFirstName: model.customer!.customerName!,
          customerEmail: '',
          unpaidInvoice: [],
          customerCreatedAt: '',
          customerId: int.parse(model.customer!.customerId!),
          lifetimeAmount: '',
        ),
      );
      setState(() {});
    }*/

    //todo: if customer has data
    //todo: search the customer service entity list
    //todo: match the service entity
    //todo: open the entity form field

    if (model.customer != null) {
      model.tempCustomerList ??= [];

      if (model.tempCustomerList!.isEmpty) {
        model.tempCustomerList!.addAll(model.customer!);
      }

      _searchController = TextEditingController(
          //todo: Implement Later text: model.customer!.customerName!,
          );
      _searchController.selection = TextSelection.fromPosition(TextPosition(
        offset: _searchController.text.length,
      ));

      /*TODO: Implement Later Provider.of<CustomerProvider>(context, listen: false)
          .getCustomerServiceEntity(
        context,
        customerID: model.customer!.customerId!,
      );*/

      //index = 0;

      hasDetails = true;

      //todo: Implement Later entityID = model.serviceEntityID ?? '';

      //todo:  Implement Later  customerID = model.customer!.customerId!;

      serviceEntityAdd = true;

      setState(() {});
    }

    super.initState();
  }

  //String dropdownValue = "Customer1";
  List<CustomerListData> dropdownValue = [];
  bool isOpen = false;

  AddScheduleModel addScheduleModel = AddScheduleModel.addSchedule;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<String> customers = context.watch<CustomerProvider>().loading
        ? ['']
        : context
            .watch<CustomerProvider>()
            .customerList!
            .map((e) => e.customerFirstName)
            .toList();

    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        color: Colors.grey.withOpacity(0.05),
      ),
      height: size.height / 1.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 55,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              color: AppColor.APP_BAR_COLOUR,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Select Customer",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (model.tempCustomerList != null &&
                        model.tempCustomerList!.isEmpty &&
                        model.customer != null &&
                        model.customer!.isNotEmpty) {
                      model.customer!.clear();
                      model.tempCustomerList!.clear();
                    }

                    if (model.tempCustomerList != null) {
                      model.tempCustomerList!.clear();
                    }

                    log("customer close calling----->$tempCustomerName");
                    // if (model.customer != null) {
                    //   model.customer!.clear();
                    //   model.customer = null;
                    // }
                    Navigator.pop(context);
                    if (model.customer != null) {
                      if (model.customer!.isNotEmpty) {
                        setState(() {
                          Provider.of<JobScheduleProvider>(context,
                                  listen: false)
                              .historyList
                              .clear();
                        });
                      }
                    }
                  },
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
          Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: tempCustomerName.isEmpty
                ? TextField(
                    enabled: true,
                    focusNode: focusNode,
                    cursorColor: AppColor.APP_BAR_COLOUR,
                    controller: _searchController,
                    onChanged: (val) => setState(() {
                      // if (val.isEmpty) {
                      //   customerID = '';
                      //   serviceEntityAdd = false;
                      //   Provider.of<CustomerProvider>(context, listen: false)
                      //       .customerServiceEntity
                      //       .clear();
                      // }
                    }),
                    decoration: InputDecoration(
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      hintText: "Search by customer name or number",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColor.APP_BAR_COLOUR, width: 1.0),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        color: Colors.grey,
                        onPressed: () {},
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tempCustomerName),
                      InkWell(
                        onTap: () {
                          // if(tempServicyEntityName!=null){
                          if (tempServicyEntityName.isEmpty) {
                            if (addScheduleModel.tempCustomerList != null) {
                              addScheduleModel.tempCustomerList!.removeWhere(
                                  (element) =>
                                      element.customerId == tempCustomerID);

                              if (addScheduleModel.customer != null) {
                                if (addScheduleModel.customer!.isNotEmpty) {
                                  addScheduleModel.customer!.removeWhere(
                                      (element) =>
                                          element.customerId == tempCustomerID);
                                }
                              }

                            }
                          } else {
                            if (deletedIDList.isNotEmpty) {
                              deletedIDList.forEach((element) {
                                tempServiceEntityID.add(element);
                              });
                              deletedNameList.forEach((element) {
                                tempServicyEntityName.add(element);
                              });

                              addScheduleModel.tempCustomerList ??= [];

                              addScheduleModel.tempCustomerList!.add(
                                  CustomerData(
                                      customerId: tempCustomerID,
                                      customerName: tempCustomerName,
                                      serviceEntityId: tempServiceEntityID,
                                      serviceEntityName:
                                          tempServicyEntityName));
                            }
                          }
                          // }

                          tempCustomerName = "";

                          selectedCustomerIndex = null;
                          tempCustomerID = "";

                          /* addScheduleModel.tempCustomerList ??= [];


                          addScheduleModel.tempCustomerList!.add(
                              CustomerData(
                                  customerId: tempCustomerID,
                                  customerName: tempCustomerName,
                                  serviceEntityId:
                                  tempServiceEntityID,
                                  serviceEntityName:
                                  tempServicyEntityName));*/

                          Provider.of<CustomerProvider>(context, listen: false)
                              .customerServiceEntity
                              .clear();
                          setState(() {});

                          setState(() {});

                          Navigator.pop(context, 'reload-cust');
                        },
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
          ),
          Expanded(
            child: context.watch<CustomerProvider>().loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //this code is commented out because byDefault we want to show all hte
                      if (tempCustomerName.isEmpty)
                        Expanded(
                          flex: 5,
                          child: ListView(
                            children: [
                              ...Provider.of<CustomerProvider>(context)
                                  .customerList!
                                  .where((element) =>
                                      element.customerFirstName
                                          .toLowerCase()
                                          .startsWith(_searchController.text
                                              .toLowerCase()) ||
                                      element.customerLastName
                                          .toLowerCase()
                                          .startsWith(_searchController.text
                                              .toLowerCase()) ||
                                      element.customerPhoneNo
                                          .startsWith(_searchController.text))
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map(
                                    (e) => AbsorbPointer(
                                      absorbing: e.value.activeStatus == "0",
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          leading: Checkbox(
                                            fillColor: MaterialStateProperty
                                                .resolveWith<Color>(
                                                    (Set<MaterialState>
                                                        states) {
                                              if (states.contains(
                                                  MaterialState.disabled)) {
                                                return AppColor.APP_BAR_COLOUR;
                                              }
                                              return e.value.activeStatus != "0"
                                                  ? AppColor.APP_BAR_COLOUR
                                                  : Colors.black26;
                                            }),
                                            onChanged: (val) {
                                              Provider.of<JobScheduleProvider>(
                                                      context,
                                                      listen: false)
                                                  .historyList
                                                  .clear();
                                              if (val == true) {
                                                setState(() {
                                                  if (tempServiceEntityID
                                                      .isEmpty) {
                                                    if (model
                                                            .tempCustomerList !=
                                                        null) {
                                                      if (model
                                                          .tempCustomerList!
                                                          .isNotEmpty) {
                                                        if (model
                                                            .tempCustomerList!
                                                            .map((e) =>
                                                                e.customerId!)
                                                            .toList()
                                                            .contains(e.value!
                                                                .customerId!
                                                                .toString())) {
                                                          int indexOfCust = model
                                                              .tempCustomerList!
                                                              .map((e) =>
                                                                  e.customerId!)
                                                              .toList()
                                                              .indexOf(e.value!
                                                                  .customerId!
                                                                  .toString());

                                                          tempServiceEntityID.addAll(model
                                                              .tempCustomerList![
                                                                  indexOfCust]
                                                              .serviceEntityId!);
                                                          tempServicyEntityName
                                                              .addAll(model
                                                                  .tempCustomerList![
                                                                      indexOfCust]
                                                                  .serviceEntityName!);

                                                          setState(() {});
                                                        }
                                                      }
                                                    }
                                                  }

                                                  if (selectedCustomerIndex ==
                                                      Provider.of<CustomerProvider>(
                                                              context,
                                                              listen: false)
                                                          .customerList!
                                                          .indexOf(e.value)) {
                                                    selectedCustomerIndex =
                                                        null;
                                                  } else {
                                                    selectedCustomerIndex =
                                                        Provider.of<CustomerProvider>(
                                                                context,
                                                                listen: false)
                                                            .customerList!
                                                            .indexOf(e.value);
                                                  }
                                                  tempCustomerName =
                                                      '${e.value.customerFirstName.capitalizeFirst!} ${e.value.customerLastName.capitalizeFirst!}';
                                                  tempCustomerID = e
                                                      .value.customerId
                                                      .toString();
                                                  setState(() {});
                                                  Provider.of<CustomerProvider>(
                                                          context,
                                                          listen: false)
                                                      .getCustomerServiceEntity(
                                                    context,
                                                    customerID: tempCustomerID,
                                                  );
                                                });
                                              } else {
                                                // List aa=

                                                print(
                                                    'uncheck: ${e.value.customerId}');

                                                int index = model
                                                    .tempCustomerList!
                                                    .indexWhere((element) =>
                                                        element.customerId! ==
                                                        e.value.customerId
                                                            .toString());

                                                deletedCustomer!.add(model
                                                    .tempCustomerList![index]);

                                                /*model.customer!.removeWhere((element) =>
                                                element.customerId! ==
                                                    e.value.customerId
                                                        .toString());*/

                                                model.tempCustomerList!
                                                    .removeWhere((element) =>
                                                        element.customerId! ==
                                                        e.value.customerId
                                                            .toString());

                                                tempServiceEntityID.clear();
                                                tempServicyEntityName.clear();

                                                setState(() {});
                                              }
                                            },
                                            value: model.tempCustomerList ==
                                                    null
                                                ? false
                                                : model.tempCustomerList!
                                                        .isEmpty
                                                    ? false
                                                    : model.tempCustomerList!
                                                        .map((e1) =>
                                                            e1.customerId)
                                                        .toList()
                                                        .contains(e
                                                            .value.customerId
                                                            .toString()),
                                          ),
                                          title: Text(
                                            '${e.value.customerFirstName.capitalizeFirst!} ${e.value.customerLastName.capitalizeFirst!}',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: e.value.activeStatus != "0"
                                                  ? Colors.black
                                                  : Colors.black26,
                                            ),
                                          ),
                                          subtitle: Text(
                                            e.value.customerPhoneNo,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: e.value.activeStatus != "0"
                                                  ? Colors.black
                                                  : Colors.black26,
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              tempServiceEntityID.clear();
                                              tempServicyEntityName.clear();

                                              if (tempServiceEntityID.isEmpty) {
                                                if (model.tempCustomerList !=
                                                    null) {
                                                  if (model.tempCustomerList!
                                                      .isNotEmpty) {
                                                    if (model.tempCustomerList!
                                                        .map((e) =>
                                                            e.customerId!)
                                                        .toList()
                                                        .contains(e
                                                            .value!.customerId!
                                                            .toString())) {
                                                      int indexOfCust = model
                                                          .tempCustomerList!
                                                          .map((e) =>
                                                              e.customerId!)
                                                          .toList()
                                                          .indexOf(e.value!
                                                              .customerId!
                                                              .toString());

                                                      print(
                                                          'Index of cust: $indexOfCust');

                                                      tempServiceEntityID
                                                          .addAll(model
                                                              .tempCustomerList![
                                                                  indexOfCust]
                                                              .serviceEntityId!);

                                                      print(
                                                          'Total Entities: ${tempServiceEntityID.length}');

                                                      tempServicyEntityName
                                                          .addAll(model
                                                              .tempCustomerList![
                                                                  indexOfCust]
                                                              .serviceEntityName!);
                                                    }
                                                  }
                                                }
                                              }

                                              // if(tempServiceEntityID.isEmpty){
                                              //   if(model.customer != null){
                                              //     if(model.customer!.isNotEmpty){

                                              //       if(model.customer!.map((e) => e.customerId!).toList().contains(e.value!.customerId!.toString())){
                                              //         int indexOfCust = model.customer!.map((e) => e.customerId!).toList().indexOf(e.value!.customerId!.toString());

                                              //         tempServiceEntityID.addAll(model.customer![indexOfCust].serviceEntityId!);
                                              //         tempServicyEntityName.addAll(model.customer![indexOfCust].serviceEntityName!);
                                              //       }
                                              //     }
                                              //   }
                                              // }

                                              if (selectedCustomerIndex ==
                                                  Provider.of<CustomerProvider>(
                                                          context,
                                                          listen: false)
                                                      .customerList!
                                                      .indexOf(e.value)) {
                                                selectedCustomerIndex = null;
                                              } else {
                                                selectedCustomerIndex = Provider
                                                        .of<CustomerProvider>(
                                                            context,
                                                            listen: false)
                                                    .customerList!
                                                    .indexOf(e.value);
                                              }
                                              tempCustomerName =
                                                  '${e.value.customerFirstName.capitalizeFirst!} ${e.value.customerLastName.capitalizeFirst!}';
                                              tempCustomerID =
                                                  e.value.customerId.toString();
                                              setState(() {});
                                              Provider.of<CustomerProvider>(
                                                      context,
                                                      listen: false)
                                                  .getCustomerServiceEntity(
                                                context,
                                                customerID: tempCustomerID,
                                              );
                                            });
                                            setState(() {
                                              print(
                                                  'Temp Service Entity Length: ${tempServiceEntityID.length}');
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ],
                          ),
                        ),
                      if (Provider.of<CustomerProvider>(context)
                          .customerServiceEntity
                          .isNotEmpty)
                        Expanded(
                          flex: 5,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: Provider.of<CustomerProvider>(context)
                                .customerServiceEntity
                                .length,
                            itemBuilder: (_, index) => ListTile(
                              title: Text(
                                Provider.of<CustomerProvider>(context)
                                    .customerServiceEntity[index]
                                    .serviceentityname
                                    .toString(),
                              ),
                              leading: Checkbox(
                                fillColor: MaterialStateProperty.all<Color>(
                                    AppColor.APP_BAR_COLOUR),
                                value: tempServiceEntityID.contains(
                                    Provider.of<CustomerProvider>(context,
                                            listen: false)
                                        .customerServiceEntity[index]
                                        .pkserviceentityid)
                                //          ||
                                // model.customer![0].serviceEntityId!
                                //     .contains(Provider.of<CustomerProvider>(
                                //             context,
                                //             listen: false)
                                //         .customerServiceEntity[index]
                                //         .pkserviceentityid!)
                                ,
                                onChanged: (bool? value) {
                                  if (value!) {
                                    tempServiceEntityID.add(
                                        Provider.of<CustomerProvider>(context,
                                                listen: false)
                                            .customerServiceEntity[index]
                                            .pkserviceentityid!);
                                    tempServicyEntityName.add(
                                        Provider.of<CustomerProvider>(context,
                                                listen: false)
                                            .customerServiceEntity[index]
                                            .serviceentityname
                                            .toString());

                                    if (deletedIDList.contains(
                                        Provider.of<CustomerProvider>(context,
                                                listen: false)
                                            .customerServiceEntity[index]
                                            .pkserviceentityid!)) {
                                      deletedIDList.remove(
                                          Provider.of<CustomerProvider>(context,
                                                  listen: false)
                                              .customerServiceEntity[index]
                                              .pkserviceentityid!);

                                      deletedNameList.remove(
                                          Provider.of<CustomerProvider>(context,
                                                  listen: false)
                                              .customerServiceEntity[index]
                                              .pkserviceentityid!);
                                    }
                                  } else {
                                    tempServiceEntityID.remove(
                                        Provider.of<CustomerProvider>(context,
                                                listen: false)
                                            .customerServiceEntity[index]
                                            .pkserviceentityid!);

                                    deletedIDList.add(
                                        Provider.of<CustomerProvider>(context,
                                                listen: false)
                                            .customerServiceEntity[index]
                                            .pkserviceentityid!);

                                    tempServicyEntityName.remove(
                                        Provider.of<CustomerProvider>(context,
                                                listen: false)
                                            .customerServiceEntity[index]
                                            .serviceentityname!);

                                    deletedNameList.add(
                                        Provider.of<CustomerProvider>(context,
                                                listen: false)
                                            .customerServiceEntity[index]
                                            .pkserviceentityid!);
                                  }

                                  print('Temp ID: $tempCustomerID');

                                  tempServiceEntityID.forEach((element) {
                                    print('Item Available: ${element}');
                                  });

                                  /* if (tempServiceEntityID.isEmpty) {
                                    addScheduleModel.tempCustomerList!.removeWhere(
                                        (element) =>
                                            element.customerId ==
                                            tempCustomerID);
                                  }*/

                                  setState(() {});
                                },
                              ),
                              // subtitle: const Text(
                              //   'View / Edit',
                              //   style: TextStyle(
                              //     color: AppColor.APP_BAR_COLOUR,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              onTap: () async {
                                // showDialog(
                                //   context: context,
                                //   builder: (_) {
                                //     return Dialog(child: StatefulBuilder(
                                //       builder: (_, StateSetter setter) {
                                //         return ServiceEntityWidget(
                                //           hasDetails: true,
                                //           customerID: tempCustomerID,
                                //           entityID:
                                //               Provider.of<CustomerProvider>(
                                //                       context,
                                //                       listen: false)
                                //                   .customerServiceEntity[index]
                                //                   .pkserviceentityid!,
                                //           onEntityAdd: (val) {
                                //             /*todo: Implement Later tempServiceEntityID = Provider.of<
                                //                         CustomerProvider>(
                                //                     context,
                                //                     listen: false)
                                //                 .customerServiceEntity[index]
                                //                 .pkserviceentityid!;*/
                                //             setState(() {});
                                //             Provider.of<TitleProvider>(context,
                                //                     listen: false)
                                //                 .changeTitle('');
                                //             GoRouter.of(context).pop();
                                //           },
                                //         );
                                //       },
                                //     ));
                                //   },
                                // );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          Row(
            children: [
              if (tempCustomerName.isEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () async {
                            widget.onCustomerAdd(true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: AppColor.APP_BAR_COLOUR
                                        .withOpacity(0.5),
                                    width: 0.5)),
                          ),
                          child: const Text(
                            '+ Add new Customer',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12, color: AppColor.APP_BAR_COLOUR),
                          )),
                    ),
                  ),
                ),
              if (tempCustomerName.isNotEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: StatefulBuilder(
                                      builder: (_, StateSetter setter) {
                                        return ServiceEntityWidget(
                                          hasDetails: false,
                                          customerID: tempCustomerID,
                                          entityID: '',
                                          onEntityAdd: (val) async {
                                            Provider.of<TitleProvider>(context,
                                                    listen: false)
                                                .changeTitle('');
                                            await Provider.of<CustomerProvider>(
                                                    context,
                                                    listen: false)
                                                .getCustomerServiceEntity(
                                              context,
                                              customerID: tempCustomerID,
                                            );
                                            await Provider.of<
                                                        JobScheduleProvider>(
                                                    context,
                                                    listen: false)
                                                .addServiceEntity(
                                                    context, tempCustomerID);
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
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: AppColor.APP_BAR_COLOUR
                                        .withOpacity(0.5),
                                    width: 0.5)),
                          ),
                          child: const Text(
                            '+ Add new Service Object',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12, color: AppColor.APP_BAR_COLOUR),
                          )),
                    ),
                  ),
                ),
              tempCustomerID.isEmpty
                  ? Expanded(
                      child: Padding(
                      padding: const EdgeInsets.only(left: 4, right: 8),
                      child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          onPressed: model.tempCustomerList != null &&
                                  model.tempCustomerList!.isNotEmpty
                              ? () async {
                                  model.customer!.clear();

                                  model.tempCustomerList!.forEach((element) {
                                    print(element.toJson().toString());
                                  });

                                  model.tempCustomerList!.forEach((element) {
                                    if (!model.customer!
                                        .map((e) => e.customerId!)
                                        .toList()
                                        .contains(element.customerId!)) {
                                      model.customer!.add(element);
                                    }
                                  });

                                  addScheduleModel!.customer!.removeWhere(
                                      (element) => element.customerId!.isEmpty);

                                  List<Map<String, dynamic>> arrayOfObjects =
                                      addScheduleModel!.customer!
                                          .map((e) => {
                                                "customerId": int.parse(
                                                    e.customerId.toString())
                                              })
                                          .toList();
                                  Provider.of<JobScheduleProvider>(context,
                                          listen: false)
                                      .getCustomerServiceHistory(
                                          customerId: arrayOfObjects,
                                          context: context);
                                  Navigator.pop(context);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            disabledBackgroundColor: Colors.grey,
                            backgroundColor: const Color(0xFF093E52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Select',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ))
                  : tempServiceEntityID.isNotEmpty
                      ? Expanded(
                          child: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 8),
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                if (tempServiceEntityID.isNotEmpty) {
                                  addScheduleModel.customer ??= [];

                                  tempServiceEntityID.forEach((element) {
                                    print('ID: $element');
                                  });

                                  tempServicyEntityName.forEach((element) {
                                    print('name: $element');
                                  });

                                  addScheduleModel.tempCustomerList ??= [];

                                  if (addScheduleModel.tempCustomerList !=
                                      null) {
                                    if (addScheduleModel.tempCustomerList!
                                        .map((e) => e.customerId)
                                        .toList()
                                        .contains(tempCustomerID)) {
                                      //todo: existing customer add the service entity

                                      int index = addScheduleModel
                                          .tempCustomerList!
                                          .map((e) => e.customerId)
                                          .toList()
                                          .indexOf(tempCustomerID);

                                      addScheduleModel.tempCustomerList!
                                          .removeAt(index);

                                      addScheduleModel.tempCustomerList!.insert(
                                          index,
                                          CustomerData(
                                              customerId: tempCustomerID,
                                              customerName: tempCustomerName,
                                              serviceEntityId:
                                                  tempServiceEntityID,
                                              serviceEntityName:
                                                  tempServicyEntityName));

                                      addScheduleModel!.tempCustomerList!
                                          .removeWhere((element) =>
                                              element.customerId!.isEmpty);

                                      List<Map<String, dynamic>>
                                          arrayOfObjects = addScheduleModel!
                                              .tempCustomerList!
                                              .map((e) => {
                                                    "customerId": int.parse(
                                                        e.customerId.toString())
                                                  })
                                              .toList();
                                      Provider.of<JobScheduleProvider>(context,
                                              listen: false)
                                          .getCustomerServiceHistory(
                                              customerId: arrayOfObjects,
                                              context: context);
                                    } else {
                                      addScheduleModel.tempCustomerList!.add(
                                          CustomerData(
                                              customerId: tempCustomerID,
                                              customerName: tempCustomerName,
                                              serviceEntityId:
                                                  tempServiceEntityID,
                                              serviceEntityName:
                                                  tempServicyEntityName));

                                      addScheduleModel!.tempCustomerList!
                                          .removeWhere((element) =>
                                              element.customerId == null ||
                                              element.customerId!.isEmpty);

                                      //------------this function getting customer service history---------//
                                      List<Map<String, dynamic>>
                                          arrayOfObjects = addScheduleModel!
                                              .tempCustomerList!
                                              .map((e) => {
                                                    "customerId": int.parse(
                                                        e.customerId.toString())
                                                  })
                                              .toList();
                                      Provider.of<JobScheduleProvider>(context,
                                              listen: false)
                                          .getCustomerServiceHistory(
                                              customerId: arrayOfObjects,
                                              context: context);
                                      //-------------------------------------------------------------------//
                                    }
                                  }
                                }

                                tempCustomerName = "";

                                selectedCustomerIndex = null;
                                tempCustomerID = "";

                                Provider.of<CustomerProvider>(context,
                                        listen: false)
                                    .customerServiceEntity
                                    .clear();
                                setState(() {});

                                setState(() {});

                                Navigator.pop(context, 'reload-cust');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                disabledBackgroundColor: Colors.grey,
                                backgroundColor: const Color(0xFF093E52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Select',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ))
                      : Expanded(
                          child: Padding(
                          padding: const EdgeInsets.only(left: 4, right: 8),
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                disabledBackgroundColor: Colors.grey,
                                backgroundColor: const Color(0xFF093E52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Select',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        )),
            ],
          ),
          Gap(15.ss)
          /*customerID.isNotEmpty
                    ? const SizedBox()
                    : _searchController.text.length < 3
                        ? const SizedBox()
                        : Expanded(
                            flex: 3,
                            child: ListView(
                              children: [
                                ...Provider.of<CustomerProvider>(context,
                                        listen: false)
                                    .customerList!
                                    .where((element) =>
                                        element.customerFirstName
                                            .toLowerCase()
                                            .startsWith(
                                              _searchController.text
                                                  .trim()
                                                  .toLowerCase(),
                                            ) ||
                                        element.customerLastName
                                            .toLowerCase()
                                            .startsWith(
                                              _searchController.text
                                                  .trim()
                                                  .toLowerCase(),
                                            ) ||
                                        element.customerPhoneNo.startsWith(
                                          _searchController.text,
                                        ))
                                    .toList()
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: InkWell(
                                          onTap: () {
                                            Provider.of<CustomerProvider>(context,
                                                    listen: false)
                                                .getCustomerServiceEntity(
                                              context,
                                              customerID: e.customerId.toString(),
                                            );
                                            _searchController.text =
                                                '${e.customerFirstName} ${e.customerLastName}';
                                            _searchController.selection =
                                                TextSelection.fromPosition(
                                                    TextPosition(
                                              offset:
                                                  _searchController.text.length,
                                            ));
                                            customerID = e.customerId.toString();
                                            addScheduleModel.customer =
                                                CustomerData(
                                              customerId: customerID,
                                              customerName:
                                                  '${e.customerFirstName} ${e.customerLastName}',
                                            );
                                            setState(() {});
                                            },
                                          child: Container(
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      '${e.customerFirstName} ${e.customerLastName}'),
                                                  Text(e.customerPhoneNo),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ],
                            ),
                          ),
                context.read<CustomerProvider>().loading
                    ? const Center(child: CircularProgressIndicator())
                    : context
                            .read<CustomerProvider>()
                            .customerServiceEntity
                            .isEmpty
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              child: Scrollbar(
                                controller: _scrollController,
                                radius: Radius.circular(12),
                                interactive: true,
                                thickness: 10,
                                scrollbarOrientation: ScrollbarOrientation.bottom,
                                trackVisibility: true,
                                child: ListView.separated(
                                  itemCount: context
                                      .read<CustomerProvider>()
                                      .customerServiceEntity
                                      .length,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (_, index) => const SizedBox(
                                    width: 10,
                                  ),
                                  itemBuilder: (_, itemIndex) {
                                    if (model.serviceEntityID != null) {
                                      index = context
                                          .read<CustomerProvider>()
                                          .customerServiceEntity
                                          .map((e) => e.pkserviceentityid!)
                                          .toList()
                                          .indexOf(model.serviceEntityID!);
                                    }

                                    return InkWell(
                                      onTap: () {
                                        model.serviceEntityID = null;
                                        setState(() {
                                          index = index == itemIndex
                                              ? null
                                              : itemIndex;
                                          serviceEntityAdd = index == itemIndex;
                                          hasDetails = true;
                                          print('CLicking ID: ' +
                                              context
                                                  .read<CustomerProvider>()
                                                  .customerServiceEntity[
                                                      itemIndex]
                                                  .pkserviceentityid
                                                  .toString());

                                          entityID = context
                                              .read<CustomerProvider>()
                                              .customerServiceEntity[itemIndex]
                                              .pkserviceentityid
                                              .toString();

                                          Provider.of<JobScheduleProvider>(
                                                  context,
                                                  listen: false)
                                              .getServiceEntityDetails(
                                            context,
                                            customerID,
                                            entityID,
                                          );

                                          /*context
                                            .read<JobScheduleProvider>()
                                            .getServiceEntityDetails(
                                              context,
                                              widget.customerID,
                                              widget.entityID,
                                            );*/

                                          /*entityID = context
                                            .read<CustomerProvider>()
                                            .customerServiceEntity[itemIndex]
                                            .pkserviceentityid
                                            .toString();*/
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          color: index == itemIndex &&
                                                  serviceEntityAdd
                                              ? AppColor.APP_BAR_COLOUR
                                                  .withOpacity(0.4)
                                              : const Color(0xFFcceef7),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                  text: 'ID: ',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColor.APP_BAR_COLOUR,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: context
                                                              .read<
                                                                  CustomerProvider>()
                                                              .customerServiceEntity[
                                                                  itemIndex]
                                                              .pkserviceentityid ??
                                                          'Entity ID',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.grey),
                                                    )
                                                  ]),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: 'Name: ',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColor.APP_BAR_COLOUR,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: context
                                                              .read<
                                                                  CustomerProvider>()
                                                              .customerServiceEntity[
                                                                  itemIndex]
                                                              .serviceentityname ??
                                                          'Entity Name',
                                                      style: const TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                customerID.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              print('Entity ID: $entityID');
                              entityID = '';
                              hasDetails = false;
                              serviceEntityAdd = !serviceEntityAdd;
                              index = null;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Offstage(
                                offstage: serviceEntityAdd,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColor.APP_BAR_COLOUR,
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      '+ Add New Service Object',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Offstage(
                                offstage: !serviceEntityAdd,
                                child: Transform.rotate(
                                  angle: 0.815,
                                  child: const Icon(
                                    Icons.add,
                                    size: 30,
                                    color: AppColor.APP_BAR_COLOUR,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                serviceEntityAdd
                    ? Expanded(
                        flex: 8,
                        child: ServiceEntityWidget(
                          hasDetails: hasDetails,
                          customerID: customerID,
                          entityID: entityID,
                          onEntityAdd: (val) {
                            Provider.of<TitleProvider>(context, listen: false)
                                .changeTitle('');
                            GoRouter.of(context).pop();
                          },
                        ),
                      )
                    : const SizedBox(
                        height: 10,
                      ),
                const Gap(15),
                addNewCustomerButton(context), */
        ],
      ),
    );
  }

  Widget addNewCustomerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: InkWell(
        onTap: () {
          //Navigate(context, add_customer);
          GoRouter.of(context).pushNamed('job-add-customer').then((value) {
            context.read<CustomerProvider>().getCustomerList(context);
          });
          context.read<CustomerProvider>().customerServiceEntity.clear();

          /*controller = Provider.of<ViewCustomerProvider>(context,listen: false);
    controller.fetchCustomer();*/

          focusNode = FocusNode();

          /*if (model.customer != null) {
            dropdownValue.add(
              CustomerListData(
                customerAddress: '',
                customerPhoneNo: '',
                customerFirstName: model.customer!.customerName!,
                customerEmail: '',
                unpaidInvoice: [],
                customerCreatedAt: '',
                customerId: int.parse(model.customer!.customerId!),
                lifetimeAmount: '',
              ),
            );
            setState(() {});
          }*/
        },
        child: Container(
          height: 30,
          margin:
              EdgeInsets.only(right: MediaQuery.of(context).size.width - 180),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          decoration: BoxDecoration(
              color: AppColor.APP_BAR_COLOUR,
              borderRadius: const BorderRadius.all(
                Radius.circular(4),
              ),
              border: Border.all(
                color: AppColor.APP_BAR_COLOUR,
              )),
          child: const Text(
            '+ Add New Customer',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
