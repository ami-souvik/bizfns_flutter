import 'package:bizfns/features/Admin/Customer/model/customerListResponseModel.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/colour_constants.dart';
import '../../../../core/utils/fonts.dart';
import '../../../../core/widgets/common_text.dart';

class CustomerCardWidget extends StatefulWidget {
  final CustomerListData data;

  const CustomerCardWidget({super.key, required this.data});

  @override
  State<CustomerCardWidget> createState() => _CustomerCardWidgetState();
}

class _CustomerCardWidgetState extends State<CustomerCardWidget> {
  Future<void> _makePhoneCall(String phoneNumber) async {
    await CountryCodes.init();

    String code = CountryCodes.detailsForLocale().dialCode!;
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: code + phoneNumber,
    );
    await launchUrl(launchUri);
  }

  //const uri = 'sms:+39 348 060 888?body=hello%20there';

  Future<void> _sendMessage(String phoneNumber) async {
    await CountryCodes.init();

    String code = CountryCodes.detailsForLocale().dialCode!;
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: code + phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.ss),
      padding: EdgeInsets.symmetric(horizontal: 10.ss, vertical: 10.ss),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.ss),
      ),
      height: 70.ss,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.data.customerFirstName.toString().isNotEmpty
              ? CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.blueAccent,
                  child: CommonText(
                    text: widget.data.customerFirstName
                        .toString()
                        .substring(0, 1)
                        .capitalizeFirst! /*+ context.watch<CustomerProvider>().customerList![index].customerLastName.substring(0,1).capitalizeFirst!*/,
                    textStyle:
                        CustomTextStyle(fontSize: 18.ss, color: Colors.white),
                  ))
              : CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.blueAccent,
                  child: CommonText(
                    text: widget.data.customerLastName
                        .toString()
                        .substring(0, 1)
                        .capitalizeFirst! /*+ context.watch<CustomerProvider>().customerList![index].customerLastName.substring(0,1).capitalizeFirst!*/,
                    textStyle:
                        CustomTextStyle(fontSize: 18.ss, color: Colors.white),
                  )),
          SizedBox(
            width: 10.ss,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                text:
                    "${widget.data.customerFirstName.toString().capitalizeFirst!} ${widget.data.customerLastName.capitalizeFirst!}",
                textStyle:
                    CustomTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 2.ss,
              ),
              CommonText(
                text: widget.data.customerPhoneNo == null ||
                        widget.data.customerPhoneNo == "null"
                    ? ""
                    : widget.data.customerPhoneNo,
                textStyle:
                    CustomTextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              )
            ],
          ),
          Spacer(),
          Row(
            children: [
              Container(
                width: 12.0, // Adjust the size of the circle as needed
                height: 12.0,
                decoration: BoxDecoration(
                  color: widget.data!.activeStatus == "1"
                      ? Colors.green
                      : Colors.red, // The color of the circle
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                child: Icon(
                  Icons.call,
                  color: AppColor.APP_BAR_COLOUR.withOpacity(0.7),
                ),
                onTap: () async {
                  String phoneNumber = widget.data.customerPhoneNo;

                  await _makePhoneCall(phoneNumber);
                },
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                child: Icon(
                  Icons.sms,
                  color: AppColor.APP_BAR_COLOUR.withOpacity(0.7),
                ),
                onTap: () async {
                  String phoneNumber = widget.data.customerPhoneNo;

                  await _sendMessage(phoneNumber);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
