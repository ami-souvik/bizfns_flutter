import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:flutter/material.dart';

class ServiceEntityMultipleOptionWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final Function(String) onAnswerAdd;

  const ServiceEntityMultipleOptionWidget({
    super.key,
    required this.question,
    required this.options,
    required this.onAnswerAdd,
  });

  @override
  State<ServiceEntityMultipleOptionWidget> createState() =>
      _ServiceEntityMultipleOptionWidgetState();
}

class _ServiceEntityMultipleOptionWidgetState
    extends State<ServiceEntityMultipleOptionWidget> {
  List<String> selectedItems = [];

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
                          child: Checkbox(
                            activeColor: AppColor.APP_BAR_COLOUR,
                            fillColor: MaterialStateProperty.resolveWith(
                              (states) {
                                if (!states.contains(MaterialState.selected)) {
                                  return AppColor.APP_BAR_COLOUR;
                                }
                                return null;
                              },
                            ),
                            value: selectedItems.contains(e),
                            onChanged: (val) {
                              if (val!) {
                                selectedItems.add(e);
                              } else {
                                selectedItems.remove(e);
                              }

                              widget.onAnswerAdd(selectedItems.join(','));

                              setState(() {});
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
