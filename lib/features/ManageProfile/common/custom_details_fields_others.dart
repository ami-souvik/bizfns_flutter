import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:sizing/sizing.dart';

class CustomDetailsFieldForOthers extends StatelessWidget {
  final String data;
  final bool isEditable;
  final Color? secondaryColor;
  const CustomDetailsFieldForOthers({
    Key? key,
    required this.data,
    required this.isEditable,
    this.secondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Gap(4.ss),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0.ss),
              // border: Border.all(
              //   color: Colors.white,
              //   width: 1.0.ss,
              // ),
              color: const Color(0xFFeaeaea),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      data,
                      style: secondaryColor != null
                          ? TextStyle(color: secondaryColor, fontSize: 14)
                          : TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                  isEditable == true
                      ? Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color(0xFFeaeaea),
                              borderRadius: BorderRadius.circular(100)),
                          child: SvgPicture.asset(
                            'assets/images/edit.svg',
                            width: 20.ss,
                            color: Colors.black,
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
          ),
          Gap(0.ss),
        ],
      ),
    );
  }
}
