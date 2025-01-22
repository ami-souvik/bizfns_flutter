import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceEntityToggleWidget extends StatefulWidget {
  final String question;
  final Function(String) onAnswerAdd;

  const ServiceEntityToggleWidget({
    super.key,
    required this.question,
    required this.onAnswerAdd,
  });

  @override
  State<ServiceEntityToggleWidget> createState() =>
      _ServiceEntityToggleWidgetState();
}

class _ServiceEntityToggleWidgetState extends State<ServiceEntityToggleWidget> {

  bool value = false;

  late FocusNode _focusNode;

  @override
  void initState() {
    setState(() {
      _focusNode = FocusNode();
      _focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: true,
      readOnly: true,
      autofocus: true,
      focusNode: _focusNode,
      decoration: InputDecoration(
        enabled: true,
        hintText: widget.question,
        enabledBorder: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(),
        border: const OutlineInputBorder(),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(
            right: 10,
          ),
          child: SizedBox(
            height: 20,
            child: CupertinoSwitch(
              focusColor: Colors.red,
              thumbColor: Colors.white,
              activeColor: AppColor.APP_BAR_COLOUR,
              value: value,
              onChanged: (val) {
                setState(() {
                  value = !value;
                  widget.onAnswerAdd(value.toString());
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
