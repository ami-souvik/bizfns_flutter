import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizing/sizing.dart';
import 'package:sizing/sizing.dart';
import '../utils/colour_constants.dart';
import '../utils/fonts.dart';

class CommonTextFormField extends StatefulWidget {
  late double? height;
  late double? width;
  late TextEditingController? controller;
  final String? suffixIcon;
  final TextInputAction textInputAction;
  final String? hintText;
  final String? labelText;
  final TextInputType textInputType;
  final TextAlign? textAlign;
  final Function(String)? onValueChanged;
  final Function(String?)? onValidator;
  final Function(String?)? onChanged;
  final Function()? onSuffixClick;
  final Function? onSuffixClickWithValue;
  final bool? isProgressSuffix;
  final bool? obscureText;
  final bool readOnly;
  final bool? isEnable;
  final bool? autofocus;
  List<TextInputFormatter>? inputFormatters;
  final Function(String? value)? onSave;
  final String? initialValue;
  //final readOnly;
  final InputDecoration? decoration;
  final TextStyle? fontTextStyle;
  final int? maxLine;
  final int? maxLength;
  final FocusNode? focusNode;

  final Icon? prefixIcon;
  final Function()? onTap;
  CommonTextFormField(
      {this.controller,
      Key? key,
      this.labelText,
      this.height = 70,
      this.width,
      this.hintText,
      this.readOnly = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.obscureText,
      this.suffixIcon,
      this.prefixIcon,
      this.textAlign = TextAlign.start,
      this.onValueChanged,
      this.onValidator,
      this.onChanged,
      this.decoration,
      this.maxLine,
      this.isProgressSuffix,
      this.onSuffixClick,
      this.onSave,
      this.isEnable,
      this.autofocus,
      this.initialValue,
      this.focusNode,
      this.maxLength,
      this.inputFormatters,
      this.onSuffixClickWithValue,
      this.fontTextStyle,
      this.onTap})
      : super(key: key);

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  String? textValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width ?? MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.0),
        // border: Border.all(color: AppColors.colorBlack),
        // borderRadius: BorderRadius.all(Radius.circular(0))
      ),
      //color: Colors.lightGreen,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.0.ss, right: 8.0.ss),
              child: TextFormField(
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                onTap: widget.onTap,
                autovalidateMode: AutovalidateMode.onUserInteraction,

                validator: (value) => widget.onValidator != null
                    ? widget.onValidator!(value)
                    : null,
                textAlignVertical: TextAlignVertical.center,
                obscureText: widget.obscureText ?? false,
                readOnly: widget.readOnly,
                autofocus: widget.autofocus ?? false,
                enabled: widget.isEnable,
                maxLength: widget.maxLength,
                controller: widget.controller,
                textAlign: widget.textAlign ?? TextAlign.start,
                maxLines: widget.maxLine ?? 1,
                style:
                    widget.fontTextStyle ?? CustomTextStyle(fontSize: 16.fss),
                // focusNode: widget.focusNode,
                inputFormatters: widget.inputFormatters,
                // textCapitalization: TextCapitalization.sentences,
                cursorColor: AppColor.APP_BAR_COLOUR,
                decoration: widget.decoration ??
                    InputDecoration(
                      // isDense:false,
                      hintText: widget.hintText,
                      hintStyle: CustomTextStyle(color: Colors.black87),
                      // isCollapsed: true,
                      suffixIcon: Icon(Icons.add),
                    ),

                onSaved: (value) {
                  widget.onSave != null ? widget.onSave!(value) : null;
                },
                textInputAction: widget.textInputAction,
                keyboardType: widget.textInputType,
                onChanged: (value) {
                  textValue = value;
                  widget.onChanged!(value);
                  widget.onValueChanged != null
                      ? widget.onValueChanged!(value)
                      : null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
