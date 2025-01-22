import 'package:flutter/material.dart';

import '../../model/service_entity_question_model.dart';
import 'service_entity_widget.dart';

class ServiceEntityGroupWidget extends StatefulWidget {
  final List<RowItems> items;

  const ServiceEntityGroupWidget({super.key, required this.items});

  @override
  State<ServiceEntityGroupWidget> createState() =>
      _ServiceEntityGroupWidgetState();
}

class _ServiceEntityGroupWidgetState extends State<ServiceEntityGroupWidget> {
  @override
  void initState() {
    if (widget.items == null) {
      print('Null row items');
    } else {
      widget.items.forEach((element) {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('In group widget');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...widget.items.map(
          (row) {
            print(row.rowTypeId??'row type');
            print(row.rowQuestionId ?? 'Question');
            print(row.rowQuestion ?? 'Row Question');
            print(row.rowAnswer ?? 'Answer');
            print(row.rowItems ?? row.rowItems.toString());
            return Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: ServiceEntityItemWidget(
                  answer: row.rowAnswer ?? '',
                  items: row.rowItems == null ? [] : row.rowItems!,
                  onAnswerAdd: (val) {
                    row.rowAnswer = val.toString();
                    setState(() {});
                  },
                  question: row.rowQuestion ?? '',
                  typeID: row.rowTypeId!,
                ),
              ),
            );
          },
        ).toList()
      ],
    );
  }
}
