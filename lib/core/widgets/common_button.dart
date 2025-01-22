
import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';

import '../utils/colour_constants.dart';


class CommonButton extends StatelessWidget {
  final String? label;
  late Function()? onClicked;
  final Color? labelColor;
  final List<Color>? gradColor;
  final Color? borderColor;
  final double? borderRadius;
  final Color? solidColor;
  final double? fontSize;
  final double? buttonHeight;
  final double? buttonWidth;
  final FontWeight? fontWeight;

  CommonButton(
      {this.label,
      this.onClicked,
      this.labelColor,
      this.gradColor,
      this.solidColor,
      this.borderColor,
      this.borderRadius,
      this.fontSize,
      this.buttonHeight,
      this.buttonWidth,
        this.fontWeight,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          if (onClicked != null) onClicked!();
        },
        child: Container(
          // alignment: Alignment.center,
          height: buttonHeight,
          width: buttonWidth,
          margin: EdgeInsets.symmetric(horizontal: 10.ss,vertical: 10.ss),
          padding:  EdgeInsets.symmetric(horizontal: 16.0.ss),
          decoration: BoxDecoration(

              color: solidColor,
              border: borderColor != null
                  ? Border.all(
                      color: borderColor!,
                      width: 1.0,
                    )
                  : null,
              borderRadius: BorderRadius.all(Radius.circular(borderRadius??10))),
          child: Center(
            child: Text(
              label ?? "",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: labelColor ?? AppColor.WHITE,
                  fontSize: fontSize ?? 16,
                  fontFamily: "Roboto",
                  fontWeight: fontWeight ?? FontWeight.w700),
            ),
          ),
        ));
  }
}
