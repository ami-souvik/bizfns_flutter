import 'package:flutter/material.dart';

import '../../../../../core/utils/colour_constants.dart';

class ServiceEntityRadioButtonWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final Function(String) onAnswerAdd;

  const ServiceEntityRadioButtonWidget(
      {super.key,
      required this.question,
      required this.options,
      required this.onAnswerAdd});

  @override
  State<ServiceEntityRadioButtonWidget> createState() =>
      _ServiceEntityRadioButtonWidgetState();
}

class _ServiceEntityRadioButtonWidgetState
    extends State<ServiceEntityRadioButtonWidget> {
  String selectedItem = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question,
          style: const TextStyle(fontSize: 16),
        ),
        Wrap(
          alignment: WrapAlignment.start,
          runSpacing: 5,
          spacing: 15,
          children: [
            ...widget.options
                .map((e) => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          child: Radio<String>(
                            value: e,
                            groupValue: selectedItem,
                            activeColor: AppColor.APP_BAR_COLOUR,
                            onChanged: (String? value) {
                              setState(() {
                                if(value == null){
                                  selectedItem = '';
                                }else{
                                  selectedItem = value;
                                }

                                widget.onAnswerAdd(selectedItem);
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(e),
                      ],
                    ))
                .toList(),
          ],
        ),
      ],
    );
  }
}
