// import 'package:flutter/cupertino.dart';
import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_pdf/share_pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/utils/Utils.dart';
import '../../../../core/utils/bizfns_layout_widget.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class PDFWidget extends StatefulWidget {
  final String url;

  const PDFWidget({super.key, required this.url});

  @override
  State<PDFWidget> createState() => _PDFWidgetState();
}

class _PDFWidgetState extends State<PDFWidget> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState

    Provider.of<TitleProvider>(context, listen: false).title = 'Your Invoice';
  }

  download() async {
    await FileDownloader.downloadFile(
        notificationType: NotificationType.all,
        url: "${widget.url}",
        name: "THE FILE NAME AFTER DOWNLOADING", //(optional)
        subPath: "your/desired/sub/path", //(optional)
        // onProgress: (String fileName, double progress) {
        //   print('FILE fileName HAS PROGRESS $progress');
        // },
        onDownloadCompleted: (String path) {
          print('FILE DOWNLOADED TO PATH: $path');
        },
        onDownloadError: (String error) {
          print('DOWNLOAD ERROR: $error');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: InkWell(
      //     onTap: () {
      //       context.pop();
      //     },
      //     child: const Icon(
      //       Icons.arrow_back,
      //       color: Colors.white,
      //     ),
      //   ),
      //   backgroundColor: AppColor.APP_BAR_COLOUR,
      //   title: const Text('Your Invoice'),
      // ),
      body: Container(
        // color: Colors.grey.withOpacity(0.4),
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(''),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            download();
                          },
                          child: Container(
                              width:
                                  30, // Adjust the width to control the size of the container
                              height:
                                  30, // Adjust the height to control the size of the container
                              decoration: const BoxDecoration(
                                color: AppColor
                                    .APP_BAR_COLOUR, // Background color of the container
                                shape: BoxShape
                                    .circle, // Makes the container circular
                              ),
                              child: const Icon(
                                Icons.download,
                                color: Colors.white,
                              ))),
                      const SizedBox(
                        width: 10.0,
                      ),
                      InkWell(
                          onTap: () async {
                            SharePDF sharePDF = SharePDF(
                              url: "${widget.url}",
                              subject: "Subject Line goes here",
                            );
                            await sharePDF.downloadAndShare();
                          },
                          child: Container(
                              width:
                                  30, // Adjust the width to control the size of the container
                              height:
                                  30, // Adjust the height to control the size of the container
                              decoration: const BoxDecoration(
                                color: AppColor
                                    .APP_BAR_COLOUR, // Background color of the container
                                shape: BoxShape
                                    .circle, // Makes the container circular
                              ),
                              child: const Icon(
                                Icons.share,
                                color: Colors.white,
                              )))
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: SfPdfViewer.network(
                widget.url,
                key: _pdfViewerKey,
                onDocumentLoadFailed: (PdfDocumentLoadFailedDetails value) {
                  Utils()
                      .ShowErrorSnackBar(context, 'ERROR', value.description);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
