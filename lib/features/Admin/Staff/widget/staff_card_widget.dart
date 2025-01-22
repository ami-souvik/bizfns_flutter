import 'package:bizfns/features/Admin/model/staffListResponseModel.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/colour_constants.dart';
import '../../../../core/utils/fonts.dart';
import '../../../../core/widgets/common_text.dart';

class StaffCardWidget extends StatefulWidget {
  final StaffListData? data;

  const StaffCardWidget({super.key, required this.data});

  @override
  State<StaffCardWidget> createState() => _StaffCardWidgetState();
}

class _StaffCardWidgetState extends State<StaffCardWidget> {
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
          CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.blueAccent,
              child: CommonText(
                text: (widget.data!.staffFirstName.isNotEmpty
                        ? widget.data!.staffFirstName
                            .substring(0, 1)
                            .capitalizeFirst!
                        : '') +
                    (widget.data!.staffLastName.isNotEmpty
                        ? widget.data!.staffLastName
                            .substring(0, 1)
                            .capitalizeFirst!
                        : ''),
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
                text: widget.data!.staffFirstName.isNotEmpty
                    ? "${widget.data!.staffFirstName.toString().capitalizeFirst!} ${widget.data!.staffLastName.capitalizeFirst!}"
                    : "${widget.data!.staffLastName.capitalizeFirst!}",
                textStyle:
                    CustomTextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 2.ss,
              ),
              CommonText(
                text: widget.data!.staffPhoneNo == "null"
                    ? ""
                    : widget.data!.staffPhoneNo,
                textStyle:
                    CustomTextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              )
            ],
          ),
          const Spacer(),
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
                  String phoneNumber = widget.data!.staffPhoneNo;

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
                  String phoneNumber = widget.data!.staffPhoneNo;

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
