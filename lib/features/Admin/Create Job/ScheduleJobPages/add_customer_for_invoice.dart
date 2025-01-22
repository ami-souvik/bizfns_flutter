import 'dart:developer';

import 'package:bizfns/features/Admin/Customer/provider/customer_provider.dart';
import 'package:bizfns/features/Admin/Material/provider/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/colour_constants.dart';
import '../../../../provider/job_schedule_controller.dart';
import '../model/add_schedule_model.dart';

class AddCustomerForInvoice extends StatefulWidget {
  final AddScheduleModel addScheduleModel;
  const AddCustomerForInvoice({
    super.key,
    required this.addScheduleModel,
  });

  @override
  State<AddCustomerForInvoice> createState() => _AddCustomerForInvoiceState();
}

class _AddCustomerForInvoiceState extends State<AddCustomerForInvoice> {
  TextEditingController _searchController = TextEditingController();
  List<int> selectedIndex = [];
  @override
  void initState() {
    super.initState();
    // context.read<CustomerProvider>().getCustomerList(context);
  }

  bool isSelectAll = false;
  void selectAll(bool select) {
    print("select : ${select}");
    if (select) {
      selectedIndex.clear();
      setState(() {
        widget.addScheduleModel.customer!.forEach((element) {
          selectedIndex.add(int.parse(element.customerId.toString()));
        });
      });
    } else {
      setState(() {
        selectedIndex.clear();
      });
    }
    setState(() {
      isSelectAll = select;
    });
  }

  @override
  void didUpdateWidget(AddCustomerForInvoice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mounted) {
      // context.pop();
      print("didUpdate called");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChange dep");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height / 1.5,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        color: Color(0xFFFFFF),
      ),
      child: Column(
        children: [
          Container(
            // width: size.w,
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
                    // Provider.of<ServiceProvider>(context, listen: false)
                    //     .selectedIndex
                    //     .clear();

                    // if (Provider.of<ServiceProvider>(context, listen: false)
                    //     .selectedIndex
                    //     .isEmpty) {
                    //   if (model.serviceList != null &&
                    //       model.serviceList!.isNotEmpty) {
                    //     model.serviceList!.clear();
                    //     Provider.of<ServiceProvider>(context, listen: false)
                    //         .selectedIndex
                    //         .clear();
                    //   }
                    // } else {
                    //   Provider.of<ServiceProvider>(context, listen: false)
                    //       .selectedIndex
                    //       .clear();
                    // }
                    Navigator.pop(context);
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
          const Gap(10),
          Expanded(
              child: widget.addScheduleModel.customer == null ||
                      widget.addScheduleModel.customer!.isEmpty
                  ? const Center(
                      child: Text('No Customer Found'),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                          ),
                          child: TextField(
                            enabled: true,
                            controller: _searchController,
                            cursorColor: AppColor.APP_BAR_COLOUR,
                            onChanged: (val) async {
                              setState(() {});
                              // if (val.length > 3) {
                              //   List<ServiceListData> allServiceList = [];
                              //   allServiceList = Provider.of<ServiceProvider>(
                              //           context,
                              //           listen: false)
                              //       .allServiceList;
                              //   int itemIndex1 = allServiceList.indexOf(
                              //       allServiceList.firstWhere((element) => element
                              //           .serviceName!
                              //           .toLowerCase()
                              //           .contains(val.toLowerCase())));

                              //   print('Item Index: $itemIndex1');

                              //   if (itemIndex1 != -1) {
                              //     itemScrollController.scrollTo(
                              //         index: itemIndex1,
                              //         duration: Duration(milliseconds: 200),
                              //         curve: Curves.easeInOut);
                              //   }
                              //   setState(() {});
                              // }
                            },
                            decoration: InputDecoration(
                              enabled: true,
                              contentPadding: EdgeInsets.only(
                                  left: 15, right: 15, bottom: 15),
                              hintText: "Search by customer name",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: AppColor.APP_BAR_COLOUR, width: 1.0),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.search),
                                color: Colors.grey,
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                        const Gap(8),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(''),
                              InkWell(
                                onTap: () {
                                  if (isSelectAll == true) {
                                    selectAll(false);
                                  } else {
                                    selectAll(true);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: isSelectAll
                                        ? Text(
                                            'Clear All',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0),
                                          )
                                        : Text(
                                            'Select All',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0),
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                            flex: 5,
                            child: ListView(
                              children: [
                                ...widget.addScheduleModel.customer!
                                    .where((element) => element.customerName!
                                            .toLowerCase()
                                            .startsWith(_searchController.text
                                                .toLowerCase())
                                        //          ||
                                        // element.staffLastName
                                        //     .toLowerCase()
                                        //     .startsWith(_searchController.text
                                        //         .toLowerCase())
                                        //          ||
                                        // element.staffPhoneNo
                                        //     .startsWith(_searchController.text)
                                        )
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map(
                                      (e) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0),
                                        child: CheckboxListTile(
                                          fillColor:
                                              // e.value.activeStatus !=
                                              //         "0"
                                              //     ?
                                              MaterialStateProperty.all<Color>(
                                                  AppColor.APP_BAR_COLOUR),
                                          // : MaterialStateProperty.all<
                                          //     Color>(Colors.black26),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          title: Text(
                                            '${e.value.customerName}',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color:
                                                    // e.value.activeStatus !=
                                                    //         "0"
                                                    //     ?
                                                    Colors.black
                                                // : Colors.black26,
                                                ),
                                          ),
                                          value: selectedIndex.contains(
                                              int.parse(e.value.customerId
                                                  .toString())),
                                          onChanged: (val) {
                                            if (selectedIndex.contains(
                                                int.parse(e.value.customerId
                                                    .toString()))) {
                                              selectedIndex.remove(int.parse(e
                                                  .value.customerId
                                                  .toString()));
                                            } else {
                                              selectedIndex.add(int.parse(e
                                                  .value.customerId
                                                  .toString()));
                                            }
                                            setState(() {});
                                          },
                                          /*value: checkListItems[index]["value"], onChanged: (value) {
                                                            setState(() {
                                                              checkListItems[index]["value"] = value;
                                                              if (multipleSelected.contains(checkListItems[index])) {
                                                                multipleSelected.remove(checkListItems[index]);
                                                              } else {
                                                                multipleSelected.add(checkListItems[index]);
                                                              }
                                                            });
                                                          },*/
                                        ),
                                      ),
                                    )
                              ],
                            )),
                        Gap(10),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                                onPressed: selectedIndex.isNotEmpty
                                    ? () {
                                        // context.pop();
                                        Provider.of<JobScheduleProvider>(
                                                context,
                                                listen: false)
                                            .getEditInvoice(
                                                jobId: widget
                                                    .addScheduleModel.jobId!,
                                                customerIds: selectedIndex,
                                                context: context,
                                                addScheduleModel:
                                                    widget.addScheduleModel);
                                        // .then(
                                        //     (value) => log("context pop"));

                                        //     .then(() {
                                        //   context.pop();
                                        // });

                                        // Navigator.of(context).push(
                                        //   MaterialPageRoute(builder:(context) {
                                        //     return AddEditInvoice
                                        //   },));

                                        // for (int index = 0;
                                        //     index <
                                        //         Provider.of<ServiceProvider>(
                                        //                 context,
                                        //                 listen: false)
                                        //             .allServiceList
                                        //             .length;
                                        //     index++) {
                                        //   if (Provider.of<ServiceProvider>(
                                        //           context,
                                        //           listen: false)
                                        //       .selectedIndex
                                        //       .contains(Provider.of<
                                        //                   ServiceProvider>(
                                        //               context,
                                        //               listen: false)
                                        //           .allServiceList[index]
                                        //           .serviceId)) {
                                        //     multipleSelected.add(ServiceList(
                                        //       index: index,
                                        //       serviceID: Provider.of<
                                        //                   ServiceProvider>(
                                        //               context,
                                        //               listen: false)
                                        //           .allServiceList[index]
                                        //           .serviceId!
                                        //           .toString(),
                                        //       serviceName: Provider.of<
                                        //                   ServiceProvider>(
                                        //               context,
                                        //               listen: false)
                                        //           .allServiceList[index]
                                        //           .serviceName!,
                                        //     ));
                                        //     // Provider.of<ServiceProvider>(
                                        //     //         context,
                                        //     //         listen: false)
                                        //     //     .selectedIndex
                                        //     //     .clear();
                                        //   }
                                        // }

                                        // setState(() {});

                                        // AddScheduleModel model =
                                        //     AddScheduleModel.addSchedule;

                                        // model.serviceList = multipleSelected;

                                        // Navigator.pop(context);
                                      }
                                    : null,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 60.0),
                                  child: Text('Create Invoice',
                                      style: TextStyle(fontSize: 14)),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  disabledBackgroundColor: Colors.grey,
                                  backgroundColor: const Color(0xFF093E52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                )),
                          ),
                        )
                      ],
                    ))
        ],
      ),
    );
  }
}
