import 'package:bizfns/core/route/RouteConstants.dart';
import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/features/Admin/Customer/provider/customer_provider.dart';
import 'package:bizfns/features/Admin/Customer/widget/customer_card_widget.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/bizfns_layout_widget.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/route_function.dart';
import '../../../core/widgets/common_text.dart';
import '../../../core/widgets/common_text_form_field.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    context.read<CustomerProvider>().getCustomerList(context);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<CustomerProvider>().getCustomerList(context);
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
    final router = GoRouter.of(context);

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          GoRouter.of(context).goNamed('admin');
          return true;
        },
        child: Scaffold(
          /*appBar: const PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: BizfnsAppBar(
                title:  "Customers",)),*/ /*AppBar(
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
              text: "Customers",
            ),
            backgroundColor: AppColor.APP_BAR_COLOUR,
            centerTitle: true,
            elevation: 0,
          ),*/
          //backgroundColor: const Color(0xFFf4feff),
          body: context.watch<CustomerProvider>().loading
              ? const Center(
                  child: SizedBox(),
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
                      /*  Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.ss),
                  child: Row(
                   mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Row(
                        children: [
                          Checkbox(
    value: isChecked,
    onChanged: (newValue) {
    setState(() {
    isChecked = newValue!;
    });}),
                          CommonText(text: "All",)
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: isChecked,
                              onChanged: (newValue) {
                                setState(() {
                                  isChecked = newValue!;
                                });}),
                          CommonText(text: "Active",)
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: isChecked,
                              onChanged: (newValue) {
                                setState(() {
                                  isChecked = newValue!;
                                });}),
                          CommonText(text: "Inactive",)
                        ],
                      ),

                    ],
                  ),
                ),

                Padding(padding: EdgeInsets.symmetric(vertical: 5.ss),
                child: Divider(),),*/
                      const SizedBox(
                        height: 10,
                      ),
                      CommonTextFormField(
                        hintText: "",
                        isEnable: true,
                        controller: _searchController,
                        onChanged: (val) {
                          print(val);
                          print(val);
                          context
                              .read<CustomerProvider>()
                              .searchCustomer(context, val!.toLowerCase());
                        },
                        decoration: InputDecoration(
                          hintText: "Search with customer name or number",
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
                              text: "All Customer",
                              textStyle:
                                  CustomTextStyle(fontWeight: FontWeight.w700),
                            ),
                            InkWell(
                              onTap: () {
                                GoRouter.of(context).pushNamed(
                                    'parent-add-customer',
                                    extra: {}).then((value) {
                                  context
                                      .read<CustomerProvider>()
                                      .getCustomerList(context);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 10.0,
                                      backgroundColor: Colors.grey,
                                      child: CircleAvatar(
                                          radius: 9,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.grey,
                                            size: 14,
                                          )),
                                    ),
                                    SizedBox(
                                      width: 8.ss,
                                    ),
                                    CommonText(
                                      text: "Add Customer",
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
                                  .watch<CustomerProvider>()
                                  .customerList!
                                  .isNotEmpty
                              ? ListView.builder(
                                  itemCount: context
                                      .watch<CustomerProvider>()
                                      .customerList!
                                      .where((element) =>
                                          element.customerPhoneNo.contains(
                                              context
                                                  .watch<CustomerProvider>()
                                                  .searchText) ||
                                          element.customerFirstName
                                              .toLowerCase()
                                              .contains(context
                                                  .watch<CustomerProvider>()
                                                  .searchText
                                                  .toLowerCase()) ||
                                          element.customerLastName
                                              .toLowerCase()
                                              .contains(context
                                                  .watch<CustomerProvider>()
                                                  .searchText
                                                  .toLowerCase()))
                                      .toList()
                                      .length,
                                  itemBuilder: (context, index) {
                                    final filteredList = context
                                        .watch<CustomerProvider>()
                                        .customerList!
                                        .where((element) =>
                                            element.customerPhoneNo.contains(
                                                context
                                                    .watch<CustomerProvider>()
                                                    .searchText) ||
                                            element.customerFirstName
                                                .toLowerCase()
                                                .contains(context
                                                    .watch<CustomerProvider>()
                                                    .searchText
                                                    .toLowerCase()) ||
                                            element.customerLastName
                                                .toLowerCase()
                                                .contains(context
                                                    .watch<CustomerProvider>()
                                                    .searchText
                                                    .toLowerCase()))
                                        .toList();
                                    return InkWell(
                                      onTap: () async {
                                        //here details func will be added
                                        print("Customer Details");
                                        await context
                                            .read<CustomerProvider>()
                                            .getCustomerDetails(
                                                customerID: filteredList[index]
                                                    .customerId
                                                    .toString(),
                                                context: context);
                                      },
                                      child: Dismissible(
                                        confirmDismiss: (direction) async {
                                          return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Confirm Deletion"),
                                                content: Text(
                                                    "Are you sure you want to delete ${Provider.of<CustomerProvider>(context, listen: false).customerList![index].customerLastName}?"),
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
                                                      Provider.of<CustomerProvider>(
                                                              context,
                                                              listen: false)
                                                          .deleteCustomer(
                                                              customerId: Provider.of<
                                                                          CustomerProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .customerList![
                                                                      index]
                                                                  .customerId
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
                                            Provider.of<CustomerProvider>(
                                                    context,
                                                    listen: false)
                                                .customerList!
                                                .removeAt(index);
                                          });

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "${Provider.of<CustomerProvider>(context, listen: false).customerList![index]} deleted")),
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
                                        child: CustomerCardWidget(
                                            data: filteredList[index]),
                                      ),
                                    );
                                  })
                              : Center(
                                  child: CommonText(
                                      text: "No customer created yet!"),
                                ),
                        ),
                      )
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
