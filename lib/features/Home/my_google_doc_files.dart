import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:googleapis/drive/v2.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/bizfns_layout_widget.dart';
import '../GoogleDocs/authentication/auth_manager.dart';
import 'documents.dart';
import 'my_client.dart';
// import 'others/my_client.dart';

class MyFiles extends StatefulWidget {
  const MyFiles({super.key});

  @override
  State<MyFiles> createState() => _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {
  late GoogleSignInAccount _currentUser;
  List<File> _items = [];
  String? token;
  bool isLoading = false;
  //   Future<void> _loadFiles() async {
  //   if (_currentUser == null) return;

  //   GoogleSignInAuthentication authentication =
  //       await _currentUser.authentication;
  //   print('authentication: $authentication');
  //   final client = MyClient(defaultHeaders: {
  //     'Authorization': 'Bearer ${authentication.accessToken}'
  //   });
  //   DriveApi driveApi = DriveApi(client);
  //   var files = await driveApi.files
  //       .list(q: 'mimeType=\'application/vnd.google-apps.document\'');
  //   setState(() {
  //     _items = files.items;
  //     _loaded = true;
  //   });
  // }

  Future<void> _signInSilently() async {
    var account = await AuthManager.signInSilently();
    _currentUser = account!;
    if (account != null) {
      print("Account");
      print("xxxxx=>>>>>>>>${account.authentication}");
      GoogleSignInAuthentication authentication =
          await _currentUser.authentication;
      print("accessToken====>${authentication.accessToken}");
      setState(() {
        token = authentication.accessToken;
      });
      _loadFiles();
    } else {
      Navigator.pop(context);
    }
  }

  // Future<void> _loadDocument() async {
  //   if (_currentUser == null) return;

  //   GoogleSignInAuthentication authentication =
  //       await _currentUser.authentication;
  //   print('authentication: $authentication');
  //   final client = MyClient(defaultHeaders: {
  //     'Authorization': 'Bearer ${authentication.accessToken}'
  //   });

  //   final docsApi = docsV1.DocsApi(client);
  //   var document = await docsApi.documents.get(widget.fileId);
  //   print('document.title: ${document.title}');
  //   print('content.length: ${document.body.content.length}');
  //   _parseDocument(document);
  // }

  Future<void> _loadFiles() async {
    if (_currentUser == null) return;
    setState(() {
      isLoading = true;
    });
    GoogleSignInAuthentication authentication =
        await _currentUser.authentication;
    print('authentication: $authentication');
    final client = MyClient(defaultHeaders: {
      'Authorization': 'Bearer ${authentication.accessToken}'
    });
    DriveApi driveApi = DriveApi(client);
    try {
      var files = await driveApi.files.list();

      files.items!.forEach((element) {
        print('Element: ${element.title}');
      });

      setState(() {
        _items = files.items!;
        for (var i = 0; i < _items.length; i++) {
          log("name======>${_items[i].id}");
        }
        // _loaded = true;
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error Occured while loading docs file & $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _signInSilently();
    // Provider.of<TitleProvider>(context, listen: false).title = '';
    super.initState();
  }

  Future<void> _launchGoogleDocs(String? docId) async {
    print("DocumentId--->${docId}");
    // const googleDocsUrl = 'https://docs.google.com/document/d/your_document_id/edit';
    if (!await launchUrl(
        Uri.parse('https://docs.google.com/document/d/$docId/edit'))) {
      throw Exception('Could not launch ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<TitleProvider>(context, listen: false).title = 'Documents';
        GoRouter.of(context).pop();
        print(
            "title---===--->${Provider.of<TitleProvider>(context, listen: false).title}");
        // Provider.of<TitleProvider>(context, listen: false)
        //     .changeTitle('Docuemnts');
        return true;
      },
      child: Scaffold(
        // appBar: AppBar(),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       InkWell(
                  //           onTap: () {
                  //             setState(() {
                  //               Provider.of<TitleProvider>(context,
                  //                       listen: false)
                  //                   .changeTitle('Documents');
                  //             });
                  //             GoRouter.of(context).pop();
                  //           },
                  //           child: Icon(Icons.arrow_back)),
                  //       InkWell(
                  //           onTap: () async {
                  //             await AuthManager.signOut();
                  //             setState(() {
                  //               Provider.of<TitleProvider>(context,
                  //                       listen: false)
                  //                   .changeTitle('Documents');
                  //             });
                  //             GoRouter.of(context).pop();
                  //           },
                  //           child: Icon(Icons.logout)),
                  //     ],
                  //   ),
                  // ),
                  _items.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    _launchGoogleDocs(
                                        _items[index].id.toString());
                                    // Navigator.push(context, MaterialPageRoute(
                                    //   builder: (context) {
                                    //     return DocumentsPage(
                                    //       id: _items[index].id.toString(),
                                    //       token: token.toString(),
                                    //     );
                                    //   },
                                    // ));
                                  },
                                  child: ListTile(
                                      leading: SvgPicture.asset(
                                        'assets/images/google_drive_icon.svg',
                                        width: 30.ss,
                                      ),
                                      title: Text(
                                          _items[index].title.toString())));
                            },
                          ),
                        )
                      : Center(child: Text('No docs File Available!!!')),
                ],
              ),
      ),
    );
  }
}
