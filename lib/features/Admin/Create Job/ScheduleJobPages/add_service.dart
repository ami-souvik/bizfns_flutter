import 'dart:developer';

import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/add_schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizing/sizing.dart';

import '../../../../core/route/RouteConstants.dart';
import '../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../core/utils/route_function.dart';
import '../../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../Service/provider/service_provider.dart';
import '../../model/ServiceListResponse.dart';

class AddService extends StatefulWidget {
  final ValueChanged onServiceAdd;

  const AddService({Key? key, required this.onServiceAdd}) : super(key: key);

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  List<ServiceList> multipleSelected = [];

  AddScheduleModel model = AddScheduleModel.addSchedule;

  TextEditingController _searchController = TextEditingController();

  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    Provider.of<TitleProvider>(context, listen: false).title =
        'Schedule New Modify';
    context.read<ServiceProvider>().getServiceList(context);

    log("selectedIndex-=-=-==-=-=-=->${Provider.of<ServiceProvider>(context, listen: false).selectedIndex}");
    if (Provider.of<ServiceProvider>(context, listen: false)
        .selectedIndex
        .isEmpty) {
      if (model.serviceList != null) {
        if (model.serviceList!.isNotEmpty) {
          Provider.of<ServiceProvider>(context, listen: false)
              .selectedIndex
              .clear();
          Provider.of<ServiceProvider>(context, listen: false)
              .selectedIndex
              .addAll(model.serviceList!
                  .map((e) => int.parse(e.serviceID.toString()!))
                  .toList());

          setState(() {});
        }
      } else {}
    } else if (model.serviceList != null) {
      if (model.serviceList!.isNotEmpty) {
        // Provider.of<ServiceProvider>(context, listen: false)
        //     .selectedIndex
        //     .clear();
        Provider.of<ServiceProvider>(context, listen: false)
            .selectedIndex
            .addAll(model.serviceList!
                .map((e) => int.parse(e.serviceID.toString()!))
                .toList());

        setState(() {});
      }
      print("ulala");
    } else {
      // Provider.of<ServiceProvider>(context, listen: false)
      //     .selectedIndex
      //     .clear();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height / 1.5,
      decoration: BoxDecoration(
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
                    "Select Service",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Provider.of<ServiceProvider>(context, listen: false)
                    //     .selectedIndex
                    //     .clear();

                    if (Provider.of<ServiceProvider>(context, listen: false)
                        .selectedIndex
                        .isEmpty) {
                      if (model.serviceList != null &&
                          model.serviceList!.isNotEmpty) {
                        model.serviceList!.clear();
                        Provider.of<ServiceProvider>(context, listen: false)
                            .selectedIndex
                            .clear();
                      }
                    } else {
                      Provider.of<ServiceProvider>(context, listen: false)
                          .selectedIndex
                          .clear();
                    }
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
          /*const Gap(15),
          GestureDetector(
            onTap: () {
              */ /*setState(() {
                multipleSelected.clear();
                for (var element in checkListItems) {
                  element["value"] = true;
                  multipleSelected.add(element);
                }
              });*/ /*
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Container(
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFCCEEF7),
                ),
                child: const Text(
                  "All Service",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          ),*/
          const Gap(10),
          Expanded(
            child: context.watch<ServiceProvider>().loading
                ? const Center(
                    child: CircularProgressIndicator(),
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
                            hintText: "Search by service name",
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
                      Expanded(
                          flex: 5,
                          child: ListView(
                            children: [
                              ...Provider.of<ServiceProvider>(context)
                                  .allServiceList!
                                  .where((element) => element.serviceName!
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
                                    (e) => AbsorbPointer(
                                      absorbing:
                                          e.value.activeInactiveStatus == "0",
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0),
                                        child: CheckboxListTile(
                                          fillColor:
                                              e.value.activeInactiveStatus !=
                                                      "0"
                                                  ? MaterialStateProperty.all<
                                                          Color>(
                                                      AppColor.APP_BAR_COLOUR)
                                                  : MaterialStateProperty.all<
                                                      Color>(Colors.black26),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          title: Text(
                                            '${e.value.serviceName!.capitalizeFirst}',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color:
                                                  e.value.activeInactiveStatus !=
                                                          "0"
                                                      ? Colors.black
                                                      : Colors.black26,
                                            ),
                                          ),
                                          value: Provider.of<ServiceProvider>(
                                                  context,
                                                  listen: false)
                                              .selectedIndex
                                              .contains(e.value.serviceId),
                                          onChanged: (val) {
                                            if (Provider.of<ServiceProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedIndex
                                                .contains(int.parse(e
                                                    .value.serviceId
                                                    .toString()))) {
                                              Provider.of<ServiceProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedIndex
                                                  .remove(int.parse(e
                                                      .value.serviceId
                                                      .toString()));
                                            } else {
                                              Provider.of<ServiceProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedIndex
                                                  .add(int.parse(e
                                                      .value.serviceId
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
                                    ),
                                  )
                            ],
                          )),
                      // Expanded(
                      //   child: ScrollablePositionedList.builder(
                      //     shrinkWrap: true,
                      //     physics: const ScrollPhysics(),
                      //     itemScrollController: itemScrollController,
                      //     itemCount: context
                      //         .watch<ServiceProvider>()
                      //         .allServiceList
                      //         .length,
                      //     itemBuilder: (context, index) => Padding(
                      //       padding:
                      //           const EdgeInsets.symmetric(horizontal: 25.0),
                      //       child: CheckboxListTile(
                      //         controlAffinity: ListTileControlAffinity.leading,
                      //         contentPadding: EdgeInsets.zero,
                      //         dense: true,
                      //         fillColor: MaterialStateProperty.all<Color>(
                      //             AppColor.APP_BAR_COLOUR),
                      //         title: Text(
                      //           context
                      //               .watch<ServiceProvider>()
                      //               .allServiceList[index]
                      //               .serviceName!
                      //               .capitalizeFirst!,
                      //           style: const TextStyle(
                      //             fontSize: 16.0,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //         value: selectedIndex.contains(index),
                      //         onChanged: (value) {
                      //           setState(() {
                      //             if (selectedIndex.contains(index)) {
                      //               selectedIndex.remove(index);
                      //             } else {
                      //               selectedIndex.add(index);
                      //             }
                      //             setState(() {});
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const Gap(8),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 4),
                              child: SizedBox(
                                height: 45,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      widget.onServiceAdd(true);
                                      //   GoRouter.of(context)
                                      //       .pushNamed('job-add-service');
                                    },
                                    child: Text(
                                      '+ Add New Service',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.APP_BAR_COLOUR),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                              color: AppColor.APP_BAR_COLOUR
                                                  .withOpacity(0.5),
                                              width: 0.5)),
                                    )),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 4, right: 8),
                            child: SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                  onPressed: Provider.of<ServiceProvider>(
                                                  context,
                                                  listen: false)
                                              .selectedIndex
                                              .length >
                                          0
                                      ? () async {
                                          for (int index = 0;
                                              index <
                                                  Provider.of<ServiceProvider>(
                                                          context,
                                                          listen: false)
                                                      .allServiceList
                                                      .length;
                                              index++) {
                                            if (Provider.of<ServiceProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedIndex
                                                .contains(Provider.of<
                                                            ServiceProvider>(
                                                        context,
                                                        listen: false)
                                                    .allServiceList[index]
                                                    .serviceId)) {
                                              multipleSelected.add(ServiceList(
                                                index: index,
                                                serviceID: Provider.of<
                                                            ServiceProvider>(
                                                        context,
                                                        listen: false)
                                                    .allServiceList[index]
                                                    .serviceId!
                                                    .toString(),
                                                serviceName: Provider.of<
                                                            ServiceProvider>(
                                                        context,
                                                        listen: false)
                                                    .allServiceList[index]
                                                    .serviceName!,
                                              ));
                                              // Provider.of<ServiceProvider>(
                                              //         context,
                                              //         listen: false)
                                              //     .selectedIndex
                                              //     .clear();
                                            }
                                          }

                                          setState(() {});

                                          AddScheduleModel model =
                                              AddScheduleModel.addSchedule;

                                          model.serviceList = multipleSelected;

                                          Navigator.pop(context);
                                        }
                                      : null,
                                  child: Text('Select',
                                      style: TextStyle(fontSize: 14)),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    disabledBackgroundColor: Colors.grey,
                                    backgroundColor: const Color(0xFF093E52),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  )),
                            ),
                          )),
                        ],
                      ),

                      /*Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        enabled: true,
                        autofocus: true,
                        //focusNode: focusNode,
                        cursorColor: AppColor.APP_BAR_COLOUR,
                        controller: _searchController,
                        onChanged: (val) {
                          if(val.length > 3){
                            int itemIndex = Provider.of<ServiceProvider>(context,
                                listen: false)
                                .allServiceList
                                .map((element) =>
                                element.serviceName!.toLowerCase())
                                .toList()
                                .indexOf(val.toLowerCase());

                            print('Item Index: $itemIndex');

                            //itemScrollController.jumpTo(index: 150);

                            if(itemIndex != -1){
                              itemScrollController.jumpTo(index: itemIndex);
                            }
                            setState(() {});
                          }
                        },
                        decoration: const InputDecoration(
                          enabled: true,
                          contentPadding:
                          EdgeInsets.only(top: 2, bottom: 10, left: 10),
                          suffix: Padding(
                            padding:
                            EdgeInsets.only(right: 10, top: 5, bottom: 5),
                            child: Icon(Icons.search),
                          ),
                          hintText: 'Search by material name',
                          hintStyle: TextStyle(
                            fontSize: 13,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide:
                              BorderSide(color: AppColor.APP_BAR_COLOUR)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide:
                              BorderSide(color: AppColor.APP_BAR_COLOUR)),
                        ),
                      ),
                    ),*/

                      /*GestureDetector(
                      onTap: (){
                        widget.onServiceAdd(true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 10),
                        child: Container(
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColor.APP_BAR_COLOUR,
                            border: Border.all(
                              color: AppColor.APP_BAR_COLOUR,
                            ),
                          ),
                          child: const Text(
                            "+ Add New Service",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),*/
                    ],
                  ),
          ),

          /*GestureDetector(
            onTap: () {
              for (int index = 0; index < Provider.of<ServiceProvider>(context, listen: false).allServiceList.length; index++) {
                if (selectedIndex.contains(index)) {
                  multipleSelected.add(ServiceList(
                    index: index,
                    serviceID:
                        Provider.of<ServiceProvider>(context, listen: false)
                            .allServiceList[index]
                            .serviceId!
                            .toString(),
                    serviceName:
                        Provider.of<ServiceProvider>(context, listen: false)
                            .allServiceList[index]
                            .serviceName!,
                  ));
                }
              }

              setState(() {});

              AddScheduleModel model = AddScheduleModel.addSchedule;

              model.serviceList = multipleSelected;

              Navigator.pop(context);
            },
            child: const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: CustomButton(
                  title: 'Select',
                ),
              ),
            ),
          ),*/
          const Gap(15),
        ],
      ),
    );
  }
}
