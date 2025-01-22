import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/api_constants.dart';
import '../model/all_pdf_list_model.dart';

class CustomerPdfList extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final List<Data> value;
  const CustomerPdfList({super.key, required this.value});

  @override
  State<CustomerPdfList> createState() => _CustomerPdfListState();
}

class _CustomerPdfListState extends State<CustomerPdfList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.value.isNotEmpty
            ?
            //  Column(children: [
            Container(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: widget.value.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${widget.value[index].customerName}'),
                      subtitle: Text('${widget.value[index].invoice}'),
                      trailing: TextButton(
                          onPressed: () {
                            String invoice =
                                '${Urls.DOWNLOAD_INVOICE_FILE}${widget.value[index].invoice}';
                            GoRouter.of(context).pushNamed(
                              'createInvoice',
                              extra: {
                                'url': invoice,
                              },
                            );
                            print("after tapping invoice====>$invoice");
                          },
                          child: Text("View")),
                    );
                  },
                ),
              )
            : Text('data'));
  }
}
