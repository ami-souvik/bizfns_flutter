import 'package:bizfns/core/route/RouteConstants.dart';
import 'package:bizfns/core/utils/Utils.dart';
import 'package:bizfns/features/Admin/Service/provider/service_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';
import '../../../core/utils/bizfns_layout_widget.dart';
import '../../../core/utils/colour_constants.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/route_function.dart';
import '../../../core/widgets/common_text.dart';

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage>
    with WidgetsBindingObserver {
  late BuildContext mContext;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<ServiceProvider>().getServiceList(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Utils().printMessage("In event call");
    switch (state) {
      case AppLifecycleState.resumed:
        Utils().printMessage("resumed");
        // this.context.read<ServiceProvider>().getServiceList(this.context);
        // Provider.of<ServiceProvider>(context,listen: false).getServiceList(context);
        break;
      case AppLifecycleState.inactive:
        Utils().printMessage("inactive");
        break;
      case AppLifecycleState.paused:
        Utils().printMessage("paused");
        break;
      case AppLifecycleState.detached:
        Utils().printMessage("detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        GoRouter.of(context).goNamed('admin');
        return true;
      },
      child: SafeArea(
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
              text: "Services",
            ),
            centerTitle: true,
            backgroundColor: AppColor.APP_BAR_COLOUR,
          ),*/
          backgroundColor: Colors.grey.withOpacity(0.05),
          body: context.watch<ServiceProvider>().loading
              ? const Center(
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
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.ss, horizontal: 12.ss),
                        width: MediaQuery.of(context).size.width * 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText(
                              text: "All Services",
                              textStyle:
                                  CustomTextStyle(fontWeight: FontWeight.w700),
                            ),
                            InkWell(
                              onTap: () {
                                GoRouter.of(context).pushNamed(
                                    'admin-add-service',
                                    extra: {}).then((value) {
                                  context
                                      .read<ServiceProvider>()
                                      .getServiceList(context);
                                });
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
                                          )),
                                    ),
                                    SizedBox(
                                      width: 8.ss,
                                    ),
                                    CommonText(
                                      text: "Add Service",
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
                                  .watch<ServiceProvider>()
                                  .allServiceList!
                                  .isNotEmpty
                              ? ListView.builder(
                                  itemCount: context
                                      .watch<ServiceProvider>()
                                      .allServiceList!
                                      .length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () async {
                                        await Provider.of<ServiceProvider>(
                                                context,
                                                listen: false)
                                            .getServiceDetails(
                                                serviceId: Provider.of<
                                                            ServiceProvider>(
                                                        context,
                                                        listen: false)
                                                    .allServiceList![index]
                                                    .serviceId
                                                    .toString(),
                                                context: context);
                                      },
                                      child: Dismissible(
                                        confirmDismiss: (direction) async {
                                          return
                                              // await showDialog(
                                              //   context: context,
                                              //   builder: (BuildContext context) {
                                              //     return AlertDialog(
                                              //       title: Text("Confirm Deletion"),
                                              //       content: Text(
                                              //           "Are you sure you want to delete ${Provider.of<ServiceProvider>(context, listen: false).allServiceList![index].serviceName}?"),
                                              //       actions: [
                                              //         TextButton(
                                              //           onPressed: () {
                                              //             Navigator.of(context).pop(
                                              //                 false); // Cancel deletion
                                              //           },
                                              //           child: Text("Cancel"),
                                              //         ),
                                              //         TextButton(
                                              //           onPressed: () {
                                              //             Provider.of<ServiceProvider>(
                                              //                     context,
                                              //                     listen: false)
                                              //                 .deleteService(
                                              //                     serviceId: Provider.of<
                                              //                                 ServiceProvider>(
                                              //                             context,
                                              //                             listen:
                                              //                                 false)
                                              //                         .allServiceList![
                                              //                             index]
                                              //                         .serviceId
                                              //                         .toString(),
                                              //                     context: context);
                                              //             setState(() {});
                                              //             //delete api will be called here//
                                              //             // Navigator.of(
                                              //             //         context)
                                              //             //     .pop(
                                              //             //         true); // Confirm deletion
                                              //           },
                                              //           child: Text("Delete"),
                                              //         ),
                                              //       ],
                                              //     );
                                              //   },
                                              // );
                                              showCupertinoDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return CupertinoAlertDialog(
                                                      content: const Text(
                                                        'Are you sure, you want to delete the Service?',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff093d52),
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                      actions: [
                                                        CupertinoButton(
                                                          child: const Text(
                                                            'Yes, Delete',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            //-----Delete will be here----//
                                                            Provider.of<ServiceProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .deleteService(
                                                                    serviceId: Provider.of<ServiceProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .allServiceList![
                                                                            index]
                                                                        .serviceId
                                                                        .toString(),
                                                                    context:
                                                                        context);
                                                            setState(() {});
                                                          },
                                                        ),
                                                        CupertinoButton(
                                                          child: const Text(
                                                            'No',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                          onPressed: () {
                                                            context.pop();
                                                            setState(() {});
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                        },
                                        onDismissed: (direction) {
                                          setState(() {
                                            Provider.of<ServiceProvider>(
                                                    context,
                                                    listen: false)
                                                .allServiceList!
                                                .removeAt(index);
                                          });

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "${Provider.of<ServiceProvider>(context, listen: false).allServiceList![index]} deleted")),
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
                                        child: Container(
                                          margin:
                                              EdgeInsets.only(bottom: 10.ss),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.ss,
                                              vertical: 10.ss),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5.ss),
                                          ),
                                          height: 70.ss,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                      radius: 20.0,
                                                      backgroundColor:
                                                          Colors.blueAccent,
                                                      child: CommonText(
                                                        text: context
                                                            .watch<
                                                                ServiceProvider>()
                                                            .allServiceList[
                                                                index]
                                                            .serviceName
                                                            .toString()
                                                            .substring(0, 1)
                                                            .capitalizeFirst,
                                                        textStyle:
                                                            CustomTextStyle(
                                                                fontSize: 18.ss,
                                                                color: Colors
                                                                    .white),
                                                      )),
                                                  SizedBox(
                                                    width: 10.ss,
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CommonText(
                                                        text: context
                                                            .watch<
                                                                ServiceProvider>()
                                                            .allServiceList[
                                                                index]
                                                            .serviceName
                                                            .toString(),
                                                        textStyle:
                                                            CustomTextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      SizedBox(
                                                        height: 2.ss,
                                                      ),
                                                      CommonText(
                                                        text: context
                                                            .watch<
                                                                ServiceProvider>()
                                                            .allServiceList![
                                                                index]
                                                            .serviceRate
                                                            .toString(),
                                                        textStyle:
                                                            CustomTextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 20.0),
                                                child: Container(
                                                  width:
                                                      12.0, // Adjust the size of the circle as needed
                                                  height: 12.0,
                                                  decoration: BoxDecoration(
                                                    color: context
                                                                .watch<
                                                                    ServiceProvider>()
                                                                .allServiceList[
                                                                    index]
                                                                .activeInactiveStatus ==
                                                            "1"
                                                        ? Colors.green
                                                        : Colors
                                                            .red, // The color of the circle
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                              : Center(
                                  child: CommonText(
                                      text: "No service created yet!"),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
          //)
        ),
      ),
    );
  }
}
