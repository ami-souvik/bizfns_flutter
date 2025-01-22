import 'package:bizfns/core/route/RouteConstants.dart';
import 'package:bizfns/features/Admin/model/staffListResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../core/utils/colour_constants.dart';
import '../../../../core/utils/route_function.dart';
import '../../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../Staff/provider/staff_provider.dart';
import '../model/add_schedule_model.dart';

class AddStaffInJob extends StatefulWidget {
  final ValueChanged onStaffAdd;

  const AddStaffInJob({Key? key, required this.onStaffAdd}) : super(key: key);

  @override
  State<AddStaffInJob> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaffInJob> {
  List<StaffID> multipleSelected = [];

  // List<int> selectedIndex = [];

  AddScheduleModel model = AddScheduleModel.addSchedule;

  TextEditingController _searchController = TextEditingController(
    text: '',
  );

  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    Provider.of<TitleProvider>(context, listen: false).title =
        'Schedule New Modify';
    if (Provider.of<StaffProvider>(context, listen: false)
        .selectedIndex
        .isEmpty) {
      if (model.staffList != null) {
        if (model.staffList!.isNotEmpty) {
          Provider.of<StaffProvider>(context, listen: false)
              .selectedIndex
              .clear();
          Provider.of<StaffProvider>(context, listen: false)
              .selectedIndex
              .addAll(model.staffList!
                  .map((e) => int.parse(e.id.toString())!)
                  .toList());
          setState(() {});
        }
      }
    } else if (model.staffList != null) {
      if (model.staffList!.isNotEmpty) {
        // Provider.of<StaffProvider>(context, listen: false)
        //     .selectedIndex
        //     .clear();
        Provider.of<StaffProvider>(context, listen: false).selectedIndex.addAll(
            model.staffList!.map((e) => int.parse(e.id.toString())!).toList());
        setState(() {});
      }
    } else {
      // Provider.of<StaffProvider>(context, listen: false).selectedIndex.clear();
    }

    context.read<StaffProvider>().getStaffList(context);
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
                    "Select Staff",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (Provider.of<StaffProvider>(context, listen: false)
                        .selectedIndex
                        .isEmpty) {
                      if (model.staffList != null &&
                          model.staffList!.isNotEmpty) {
                        model.staffList!.clear();
                        Provider.of<StaffProvider>(context, listen: false)
                            .selectedIndex
                            .clear();
                      }
                    } else {
                      Provider.of<StaffProvider>(context, listen: false)
                          .selectedIndex
                          .clear();
                    }
                    Navigator.pop(context, 'staff');
                    print("clicking on close");
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
          // onTap: () => showMyDialog(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xff0bb0da), //#0bb0da
                    width: .8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add_circle_outline,
                      color: Color(0xff0bb0da),
                      size: 18,
                    ),
                    Gap(5),
                    Text(
                      "ADD STAFF",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),*/
          const Gap(10),
          context.watch<StaffProvider>().loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: Column(
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
                            // dg
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            enabled: true,
                            contentPadding: EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                            hintText: "Search by staff name",
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
                      /*Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15,),

                        child: TextField(
                          enabled: true,
                          autofocus: true,
                          //focusNode: focusNode,
                          cursorColor: AppColor.APP_BAR_COLOUR,
                          controller: _searchController,
                          onChanged: (val) {
                            if(val.length > 3){
                              int itemIndex = Provider.of<StaffProvider>(context,
                                  listen: false)
                                  .staffList!
                                  .map((element) =>
                                  element.staffFirstName.toLowerCase())
                                  .toList()
                                  .indexOf(val);

                              print('Item Index: $itemIndex');

                              //itemScrollController.jumpTo(index: 150);

                              if(itemIndex != -1){
                                itemScrollController.jumpTo(index: itemIndex);
                              }
                              setState(() {});
                            }else{
                              itemScrollController.jumpTo(index: 0);
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
                            hintText: 'Search by staff name',
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
                      const Gap(8),
                      Expanded(
                          flex: 5,
                          child: ListView(
                            children: [
                              ...Provider.of<StaffProvider>(context)
                                  .staffList!
                                  .where((element) =>
                                          element.staffFirstName
                                              .toLowerCase()
                                              .startsWith(_searchController.text
                                                  .toLowerCase()) ||
                                          element.staffLastName
                                              .toLowerCase()
                                              .startsWith(_searchController.text
                                                  .toLowerCase())
                                      //          ||
                                      // element.staffPhoneNo
                                      //     .startsWith(_searchController.text)
                                      )
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map(
                                    (e) => AbsorbPointer(
                                      absorbing: e.value.activeStatus == "0",
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0),
                                        child: CheckboxListTile(
                                          fillColor: e.value.activeStatus != "0"
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
                                            '${e.value.staffFirstName.capitalizeFirst} ${e.value.staffLastName.capitalizeFirst}',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: e.value.activeStatus != "0"
                                                  ? Colors.black
                                                  : Colors.black26,
                                            ),
                                          ),
                                          value: Provider.of<StaffProvider>(
                                                  context,
                                                  listen: false)
                                              .selectedIndex
                                              .contains(
                                                  int.parse(e.value.staffId)),
                                          onChanged: (val) {
                                            if (Provider.of<StaffProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedIndex
                                                .contains(int.parse(
                                                    e.value.staffId))) {
                                              Provider.of<StaffProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedIndex
                                                  .remove(int.parse(
                                                      e.value.staffId));
                                            } else {
                                              Provider.of<StaffProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedIndex
                                                  .add(int.parse(e.value.staffId
                                                      .toString()));
                                            }
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                            ],
                          )),
                      //------old staff search srollable list--------//
                      // Expanded(
                      //   child: ScrollablePositionedList.builder(
                      //     shrinkWrap: true,
                      //     itemScrollController: itemScrollController,
                      //     physics: const ScrollPhysics(),
                      //     itemCount:
                      //         context.watch<StaffProvider>().staffList!.length,
                      //     itemBuilder: (context, index) => Padding(
                      //       padding:
                      //           const EdgeInsets.symmetric(horizontal: 25.0),
                      //       child: CheckboxListTile(
                      //         fillColor: MaterialStateProperty.all<Color>(
                      //             AppColor.APP_BAR_COLOUR),
                      //         controlAffinity: ListTileControlAffinity.leading,
                      //         contentPadding: EdgeInsets.zero,
                      //         dense: true,
                      //         title: Text(
                      //           '${context.watch<StaffProvider>().staffList![index].staffFirstName.capitalizeFirst} ${context.watch<StaffProvider>().staffList![index].staffLastName.capitalizeFirst}',
                      //           style: const TextStyle(
                      //             fontSize: 16.0,
                      //             color: Colors.black,
                      //           ),
                      //         ),
                      //         value: selectedIndex.contains(index),
                      //         onChanged: (val) {
                      //           if (selectedIndex.contains(index)) {
                      //             selectedIndex.remove(index);
                      //           } else {
                      //             selectedIndex.add(index);
                      //           }
                      //           setState(() {});
                      //         },
                      //         /*value: checkListItems[index]["value"], onChanged: (value) {
                      //     setState(() {
                      //       checkListItems[index]["value"] = value;
                      //       if (multipleSelected.contains(checkListItems[index])) {
                      //         multipleSelected.remove(checkListItems[index]);
                      //       } else {
                      //         multipleSelected.add(checkListItems[index]);
                      //       }
                      //     });
                      //   },*/
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 4),
                              child: SizedBox(
                                height: 45,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      widget.onStaffAdd(true);
                                    },
                                    child: Text(
                                      '+ Add New Staff',
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
                                  onPressed: Provider.of<StaffProvider>(context,
                                                  listen: false)
                                              .selectedIndex
                                              .length >
                                          0
                                      ? () async {
                                          print("save button hit");
                                          for (int index = 0;
                                              index <
                                                  Provider.of<StaffProvider>(
                                                          context,
                                                          listen: false)
                                                      .staffList!
                                                      .length;
                                              index++) {
                                            if (Provider.of<StaffProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedIndex
                                                .contains(int.parse(
                                                    Provider.of<StaffProvider>(
                                                            context,
                                                            listen: false)
                                                        .staffList![index]
                                                        .staffId))) {
                                              String name =
                                                  '${Provider.of<StaffProvider>(context, listen: false).staffList![index].staffFirstName!.toString().capitalizeFirst} ${Provider.of<StaffProvider>(context, listen: false).staffList![index].staffLastName!.toString().capitalizeFirst}';
                                              multipleSelected.add(StaffID(
                                                index: index,
                                                id: Provider.of<StaffProvider>(
                                                        context,
                                                        listen: false)
                                                    .staffList![index]
                                                    .staffId,
                                                staffName: name,
                                              ));
                                            }
                                          }

                                          setState(() {});

                                          AddScheduleModel model =
                                              AddScheduleModel.addSchedule;

                                          model.staffList = multipleSelected;

                                          Navigator.pop(context, 'staff');
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
                    ],
                  ),
                ),
          /*const Gap(25),
          Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                      onPressed: selectedIndex.length>0? () async {
                        for (int index = 0; index < Provider.of<StaffProvider>(context, listen: false).staffList!.length; index++) {
                          if (selectedIndex.contains(index)) {
                            String name =
                                '${Provider.of<StaffProvider>(context, listen: false).staffList![index].staffFirstName!.toString().capitalizeFirst} ${Provider.of<StaffProvider>(context, listen: false).staffList![index].staffLastName!.toString().capitalizeFirst}';
                            multipleSelected.add(StaffID(
                              index: index,
                              id: Provider.of<StaffProvider>(context, listen: false)
                                  .staffList![index]
                                  .staffId,
                              staffName: name,
                            ));
                          }
                        }

                        setState(() {});

                        AddScheduleModel model = AddScheduleModel.addSchedule;

                        model.staffList = multipleSelected;

                        Navigator.pop(context, 'staff');
                      } : null,
                      child: Text('Select'),
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Colors.grey,
                        backgroundColor: const Color(0xFF093E52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      )
                  ),
                ),
              )
          ),*/
          /*GestureDetector(
            onTap: () {
              for (int index = 0; index < Provider.of<StaffProvider>(context, listen: false).staffList!.length; index++) {
                if (selectedIndex.contains(index)) {
                  String name =
                      '${Provider.of<StaffProvider>(context, listen: false).staffList![index].staffFirstName!.toString().capitalizeFirst} ${Provider.of<StaffProvider>(context, listen: false).staffList![index].staffLastName!.toString().capitalizeFirst}';
                  multipleSelected.add(StaffID(
                    index: index,
                    id: Provider.of<StaffProvider>(context, listen: false)
                        .staffList![index]
                        .staffId,
                    staffName: name,
                  ));
                }
              }

              setState(() {});

              AddScheduleModel model = AddScheduleModel.addSchedule;

              model.staffList = multipleSelected;

              Navigator.pop(context, 'staff');
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
