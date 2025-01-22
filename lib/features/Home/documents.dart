import 'package:bizfns/features/Home/bizfins_share_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/utils/Utils.dart';
import '../../core/utils/bizfns_layout_widget.dart';
import '../../core/utils/colour_constants.dart';
import '../../core/widgets/common_text.dart';
import '../GoogleDocs/authentication/auth_manager.dart';
import 'dashboard.dart';
import 'my_google_doc_files.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  void initState() {
    super.initState();
    // _signInSilently();
  }

  Future<void> _handleSignIn() async {
    var account = await AuthManager.signIn();
    if (account != null) {
      navigateToGoogleDocs();
    } else {
      Utils().ShowWarningSnackBar(context, "OOPS!", "Please Login Again");
    }
  }

  navigateToGoogleDocs() {
    GoRouter.of(context).goNamed('google-Docs');
  }

  Future<void> _signInSilently() async {
    var account = await AuthManager.signInSilently();
    if (account != null) {
      navigateToGoogleDocs();
      // Navigator.pushReplacementNamed(context, AppRoute.files);
    }
  }

  String getAppBarTitle(BuildContext context) {
    String routePath =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;

    print(routePath);

    ///todo: has be to split by / and remove the last element
    ///todo: then get the last element of the current list
    ///
    ///
    List<String> items = routePath.split('/');
    items.removeLast();

    return getTitle(items.last);
  }

  String getTitle(String key) {
    Map<String, String> titleMap = {
      'dashboard': 'Dashboard',
    };

    return titleMap[key] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        String appBarTitle = getAppBarTitle(context);

        // Provider.of<TitleProvider>(context, listen: false).changeTitle('');
        return true;
      },
      child: Scaffold(
        body: Container(
          color: Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Text(
                  'Log in using your Google account',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 20.0),
                TextButton(
                  child: Text('Log in'),
                  onPressed: () {
                    _handleSignIn();
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
