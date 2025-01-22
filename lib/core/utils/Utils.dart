import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../route/RouteConstants.dart';
import '../shared_pref/shared_pref.dart';
import 'bizfns_layout_widget.dart';

class Utils {
  Future<bool?> check_internet_connection(BuildContext context) async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        // I am connected to a mobile network.
        return true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
        return true;
      } else if (connectivityResult == ConnectivityResult.ethernet) {
        return true;
        // I am connected to a ethernet network.
      } else if (connectivityResult == ConnectivityResult.vpn) {
        // I am connected to a vpn network.
        // Note for iOS and macOS:
        // There is no separate network interface type for [vpn].
        // It returns [other] on any device (also simulator)
        return true;
      } else if (connectivityResult == ConnectivityResult.bluetooth) {
        return true;
        // I am connected to a bluetooth.
      } else if (connectivityResult == ConnectivityResult.other) {
        // I am connected to a network which is not in the above mentioned networks.
        return true;
      } else if (connectivityResult == ConnectivityResult.none) {
        // I am not connected to any network.
        return false;
      } else
        return false;
    } on SocketException catch (_) {
      // ShowWarningSnackBar("OPPS!! ",
      //     "Sorry No Internet Connection !! ");

      dialog(context);
      return false;
    }
  }

  dialog(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text(
              'No Internet Connection !',
              style: TextStyle(
                  color: Colors.black87,
                  //fontFamily: font,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            content: Container(
              height: 80,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "You would need internet to run the application. Would you like to turn it on ?",
                style: TextStyle(
                    color: Colors.black87,
                    //fontFamily: font,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      //fontFamily: font,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
                isDestructiveAction: true,
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                child: const Text(
                  'Setting',
                  style: TextStyle(
                      //fontFamily: font,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
                isDefaultAction: true,
                onPressed: () {
                  // AppSettings.openDataRoamingSettings();

                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  ShowWarningSnackBar(BuildContext context, String title, String msg,
      {Duration? duration}) {
    print(msg);

    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 10,
        padding: const EdgeInsets.all(10),
        backgroundColor: Colors.blue[700],
        duration: const Duration(seconds: 8),
      ));
    }

    kIsWeb
        ? Toast.show(
            msg,
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColor.APP_BAR_COLOUR,
          )
        : AnimatedSnackBar.rectangle(
            title,
            msg,
            duration: duration ?? Duration(seconds: 8),
            type: AnimatedSnackBarType.info,
            brightness: Brightness.light,
          ).show(
            context,
          );
  }

  ShowErrorSnackBar(BuildContext context, String title, String msg,
      {Duration? duration}) {
    print(msg);

    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 4),
        content: Text(
          msg,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 10,
        padding: const EdgeInsets.all(10),
        backgroundColor: Colors.red[700],
      ));
    }

    kIsWeb
        ? Toast.show(msg,
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColor.APP_BAR_COLOUR)
        : AnimatedSnackBar.rectangle(title, msg,
                type: AnimatedSnackBarType.error,
                brightness: Brightness.light,
                duration: duration ?? Duration(seconds: 4))
            .show(
            context,
          );
  }

  ShowSuccessSnackBar(BuildContext context, String title, String msg,
      {Duration? duration}) {
    print(msg);

    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 10,
        padding: const EdgeInsets.all(10),
        backgroundColor: Colors.green[700],
      ));
    }

    kIsWeb
        ? Toast.show(msg,
            duration: Toast.lengthLong,
            gravity: Toast.center,
            backgroundColor: AppColor.APP_BAR_COLOUR)
        : AnimatedSnackBar.rectangle(
            title,
            msg,
            type: AnimatedSnackBarType.success,
            brightness: Brightness.light,
            duration: duration ?? const Duration(seconds: 4),
          ).show(
            context,
          );
  }

  static bool IsValidEmail(String email) {
    RegExp regExp = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

    return regExp.hasMatch(email);
  }

  printMessage(String msg) {
    debugPrint(msg);
  }

  static Future<List<String>> getDeviceDetails() async {
    String deviceName = "";
    String deviceVersion = "";
    String identifier = "";
    String deviceType = "";
    String appVersion = "";

    try {
      final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

      if (kIsWeb) {
        deviceType = "WEB";
        var data = await deviceInfoPlugin.webBrowserInfo;
        deviceName = data.browserName.name ?? "";
        deviceVersion = data.appVersion ?? "";
        identifier = data.appVersion ?? "";
        return [identifier, "", ""];
      }
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;
      // String code = packageInfo.buildNumber;
      if (Platform.isAndroid) {
        deviceType = "ANDROID";
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model ?? "";
        deviceVersion = build.version.toString();
        identifier = build.id??""; //UUID for Android
      } else if (Platform.isIOS) {
        deviceType = "IOS";
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name ?? "";
        deviceVersion = data.systemVersion ?? "";
        identifier = data.identifierForVendor ?? ""; //UUID for iOS
      } else {
        deviceType = "WEB";
        var data = await deviceInfoPlugin.webBrowserInfo;
        deviceName = data.browserName.name ?? "";
        deviceVersion = data.appVersion ?? "";
        identifier = data.appVersion ?? "";
      }
    } on PlatformException {
      print('Failed to get platform version');
      return ["", "", ""];
    }
//     return [deviceName, deviceVersion, identifier,deviceType,appVersion];
    return [identifier, deviceType, appVersion];
  }

  static ShowLoader(
    BuildContext context, {
    String? title,
  }) {
    AlertDialog alert = AlertDialog(
      content: Row(children: [
        CircularProgressIndicator(
          backgroundColor: Colors.green,
          color: Colors.blue,
        ),
        Container(
            margin: EdgeInsets.only(left: 7),
            child: Text(title ?? "Loading...")),
      ]),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static HideLoader(BuildContext context) {
    context.pop();
  }

  static Future<void> Logout(BuildContext context) async {
    await GlobalHandler.setLogedIn(false);
    await GlobalHandler.setSequrityQuestionAnswered(false);
    await GlobalHandler.setLoginData(null);
    Provider.of<TitleProvider>(context, listen: false).title = '';
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        context.go(login);
      },
    );
  }

  bool isValidPassword(String password, [int minLength = 8]) {
    if (password == null || password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length >= minLength;

    return hasDigits &
        hasUppercase &
        hasLowercase &
        hasSpecialCharacters &
        hasMinLength;
  }
}
