import 'dart:io';

import 'package:bizfns/core/utils/bizfns_layout_widget.dart';
import 'package:bizfns/core/utils/colour_constants.dart';
import 'package:bizfns/features/Home/dashboard.dart';
import 'package:bizfns/features/Home/provider/home_provider.dart';
import 'package:bizfns/features/auth/ForgotPassword/provider/forgot_password_provider.dart';
import 'package:bizfns/provider/job_schedule_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:sizing/sizing_builder.dart';
import 'package:toast/toast.dart';
import 'package:url_strategy/url_strategy.dart';
import 'core/route/NavRouter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/Admin/Create Job/ScheduleJobPages/View Customer/provider/view_customer_provider.dart';
import 'features/Admin/Customer/provider/customer_provider.dart';
import 'features/Admin/Material/provider/material_provider.dart';
import 'features/Admin/Service/provider/service_provider.dart';
import 'features/Admin/Staff/provider/staff_provider.dart';
import 'features/ManageProfile/provider/manage_profile_provider.dart';
import 'features/auth/ForgotBusinessId/provider/forgot_business_id_provider.dart';
import 'features/auth/Login/provider/login_provider.dart';
import 'features/auth/Signup/provider/signup_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!kIsWeb) {
    await Firebase.initializeApp();
  }
}

AndroidNotificationChannel androidChannel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications',
  enableLights: true,
  enableVibration: true,
  playSound: true,
  ledColor: AppColor.APP_BAR_COLOUR,
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showNotification(RemoteMessage message) async {
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
          androidChannel.id.toString(), androidChannel.name.toString(),
          channelDescription: 'your channel description',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          ticker: 'ticker',
          icon: '@mipmap/launcher_icon',
          colorized: true,
          color: AppColor.APP_BAR_COLOUR,
          sound: androidChannel.sound);

  const DarwinNotificationDetails darwinNotificationDetails =
      DarwinNotificationDetails(
          presentAlert: true, presentBadge: true, presentSound: true);

  NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails, iOS: darwinNotificationDetails);

  Future.delayed(Duration.zero, () {
    flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
    );
  });
}

Future forgroundMessage() async {
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void handleMessage(RemoteMessage message) {}

void initLocalNotifications(RemoteMessage message) async {
  var androidInitializationSettings =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iosInitializationSettings = const DarwinInitializationSettings();

  var initializationSetting = InitializationSettings(
      android: androidInitializationSettings, iOS: iosInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSetting,
      onDidReceiveNotificationResponse: (payload) {
    // handle interaction when app is active for android
    handleMessage(message);
  });
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (kIsWeb) {
    //usePathUrlStrategy();
    setPathUrlStrategy();
  }
  // ..customAnimation = CustomAnimation();

  if (!kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA2u6K0fatCn7ZKVx7XPZgj3-LRUcdJ96A",
        appId: "1:591450472835:android:c18f07bca903e6bef9f6b6",
        messagingSenderId: "591450472835",
        projectId: "bizfns-97da8",
      ),
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // Set the background messaging handler early on, as a named top-level function
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((event) {
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification!.android;

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(event);
        showNotification(event);
      }
    });
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SignupProvider>(create: (_) => SignupProvider()),
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider<ForgotBusinessIdProvider>(
            create: (_) => ForgotBusinessIdProvider()),
        ChangeNotifierProvider<ForgotPasswordProvider>(
            create: (_) => ForgotPasswordProvider()),
        ChangeNotifierProvider<ViewCustomerProvider>(
            create: (_) => ViewCustomerProvider()),
        ChangeNotifierProvider<ManageProfileProvider>(
            create: (_) => ManageProfileProvider()),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
        ChangeNotifierProvider<CustomerProvider>(
            create: (_) => CustomerProvider()),
        ChangeNotifierProvider<StaffProvider>(create: (_) => StaffProvider()),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
        ChangeNotifierProvider<ServiceProvider>(
            create: (_) => ServiceProvider()),
        ChangeNotifierProvider<MaterialProvider>(
            create: (_) => MaterialProvider()),
        ChangeNotifierProvider<JobScheduleProvider>(
            create: (_) => JobScheduleProvider()),
        ChangeNotifierProvider<BottomNavigationProvider>(
            create: (_) => BottomNavigationProvider()),
        ChangeNotifierProvider<TitleProvider>(create: (_) => TitleProvider()),
      ],
      child: const MyApp(),
    ),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    // ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = EasyLoadingAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SizingBuilder(
      systemFontScale: true,
      builder: () => MaterialApp.router(
        title: 'Bizfns',
        builder: EasyLoading.init(),
        // defaultTransition: Transition.leftToRightWithFade,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // routeInformationParser: GoRoutePageRouter.returnRouter().routeInformationParser,
        // routerDelegate: GoRoutePageRouter.returnRouter().routerDelegate,
        routerConfig: goRouter,
        /*initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,*/
      ),
    );
  }
}
