import 'dart:developer';

import 'package:bizfns/core/route/RouteConstants.dart';
import 'package:bizfns/features/Admin/Create%20Job/model/add_schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/utils/bizfns_layout_widget.dart';
import '../../../../core/utils/colour_constants.dart';
import '../../../../core/utils/route_function.dart';
import '../../../../core/widgets/AddModifyScheduleCustomField/custom_button.dart';
import '../../Material/provider/material_provider.dart';
import '../../model/materialListResponse.dart';

class AddMaterial extends StatefulWidget {
  final ValueChanged onMaterialAdd;

  // final bool isEdit;
  //
  // final AddScheduleModel prevModel;

  const AddMaterial({
    Key? key,
    required this.onMaterialAdd,
  }) : super(key: key);

  @override
  State<AddMaterial> createState() => _AddMaterialState();
}

class _AddMaterialState extends State<AddMaterial> {
  List<MaterialList> multipleSelected = [];

  // List<int> selectedIndex = [];

  AddScheduleModel model = AddScheduleModel.addSchedule;

  TextEditingController _searchController = TextEditingController();

  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  void initState() {
    Provider.of<TitleProvider>(context, listen: false).title =
        'Schedule New Modify';
    context.read<MaterialProvider>().getMaterialListApi(context);
    log("at first selected index=-=-=-=-=-=-=-=-=-=->${Provider.of<MaterialProvider>(context, listen: false).selectedIndex}");
    // if(widget.isEdit == false){
    if (Provider.of<MaterialProvider>(context, listen: false)
        .selectedIndex
        .isEmpty) {
      if (model.materialList != null) {
        if (model.materialList!.isNotEmpty) {
          Provider.of<MaterialProvider>(context, listen: false)
              .selectedIndex
              .clear();
          Provider.of<MaterialProvider>(context, listen: false)
              .selectedIndex
              .addAll(model.materialList!
                  .map((e) => int.parse(e.materialID.toString()!))
                  .toList());

          log("=-=-=-=-=-=-=-=-=-=->${Provider.of<MaterialProvider>(context, listen: false).selectedIndex}");
          setState(() {});
        }
      }
    } else if (model.materialList != null) {
      if (model.materialList!.isNotEmpty) {
        // Provider.of<MaterialProvider>(context, listen: false)
        //     .selectedIndex
        //     .clear();
        Provider.of<MaterialProvider>(context, listen: false)
            .selectedIndex
            .addAll(model.materialList!
                .map((e) => int.parse(e.materialID.toString()!))
                .toList());

        log("=-=-=-=-=-=-=-=-=-=->${Provider.of<MaterialProvider>(context, listen: false).selectedIndex}");
        setState(() {});
      }
    } else {
      // Provider.of<MaterialProvider>(context, listen: false)
      //     .selectedIndex
      //     .clear();
    }

    // }else{
    //   print("we are goint in prev model");
    //   if(widget.prevModel.materialList != null){
    //     if (widget.prevModel.materialList!.isNotEmpty) {
    //       selectedIndex.addAll(widget.prevModel.materialList!.map((e) => e.index!).toList());
    //       setState(() {});
    //     }
    //   }
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height / 1.5,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
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
                    "Select Material",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (Provider.of<MaterialProvider>(context, listen: false)
                        .selectedIndex
                        .isEmpty) {
                      if (model.materialList != null &&
                          model.materialList!.isNotEmpty) {
                        model.materialList!.clear();
                        Provider.of<MaterialProvider>(context, listen: false)
                            .selectedIndex
                            .clear();
                        // Provider.of<MaterialProvider>(context, listen: false)
                        //     .selectedIndex
                        //     .clear();
                      }
                    } else {
                      Provider.of<MaterialProvider>(context, listen: false)
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
                      "Add Material",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),*/
          const Gap(10),
          context.watch<MaterialProvider>().loading
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
                            setState(() {});
                            // if (val.length > 3) {
                            //   List<MaterialData> materialList = [];
                            //   materialList = Provider.of<MaterialProvider>(
                            //           context,
                            //           listen: false)
                            //       .materialList!;
                            //   int itemIndex1 = materialList.indexOf(materialList
                            //       .firstWhere((element) => element.materialName!
                            //           .toLowerCase()
                            //           .contains(val.toLowerCase())));

                            //   /*int itemIndex = Provider.of<MaterialProvider>(context,
                            //       listen: false)
                            //       .materialList
                            //       .map((element) =>
                            //       element.materialName!.toLowerCase())
                            //       .toList()
                            //       .indexOf(val.toLowerCase());*/

                            //   print('Item Index: $itemIndex1');

                            //   //itemScrollController.jumpTo(index: 150);

                            //   if (itemIndex1 != -1) {
                            //     itemScrollController.scrollTo(
                            //         index: itemIndex1,
                            //         duration: Duration(milliseconds: 200),
                            //         curve: Curves.easeInOut);
                            //   }
                            //   setState(() {});
                            // } else {
                            //   itemScrollController.jumpTo(index: 0);
                            //   setState(() {});
                            // }
                          },
                          decoration: InputDecoration(
                            enabled: true,
                            contentPadding: EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                            hintText: "Search by material name",
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
                              int itemIndex = Provider.of<MaterialProvider>(context,
                                  listen: false)
                                  .materialList
                                  .map((element) =>
                                  element.materialName!.toLowerCase())
                                  .toList()
                                  .indexOf(val.toLowerCase());

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

                      Expanded(
                          flex: 5,
                          child: ListView(
                            children: [
                              ...Provider.of<MaterialProvider>(context)
                                  .materialList!
                                  .where((element) => element.materialName!
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
                                            '${e.value.materialName!.capitalizeFirst}',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: e.value.activeStatus != "0"
                                                  ? Colors.black
                                                  : Colors.black26,
                                            ),
                                          ),
                                          value: Provider.of<MaterialProvider>(
                                                  context,
                                                  listen: false)
                                              .selectedIndex
                                              .contains(e.value.materialId),
                                          onChanged: (val) {
                                            if (Provider.of<MaterialProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedIndex
                                                .contains(int.parse(e
                                                    .value.materialId
                                                    .toString()))) {
                                              Provider.of<MaterialProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedIndex
                                                  .remove(int.parse(e
                                                      .value.materialId
                                                      .toString()));
                                            } else {
                                              Provider.of<MaterialProvider>(
                                                      context,
                                                      listen: false)
                                                  .selectedIndex
                                                  .add(int.parse(e
                                                      .value.materialId
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
                      //     itemScrollController: itemScrollController,
                      //     physics: const ScrollPhysics(),
                      //     itemCount: context
                      //         .watch<MaterialProvider>()
                      //         .materialList
                      //         .length,
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
                      //           context
                      //               .watch<MaterialProvider>()
                      //               .materialList[index]
                      //               .materialName!
                      //               .capitalizeFirst!,
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
                                      widget.onMaterialAdd(true);
                                    },
                                    child: Text(
                                      '+ Add New Material',
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
                                  onPressed: Provider.of<MaterialProvider>(
                                                  context,
                                                  listen: false)
                                              .selectedIndex
                                              .length >
                                          0
                                      ? () async {
                                          for (int index = 0;
                                              index <
                                                  Provider.of<MaterialProvider>(
                                                          context,
                                                          listen: false)
                                                      .materialList!
                                                      .length;
                                              index++) {
                                            if (Provider.of<MaterialProvider>(
                                                    context,
                                                    listen: false)
                                                .selectedIndex
                                                .contains(Provider.of<
                                                            MaterialProvider>(
                                                        context,
                                                        listen: false)
                                                    .materialList![index]
                                                    .materialId)) {
                                              multipleSelected.add(MaterialList(
                                                index: index,
                                                materialID: Provider.of<
                                                            MaterialProvider>(
                                                        context,
                                                        listen: false)
                                                    .materialList![index]
                                                    .materialId!
                                                    .toString(),
                                                materialName: Provider.of<
                                                            MaterialProvider>(
                                                        context,
                                                        listen: false)
                                                    .materialList![index]
                                                    .materialName,
                                              ));
                                            }
                                          }

                                          setState(() {});

                                          AddScheduleModel model =
                                              AddScheduleModel.addSchedule;
                                          // if(widget.isEdit == false){
                                          model.materialList = multipleSelected;
                                          // }else{
                                          //   widget.prevModel.materialList =multipleSelected;
                                          // }

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
                      )
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
                        for (int index = 0; index < Provider.of<MaterialProvider>(context, listen: false).materialList!.length; index++) {
                          if (selectedIndex.contains(index)) {
                            multipleSelected.add(MaterialList(
                              index: index,
                              materialID: Provider.of<MaterialProvider>(context, listen: false)
                                  .materialList![index]
                                  .materialId!.toString(),
                              materialName: Provider.of<MaterialProvider>(context, listen: false)
                                  .materialList![index].materialName,
                            ));
                          }
                        }

                        setState(() {});

                        AddScheduleModel model = AddScheduleModel.addSchedule;

                        model.materialList = multipleSelected;

                        Navigator.pop(context);
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
              for (int index = 0; index < Provider.of<MaterialProvider>(context, listen: false).materialList!.length; index++) {
                if (selectedIndex.contains(index)) {
                  multipleSelected.add(MaterialList(
                    index: index,
                    materialID: Provider.of<MaterialProvider>(context, listen: false)
                        .materialList![index]
                        .materialId!.toString(),
                    materialName: Provider.of<MaterialProvider>(context, listen: false)
                        .materialList![index].materialName,
                  ));
                }
              }

              setState(() {});

              AddScheduleModel model = AddScheduleModel.addSchedule;

              model.materialList = multipleSelected;

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
