import 'package:bizfns/features/Admin/Staff/provider/staff_provider.dart';
import 'package:bizfns/features/Admin/Staff/widget/staff_card_widget.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/route/RouteConstants.dart';
import '../../../core/utils/bizfns_layout_widget.dart';
import '../../../core/utils/colour_constants.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/route_function.dart';
import '../../../core/widgets/common_text.dart';
import '../../../core/widgets/common_text_form_field.dart';
import '../model/staffListResponseModel.dart';

class StaffList extends StatefulWidget {
  const StaffList({super.key});

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> with WidgetsBindingObserver {
  // List<> staffList =[];
  bool isChecked = false;

  List<StaffListData> _staffList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<StaffProvider>().getStaffList(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<StaffProvider>().getStaffList(context);
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var border = const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
          color: Colors.blueGrey,
          width: 1,
        ));

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          GoRouter.of(context).goNamed('admin');
          return true;
        },
        child: Scaffold(
          /*appBar: AppBar(
            leading: InkWell(
              onTap: (){
                context.pop();
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: CommonText(
              text: "Staffs",
            ),
            centerTitle: true,
            backgroundColor: AppColor.APP_BAR_COLOUR,
          ),*/
          backgroundColor: Colors.grey.withOpacity(0.05),
          body: context.watch<StaffProvider>().loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  // padding: EdgeInsets.symmetric(horizontal: 20.ss),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      border: Border.all(color: Colors.white)),
                  child: Column(
                    // physics: NeverScrollableScrollPhysics(),
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      CommonTextFormField(
                        hintText: "",
                        isEnable: true,
                        controller: _searchController,
                        onChanged: (val) {
                          print(val);
                          context
                              .read<StaffProvider>()
                              .searchCustomer(context, val!.toLowerCase());
                          /*context.read<StaffProvider>().searchStaffList(context, val!.toLowerCase());
                          if(val!.isEmpty){
                            context.read<StaffProvider>().getStaffList(context, searchRefresh: false);
                          }*/
                        },
                        decoration: InputDecoration(
                          hintText: "Search with staff name or number",
                          border: const OutlineInputBorder(gapPadding: 1),
                          isDense: false,
                          enabled: true,
                          prefixIcon: IntrinsicHeight(
                            child: SizedBox(
                              width: 40,
                              child: Row(
                                children: [
                                  SizedBox(width: 5.ss),
                                  const ImageIcon(
                                    AssetImage('assets/images/bell 2.png'),
                                    color: AppColor.BUTTON_COLOR,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5.0.ss, vertical: 5.ss),
                                    child: VerticalDivider(
                                      width: 5.ss,
                                      color: AppColor.BUTTON_COLOR,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          enabledBorder:
                              const OutlineInputBorder(gapPadding: 1),
                          focusedBorder:
                              const OutlineInputBorder(gapPadding: 1),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.ss, horizontal: 12.ss),
                        width: MediaQuery.of(context).size.width * 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              text: "All Staff",
                              textStyle:
                                  CustomTextStyle(fontWeight: FontWeight.w700),
                            ),
                            InkWell(
                              onTap: () {
                                GoRouter.of(context)
                                    .pushNamed('parent-add-staff', extra: {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 10.0,
                                      backgroundColor: Colors.grey,
                                      child: CircleAvatar(
                                        radius: 9,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.grey,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.ss,
                                    ),
                                    CommonText(
                                      text: "Add Staff",
                                      textStyle: CustomTextStyle(
                                          fontSize: 12.fss,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0.ss),
                        child: context
                                .watch<StaffProvider>()
                                .staffList!
                                .isNotEmpty
                            ? ListView.builder(
                                itemCount: context
                                    .watch<StaffProvider>()
                                    .staffList!
                                    .where((element) =>
                                        element.staffPhoneNo.contains(context
                                            .watch<StaffProvider>()
                                            .searchText) ||
                                        element.staffFirstName
                                            .toLowerCase()
                                            .contains(context
                                                .watch<StaffProvider>()
                                                .searchText
                                                .toLowerCase()) ||
                                        element.staffLastName
                                            .toLowerCase()
                                            .contains(context
                                                .watch<StaffProvider>()
                                                .searchText
                                                .toLowerCase()))
                                    .toList()
                                    .length,
                                itemBuilder: (context, index) {
                                  final filteredList = context
                                      .watch<StaffProvider>()
                                      .staffList!
                                      .where((element) =>
                                          element.staffPhoneNo.contains(context
                                              .watch<StaffProvider>()
                                              .searchText) ||
                                          element.staffFirstName
                                              .toLowerCase()
                                              .contains(context
                                                  .watch<StaffProvider>()
                                                  .searchText
                                                  .toLowerCase()) ||
                                          element.staffLastName
                                              .toLowerCase()
                                              .contains(context
                                                  .watch<StaffProvider>()
                                                  .searchText
                                                  .toLowerCase()))
                                      .toList();
                                  return InkWell(
                                    onTap: () async {
                                      await context
                                          .read<StaffProvider>()
                                          .getStaffDetails(
                                              phoneNo: filteredList[index]
                                                  .staffPhoneNo,
                                              context: context)
                                          .then((value) {
                                        print("val: ${value}");
                                      });
                                      // print(
                                      //     "filteredList[index].staffFirstName: ${filteredList[index].staffFirstName}");
                                      // GoRouter.of(context).pushNamed(
                                      //     'parent-add-staff',
                                      //     extra: {
                                      //       'isEdit':true,
                                      //       'firstName':
                                      //           filteredList[index].staffFirstName,
                                      //       'lastName':filteredList[index].staffLastName,
                                      //       'email': filteredList[index].staffEmail,
                                      //       'phone': filteredList[index].staffPhoneNo,
                                      //     });

                                      //         GoRouter.of(context).pushNamed(
                                      //   'createInvoice',
                                      //   extra: {
                                      //     'url': invoice,
                                      //   },
                                      // );
                                    },
                                    child: Dismissible(
                                      confirmDismiss: (direction) async {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Confirm Deletion"),
                                              content: Text(
                                                  "Are you sure you want to delete ${Provider.of<StaffProvider>(context, listen: false).staffList![index].staffLastName}?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(
                                                        false); // Cancel deletion
                                                  },
                                                  child: Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Provider.of<
                                                                StaffProvider>(
                                                            context,
                                                            listen: false)
                                                        .deleteStaff(
                                                            staffPhoneNo: Provider
                                                                    .of<StaffProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                .staffList![
                                                                    index]
                                                                .staffPhoneNo
                                                                .toString(),
                                                            context: context);
                                                    //delete api will be called here//
                                                    // Navigator.of(
                                                    //         context)
                                                    //     .pop(
                                                    //         true); // Confirm deletion
                                                  },
                                                  child: Text("Delete"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      onDismissed: (direction) {
                                        setState(() {
                                          Provider.of<StaffProvider>(context,
                                                  listen: false)
                                              .staffList!
                                              .removeAt(index);
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "${Provider.of<StaffProvider>(context, listen: false).staffList![index]} deleted")),
                                        );
                                      },
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      key: Key(index.toString()),
                                      child: StaffCardWidget(
                                          data: filteredList[index]),
                                    ),
                                  );
                                })
                            : Center(
                                child:
                                    CommonText(text: "No staff created yet!"),
                              ),
                      ))
                      /*Expanded(
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 50,
                      itemBuilder: (context, i) =>
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //key: _containerKey,
                            // key: _key[i],
                            children: [
                              Gap(20.ss),
                              Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: CommonText(text: "Customer List",maxLine: 3,),
                              ),
                              Gap(0.ss),

                            ],
                          ),
                    ),
                  ),
                ),*/
                    ],
                  ),
                ),
//)
        ),
      ),
    );
  }
}
