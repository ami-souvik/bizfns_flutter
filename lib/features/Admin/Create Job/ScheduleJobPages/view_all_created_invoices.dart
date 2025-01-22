import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/colour_constants.dart';
import '../../../../provider/job_schedule_controller.dart';
import '../model/invoiced_customer_model.dart';

class ViewAllCreatedInvoice extends StatefulWidget {
  final List<InvoiceCustomerData> invoicedCustomerList;
  const ViewAllCreatedInvoice({super.key, required this.invoicedCustomerList});

  @override
  State<ViewAllCreatedInvoice> createState() => _ViewAllCreatedInvoiceState();
}

class _ViewAllCreatedInvoiceState extends State<ViewAllCreatedInvoice> {
  TextEditingController _searchController = TextEditingController();
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
                    "Invoices",
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
              child: widget.invoicedCustomerList == null ||
                      widget.invoicedCustomerList!.isEmpty
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
                        Expanded(
                            flex: 5,
                            child: ListView.builder(
                              itemCount: widget.invoicedCustomerList!.length,
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
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                      '${widget.invoicedCustomerList[index].customerFirstName}'),
                                                  Visibility(
                                                    visible: widget
                                                        .invoicedCustomerList[
                                                            index]
                                                        .customerFirstName!
                                                        .isNotEmpty,
                                                    child: SizedBox(
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  Text(
                                                      '${widget.invoicedCustomerList[index].customerLastName}')
                                                ],
                                              ),
                                              Text(
                                                  '${widget.invoicedCustomerList[index].invoiceNumber}')
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Provider.of<JobScheduleProvider>(
                                                      context,
                                                      listen: false)
                                                  .createInvoicePdf(
                                                      customerId: widget.invoicedCustomerList[index].customerId!,
                                                      jobId: widget.invoicedCustomerList[index].jobId!,
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
                        // Expanded(
                        //     flex: 5,
                        //     child: ListView(
                        //       children: [
                        //         ...widget.invoicedCustomerList!
                        //             .where((element) => element
                        //                     .customerFirstName!
                        //                     .toLowerCase()
                        //                     .startsWith(_searchController.text
                        //                         .toLowerCase())
                        //                 //          ||
                        //                 // element.staffLastName
                        //                 //     .toLowerCase()
                        //                 //     .startsWith(_searchController.text
                        //                 //         .toLowerCase())
                        //                 //          ||
                        //                 // element.staffPhoneNo
                        //                 //     .startsWith(_searchController.text)
                        //                 )
                        //             .toList()
                        //             .asMap()
                        //             .entries
                        //             .map((e) => Padding(
                        //                   padding: EdgeInsets.symmetric(
                        //                       horizontal: 20.0),
                        //                   child: Row(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.spaceBetween,
                        //                     children: [
                        //                       Container(
                        //                         color: Colors.red,
                        //                         child: Column(
                        //                           crossAxisAlignment:
                        //                               CrossAxisAlignment.start,
                        //                           children: [
                        //                             Row(
                        //                               children: [
                        //                                 Text('Name : '),
                        //                                 Text(
                        //                                     '${e.value.customerFirstName}')
                        //                               ],
                        //                             ),
                        //                             Text(
                        //                                 '${e.value.invoiceNumber}')
                        //                           ],
                        //                         ),
                        //                       ),
                        //                       Icon(Icons.remove_red_eye_rounded)
                        //                     ],
                        //                   ),
                        //                 ))
                        //       ],
                        //     ))
                      ],
                    ))
        ],
      ),
    );
  }
}
