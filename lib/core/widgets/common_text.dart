import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/fonts.dart';

class CommonText extends StatelessWidget {
  String? text;
  TextStyle? textStyle;
  int? maxLine;
  TextOverflow? textOverflow;

  CommonText({this.text, this.textStyle, this.maxLine, this.textOverflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      maxLines: maxLine ?? 1000,
      overflow: textOverflow ?? TextOverflow.ellipsis,
      style: textStyle ?? TextStyle(fontWeight: FontWeight.w600),
    );
  }
}

class WeekDateText extends StatelessWidget {
  String? text;
  String? date;
  TextStyle? textStyle;
  int? maxLine;
  TextOverflow? textOverflow;
  bool isSelected;

  WeekDateText({
    this.text,
    this.date,
    this.textStyle,
    this.maxLine,
    this.textOverflow,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 4,
          ),
          Text(
            text ?? "",
            maxLines: maxLine ?? 1000,
            overflow: textOverflow ?? TextOverflow.ellipsis,
            style: textStyle ??
                TextStyle(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(
            height: 2,
          ),
          Text(date!,
              maxLines: maxLine ?? 1000,
              overflow: textOverflow ?? TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              )),
        ],
      );
    });
  }
}
