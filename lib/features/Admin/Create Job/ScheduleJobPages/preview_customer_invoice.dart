import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/colour_constants.dart';
import '../../../../provider/job_schedule_controller.dart';
import '../model/add_schedule_model.dart';

class PreviewCustomerInvoice extends StatefulWidget {
  final AddScheduleModel addScheduleModel;
  final List<int> customerIdList;
  const PreviewCustomerInvoice(
      {super.key,
      required this.addScheduleModel,
      required this.customerIdList});

  @override
  State<PreviewCustomerInvoice> createState() => _PreviewCustomerInvoiceState();
}

class _PreviewCustomerInvoiceState extends State<PreviewCustomerInvoice> {
  List<CustomerData> customer = [];

  intializeCustomer() {
    // // widget.customerIdList.map((e) => )
    // widget.addScheduleModel.customer.where((element) => element.customerId == widget.customerIdList.map((e) => e))
    //  customer= widget.customerIdList.map((e) => widget.addScheduleModel.customer!.map((elem) => elem.customerId ==e.toString())).toList();
    for (var i = 0; i < widget.customerIdList.length; i++) {
      for (var j = 0; j < widget.addScheduleModel.customer!.length; j++) {
        if (widget.addScheduleModel.customer![j].customerId.toString() ==
            widget.customerIdList[i].toString()) {
          customer!.add(widget.addScheduleModel.customer![j]);
          setState(() {});
        }
      }
    }

    print("customer : ${customer}");
  }

  @override
  void initState() {
    super.initState();
    intializeCustomer();
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
                    "Preview Invoices",
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
              child: customer.isEmpty
                  ? const Center(
                      child: Text('No Customer Found'),
                    )
                  : Column(
                      children: [
                        Expanded(
                            flex: 5,
                            child: ListView.builder(
                              itemCount: customer.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Name : ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                  '${customer[index].customerName}'),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Provider.of<JobScheduleProvider>(
                                                      context,
                                                      listen: false)
                                                  .createInvoicePdf(
                                                      customerId:
                                                          customer[index]
                                                              .customerId!,
                                                      jobId: widget
                                                          .addScheduleModel
                                                          .jobId!,
                                                      context: context);
                                            },
                                            child: Image.asset(
                                              'assets/images/receipt.png',
                                              height: 25,
                                              width: 25,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ))
                      ],
                    ))
        ],
      ),
    );
  }
}
