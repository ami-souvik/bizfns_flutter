import 'package:bizfns/core/utils/bizfns_layout_widget.dart';
import 'package:bizfns/features/Admin/Create%20Job/ScheduleJobPages/customer_pdf_list.dart';
import 'package:bizfns/features/Admin/Customer/customer_list.dart';
import 'package:bizfns/features/Admin/Material/add_material.dart';
import 'package:bizfns/features/Admin/Service/add_service.dart';
import 'package:bizfns/features/Admin/Service/service_list.dart';
import 'package:bizfns/features/Admin/Staff/staff_list.dart';
import 'package:bizfns/features/Admin/admin_page.dart';
import 'package:bizfns/features/Home/home.dart';
import 'package:bizfns/features/ManageProfile/account_page2.dart';
import 'package:bizfns/features/ManageProfile/change_password_page.dart';
import 'package:bizfns/features/ManageProfile/change_phone_no_page.dart';
import 'package:bizfns/features/ManageProfile/sequrity_question_page.dart';
import 'package:bizfns/features/Settings/settings_page.dart';
import 'package:bizfns/features/Settings/staff_permission_screen.dart';
import 'package:bizfns/features/Settings/widget/reminder_widget.dart';
import 'package:bizfns/features/auth/Signup/model/RegistrationVerifyOtp.dart';
import 'package:bizfns/provider/job_schedule_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../../features/Admin/Create Job/ScheduleJobPages/View Customer/view_customer.dart';
import '../../features/Admin/Create Job/ScheduleJobPages/pdf.dart';
import '../../features/Admin/Create Job/ScheduleJobPages/preview.dart';
import '../../features/Admin/Create Job/ScheduleJobPages/widget/add_edit_invoice_page.dart';
import '../../features/Admin/Create Job/model/add_schedule_model.dart';
import '../../features/Admin/Create Job/schedule_page.dart';
import '../../features/Admin/Create Job/date_select.dart';
import '../../features/Admin/Create Job/schedule_job.dart';
import '../../features/Admin/Customer/add_customer.dart';
import '../../features/Admin/Material/material_list.dart';
import '../../features/Admin/Staff/add_staff.dart';
import '../../features/Admin/account_page.dart';
import '../../features/Admin/category_subcategory/view_add_categort_subcategory.dart';
import '../../features/Home/dashboard.dart';
import '../../features/Home/documents.dart';
import '../../features/Home/my_google_doc_files.dart';
import '../../features/Home/provider/home_provider.dart';
import '../../features/ManageProfile/business_name_logo.dart';
import '../../features/ManageProfile/marketing.dart';
import '../../features/ManageProfile/retype_newphone.dart';
import '../../features/ManageProfile/verify_change_password_otp.dart';
import '../../features/ManageProfile/verify_password_page.dart';
import '../../features/ManageProfile/verify_sequrity_question_page.dart';
import '../../features/Settings/tax_settings_screen.dart';
import '../../features/Settings/time_sheet_bill.dart';
import '../../features/SplashScreen/splash_screen.dart';
import '../../features/auth/ForgotBusinessId/forgot_business_id_page.dart';
import '../../features/auth/ForgotPassword/forgot_password_page.dart';
import '../../features/auth/ForgotPassword/reset_password_page.dart';
import '../../features/auth/ForgotPassword/verify_otp.dart';
import '../../features/auth/Login/login_page.dart';
import '../../features/auth/Signup/signup.dart';
import '../../features/auth/Login/verify_otp.dart';
import '../../features/auth/Signup/verify_registration_otp.dart';
import '../../features/auth/StaffLogin/staff_login_page.dart';
import '../utils/Utils.dart';
import 'RouteConstants.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final _shellNavigatorKeyHome =
    GlobalKey<NavigatorState>(debugLabel: 'Home Navigator Stack');
final _shellNavigatorKeyDocument =
    GlobalKey<NavigatorState>(debugLabel: 'Document navigator Stack');
final _shellNavigatorKeyAdmin =
    GlobalKey<NavigatorState>(debugLabel: 'Admin navigator Stack');
final _shellNavigatorKeySettings =
    GlobalKey<NavigatorState>(debugLabel: 'Settings navigator Stack');

final _shellNavigatorKeySchedule =
    GlobalKey<NavigatorState>(debugLabel: 'Schedule Navigator Stack');

final _shellNavigatorKeySNM =
    GlobalKey<NavigatorState>(debugLabel: 'SNM Navigator Stack');

AddScheduleModel? addScheduleModel = AddScheduleModel.addSchedule;
final goRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: landing,
      builder: (BuildContext context, GoRouterState state) {
        return SplashScreen();
      },
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
                opacity: CurveTween(curve: Curves.easeIn).animate(animation),
                child: child),
      ),
      routes: <RouteBase>[],
    ),
    GoRoute(
      path: login,
      builder: (BuildContext context, GoRouterState state) => LoginPage(),
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: const LoginPage(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
                opacity: CurveTween(curve: Curves.easeIn).animate(animation),
                child: child),
      ),
      routes: [],
    ),
    GoRoute(
      path: verify_otp,
      builder: (BuildContext context, GoRouterState state) {
        Provider.of<TitleProvider>(context, listen: false).title = '';
        final args = state.extra as Map;
        return VerifyOTP(
          forWhat: args['forWhat'],
        );
      },
      pageBuilder: (context, state) {
        Provider.of<TitleProvider>(context, listen: false).title =
            ''; //AX4nr&^r
        final args = state.extra as Map;
        return CustomTransitionPage<void>(
          //(332) 266-5598  VilJdC#7
          key: state.pageKey,
          child: VerifyOTP(
            forWhat: args['forWhat'],
          ),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        );
      },
    ),
    GoRoute(
      path: forgot_business_id,
      builder: (BuildContext context, GoRouterState state) =>
          ForgotBusinessIdPage(),
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: ForgotBusinessIdPage(),
        transitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: CurveTween(curve: Curves.easeIn).animate(animation),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: signup,
      builder: (BuildContext context, GoRouterState state) => SignUp(),
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: SignUp(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: CurveTween(curve: Curves.easeIn).animate(animation),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: verify_registration_otp,
      builder: (BuildContext context, GoRouterState state) =>
          VerifyRegistrationOTP(),
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: VerifyRegistrationOTP(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: CurveTween(curve: Curves.easeIn).animate(animation),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: change_password,
      builder: (BuildContext context, GoRouterState state) {
        Provider.of<TitleProvider>(context, listen: false).title =
            'Change Password';
        return ChangePasswordPage();
      },
      pageBuilder: (context, state) {
        Provider.of<TitleProvider>(context, listen: false).title =
            'Change Password';
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: ChangePasswordPage(),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        );
      },
    ),
    // GoRoute(
    //   path: businessNameLogo,
    //   builder: (BuildContext context, GoRouterState state) {
    //     Provider.of<TitleProvider>(context, listen: false).title =
    //         'Business Name & Logo';
    //     return BusinessNameAndLogo();
    //   },
    //   pageBuilder: (context, state) {
    //     Provider.of<TitleProvider>(context, listen: false).title =
    //         'Business Name & Logo';
    //     return CustomTransitionPage<void>(
    //       key: state.pageKey,
    //       child: BusinessNameAndLogo(),
    //       transitionDuration: const Duration(milliseconds: 200),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) =>
    //           FadeTransition(
    //         opacity: CurveTween(curve: Curves.easeIn).animate(animation),
    //         child: child,
    //       ),
    //     );
    //   },
    // ),
    GoRoute(
      path: marketing,
      builder: (BuildContext context, GoRouterState state) {
        Provider.of<TitleProvider>(context, listen: false).title = 'Marketing';
        return MarketingPage();
      },
      pageBuilder: (context, state) {
        Provider.of<TitleProvider>(context, listen: false).title = 'Marketing';
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: MarketingPage(),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        );
      },
    ),
    GoRoute(
      path: verify_change_password_otp,
      builder: (BuildContext context, GoRouterState state) {
        Provider.of<TitleProvider>(context, listen: false).title = 'Verify Otp';
        return VerifyChangePasswordOTP();
      },
      pageBuilder: (context, state) {
        Provider.of<TitleProvider>(context, listen: false).title = 'Verify Otp';
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: VerifyChangePasswordOTP(),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        );
      },
    ),
    GoRoute(
      path: forgot_password,
      builder: (BuildContext context, GoRouterState state) =>
          ForgotPasswordPage(),
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: ForgotPasswordPage(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: CurveTween(curve: Curves.easeIn).animate(animation),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: reset_password,
      builder: (BuildContext context, GoRouterState state) =>
          ResetPasswordPage(),
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: ResetPasswordPage(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: CurveTween(curve: Curves.easeIn).animate(animation),
          child: child,
        ),
      ),
    ),
    //--------------staff-login---------------//
    GoRoute(
      path: staff_login,
      builder: (BuildContext context, GoRouterState state) {
        Provider.of<TitleProvider>(context, listen: false).title = '';
        return StaffLogin();
      },
      pageBuilder: (context, state) {
        Provider.of<TitleProvider>(context, listen: false).title = '';
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: StaffLogin(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        );
      },
    ),
    //----------------------------------------//
    GoRoute(
      path: verify_forgot_password_otp,
      builder: (BuildContext context, GoRouterState state) =>
          VerifyForgotPasswordOTP(phno: state.pathParameters['phone'] ?? ""),
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child:
            VerifyForgotPasswordOTP(phno: state.pathParameters['phone'] ?? ""),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: CurveTween(curve: Curves.easeIn).animate(animation),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: security_question_page,
      builder: (BuildContext context, GoRouterState state) {
        final args = state.extra as Map;
        return SequrityQuestionPage(
          fromWhere: args['forWhat'],
        );
      },
      pageBuilder: (context, state) {
        final args = state.extra as Map;
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: SequrityQuestionPage(
            fromWhere: args['forWhat'],
          ),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        );
      },
    ),
    GoRoute(
      path: verify_password,
      builder: (BuildContext context, GoRouterState state) {
        Provider.of<TitleProvider>(context, listen: false).title =
            'Verify Password';
        return VerifyPassword();
      },
      pageBuilder: (context, state) {
        Provider.of<TitleProvider>(context, listen: false).title =
            'Verify Password';
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: VerifyPassword(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        );
      },
    ),
    GoRoute(
      path: retype_newphone,
      builder: (BuildContext context, GoRouterState state) {
        Provider.of<TitleProvider>(context, listen: false).title =
            'Retype New Phone No';
        return RetypeNewPhone();
      },
      pageBuilder: (context, state) {
        Provider.of<TitleProvider>(context, listen: false).title =
            'Retype New Phone No';
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: RetypeNewPhone(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        );
      },
    ),

    GoRoute(
      path: change_mobile_no_page,
      builder: (BuildContext context, GoRouterState state) {
        Provider.of<TitleProvider>(context, listen: false).title =
            'Change Mobile No';
        return ChangePhoneNoPage();
      },
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: ChangePhoneNoPage(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Provider.of<TitleProvider>(context, listen: false).title =
              'Change Mobile No';
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: verify_sequrity_questions,
      builder: (BuildContext context, GoRouterState state) =>
          VerifySequrityQuestionPage(),
      pageBuilder: (context, state) => CustomTransitionPage<void>(
        key: state.pageKey,
        child: VerifySequrityQuestionPage(),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: CurveTween(curve: Curves.easeIn).animate(animation),
          child: child,
        ),
      ),
    ),
    // GoRoute(
    //     name: '/accounts',
    //     path: '/accounts',
    //     builder: (BuildContext context, GoRouterState state) {
    //       Provider.of<TitleProvider>(context, listen: false).title = "Profile";
    //       return AccountPage();
    //     },
    //     pageBuilder: (BuildContext context, GoRouterState mState) {
    //       Provider.of<TitleProvider>(context, listen: false).title = "Profile";
    //       return pageTransitionWidget(const AccountPage(), mState.pageKey);
    //     },
    //     routes: []),
    // Stateful nested navigation based on:
    // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // the UI shell
        return ScaffoldWithNestedNavigation(
          navigationShell: navigationShell,
        );
      },
      branches: [
        // first branch (A)
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKeyHome,
          routes: [
            // top route inside branch
            GoRoute(
              name: 'home',
              path: '/home',
              pageBuilder: (BuildContext context, GoRouterState mState) {
                Provider.of<TitleProvider>(context, listen: false).title = "";
                return pageTransitionWidget(const HomePage(), mState.pageKey);
              },
              routes: [
                GoRoute(
                  name: 'date-select',
                  path: 'date-select',
                  builder: (BuildContext context, GoRouterState state) {
                    Provider.of<TitleProvider>(context, listen: false).title =
                        "Select Month";
                    return DateSelect();
                  },
                  pageBuilder: (context, state) {
                    Provider.of<TitleProvider>(context, listen: false).title =
                        "Select Month";
                    return CustomTransitionPage<void>(
                      key: state.pageKey,
                      child: DateSelect(),
                      transitionDuration: const Duration(milliseconds: 600),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) =>
                              FadeTransition(
                        opacity:
                            CurveTween(curve: Curves.easeIn).animate(animation),
                        child: child,
                      ),
                    );
                  },
                ),
                GoRoute(
                    name: 'schedule',
                    path: 'schedule',
                    pageBuilder: (BuildContext context, GoRouterState mState) {
                      Provider.of<TitleProvider>(context, listen: false).title =
                          context.watch<HomeProvider>().companyName;
                      Provider.of<TitleProvider>(context, listen: false)
                          .isCenter = true;
                      return pageTransitionWidget(
                          const SchedulePage(), mState.pageKey);
                    },
                    routes: [
                      GoRoute(
                          name: 'create-schedule',
                          path: 'create-schedule',
                          builder: (BuildContext context, GoRouterState state) {
                            final args = state.extra as Map;
                            Utils().printMessage(
                                "Data======>>>>>>> " + args.toString());

                            return ScheduleJob(
                              time: args['time'],
                              // jobIndex: args['jobIndex'],
                              // timeIndex: args['timeIndex'],
                            );
                          },
                          pageBuilder:
                              (BuildContext context, GoRouterState mState) {
                            final args = mState.extra as Map;
                            Utils().printMessage(
                                "Data======>>>>>>> " + args.toString());

                            // AddScheduleModel? addScheduleModel = AddScheduleModel.addSchedule;

                            addScheduleModel!.jobStatus == null
                                ? Provider.of<TitleProvider>(context,
                                        listen: false)
                                    .title = 'Schedule New Modify'
                                : Provider.of<JobScheduleProvider>(context)
                                            .isEdit ==
                                        true
                                    ? Provider.of<TitleProvider>(context,
                                            listen: false)
                                        .title = 'Schedule New Modify'
                                    : Provider.of<TitleProvider>(context,
                                            listen: false)
                                        .title = "Service-Event Details";

                            return CustomTransitionPage<void>(
                              key: mState.pageKey,
                              child: ScheduleJob(
                                time: args['time'],
                                // jobIndex: args['jobIndex'],
                                // timeIndex: args['timeIndex'],
                              ),
                              transitionDuration:
                                  const Duration(milliseconds: 600),
                              transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) =>
                                  FadeTransition(
                                opacity: CurveTween(curve: Curves.easeIn)
                                    .animate(animation),
                                child: child,
                              ),
                            );
                          },
                          routes: [
                            GoRoute(
                              name: 'job-add-service',
                              path: 'job-add-service',
                              pageBuilder:
                                  (BuildContext context, GoRouterState mState) {
                                Provider.of<TitleProvider>(context,
                                        listen: false)
                                    .changeTitle('Add Service');
                                return pageTransitionWidget(
                                    AddService(), mState.pageKey);
                              },
                            ),
                            GoRoute(
                              name: 'job-add-staff',
                              path: 'job-add-staff',
                              pageBuilder:
                                  (BuildContext context, GoRouterState mState) {
                                Provider.of<TitleProvider>(context,
                                        listen: false)
                                    .changeTitle('Add Staff');
                                return pageTransitionWidget(
                                    const AddStaff(), mState.pageKey);
                              },
                            ),
                            GoRoute(
                              name: 'job-add-material',
                              path: 'job-add-material',
                              pageBuilder:
                                  (BuildContext context, GoRouterState mState) {
                                Provider.of<TitleProvider>(context,
                                        listen: false)
                                    .changeTitle('Add Material');
                                return pageTransitionWidget(
                                    const AddMaterial(), mState.pageKey);
                              },
                            ),
                            GoRoute(
                              name: 'job-add-customer',
                              path: 'job-add-customer',
                              pageBuilder:
                                  (BuildContext context, GoRouterState mState) {
                                Provider.of<TitleProvider>(context,
                                        listen: false)
                                    .changeTitle('Add Customer');
                                return pageTransitionWidget(
                                    const AddCustomer(), mState.pageKey);
                              },
                            ),
                            GoRoute(
                              name: 'addeditinvoice',
                              path: 'addeditinvoice',
                              pageBuilder:
                                  (BuildContext context, GoRouterState mState) {
                                final args = mState.extra as Map;
                                if (args['model'] != null) {
                                  Provider.of<TitleProvider>(context,
                                          listen: false)
                                      .changeTitle('Update Invoice');
                                } else {
                                  Provider.of<TitleProvider>(context,
                                          listen: false)
                                      .changeTitle('Create Invoice');
                                }

                                return pageTransitionWidget(
                                    AddEditInvoice(
                                      addScheduleModel:
                                          args['addScheduleModel'],
                                      customerIdList: args['customerIdList'],
                                      model: args['model'],
                                    ),
                                    mState.pageKey);
                              },
                            ),
                            /*GoRoute(
                                name: 'select-customer',
                                path: 'select-customer',
                                pageBuilder: (BuildContext context,
                                    GoRouterState mState) {
                                  Provider.of<TitleProvider>(context,
                                          listen: false)
                                      .changeTitle('View Customer');
                                  return pageTransitionWidget(
                                      const CustomerViewPage(), mState.pageKey);
                                },
                                routes: [
                                  GoRoute(
                                    name: 'job-add-customer',
                                    path: 'job-add-customer',
                                    pageBuilder: (BuildContext context,
                                        GoRouterState mState) {
                                      Provider.of<TitleProvider>(context,
                                              listen: false)
                                          .changeTitle('Add Customer');
                                      return pageTransitionWidget(
                                          const AddCustomer(), mState.pageKey);
                                    },
                                  ),
                                ]),*/
                            GoRoute(
                              name: 'preview',
                              path: 'preview',
                              builder:
                                  (BuildContext context, GoRouterState state) {
                                // final args = state.extra as Map;
                                Provider.of<TitleProvider>(context,
                                        listen: false)
                                    .title = "Schedule New-Modify";
                                return Preview(
                                    // jobIndex: args['jobIndex'],
                                    // timeIndex: args['timeIndex'],
                                    );
                              },
                              pageBuilder: (context, state) {
                                Provider.of<TitleProvider>(context,
                                        listen: false)
                                    .title = "Schedule New-Modify";
                                // final args = state.extra as Map;
                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  child: Preview(
                                      // jobIndex: args['jobIndex'],
                                      // timeIndex: args['timeIndex'],
                                      ),
                                  transitionDuration:
                                      const Duration(milliseconds: 600),
                                  transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) =>
                                      FadeTransition(
                                    opacity: CurveTween(curve: Curves.easeIn)
                                        .animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                            ),
                            GoRoute(
                              name: 'createInvoice',
                              path: 'createInvoice',
                              builder:
                                  (BuildContext context, GoRouterState state) {
                                Provider.of<TitleProvider>(context,
                                        listen: false)
                                    .title = "Your Invoice";
                                final args = state.extra as Map;
                                return PDFWidget(
                                  url: args['url'],
                                );
                              },
                              pageBuilder: (context, state) {
                                Provider.of<TitleProvider>(context,
                                        listen: false)
                                    .title = "Your Invoice";
                                final args = state.extra as Map;
                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  child: PDFWidget(
                                    url: args['url'],
                                  ),
                                  transitionDuration:
                                      const Duration(milliseconds: 600),
                                  transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) =>
                                      FadeTransition(
                                    opacity: CurveTween(curve: Curves.easeIn)
                                        .animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                            ),
                            GoRoute(
                              name: 'customerPdfList',
                              path: 'customerPdfList',
                              builder:
                                  (BuildContext context, GoRouterState state) {
                                Provider.of<TitleProvider>(context,
                                        listen: false)
                                    .title = "Customer Pdf List";
                                final args = state.extra as Map;
                                return CustomerPdfList(
                                  value: args['list'],
                                );
                              },
                              pageBuilder: (context, state) {
                                Provider.of<TitleProvider>(context,
                                        listen: false)
                                    .title = "Customer Pdf List";
                                final args = state.extra as Map;
                                return CustomTransitionPage<void>(
                                  key: state.pageKey,
                                  child: CustomerPdfList(
                                    value: args['list'],
                                  ),
                                  transitionDuration:
                                      const Duration(milliseconds: 600),
                                  transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) =>
                                      FadeTransition(
                                    opacity: CurveTween(curve: Curves.easeIn)
                                        .animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                            ),
                          ]),
                    ]),
                GoRoute(
                    name: 'accounts',
                    path: 'accounts',
                    pageBuilder: (BuildContext context, GoRouterState mState) {
                      Provider.of<TitleProvider>(context, listen: false).title =
                          "Profile";
                      return pageTransitionWidget(
                          const AccountPage(), mState.pageKey);
                    },
                    routes: []),
                GoRoute(
                  name: 'accounts2',
                  path: 'accounts2',
                  pageBuilder: (BuildContext context, GoRouterState mState) {
                    Provider.of<TitleProvider>(context, listen: false).title =
                        "Account";
                    return pageTransitionWidget(
                        const AccountPage2(), mState.pageKey);
                  },
                ),
                GoRoute(
                  name: 'all-customer',
                  path: 'all-customer',
                  pageBuilder: (BuildContext context, GoRouterState mState) {
                    Provider.of<TitleProvider>(context, listen: false)
                        .changeTitle('Customers');
                    return pageTransitionWidget(
                        const CustomerList(), mState.pageKey);
                  },
                  routes: [
                    GoRoute(
                      path: 'parent-add-customer',
                      name: 'parent-add-customer',
                      pageBuilder:
                          (BuildContext context, GoRouterState mState) {
                        final args = mState.extra as Map;
                        print("add cust isEdit : ${args['isEdit']}");
                        args['isEdit'] != null || args['isEdit'] == true
                            ? Provider.of<TitleProvider>(context, listen: false)
                                .changeTitle('Edit Customer')
                            : Provider.of<TitleProvider>(context, listen: false)
                                .changeTitle('Add Customer');
                        return pageTransitionWidget(
                            AddCustomer(
                              isEdit: args['isEdit'],
                              firstName: args['firstName'],
                              lastName: args['lastName'],
                              email: args['email'],
                              mobile: args['mobile'],
                              acticeStatus: args['activeStatus'],
                              customerId: args['customerId'],
                              companyAdress: args['companyAdress'],
                              companyName: args['companyName'],
                            ),
                            mState.pageKey);
                      },
                    )
                  ],
                ),
                GoRoute(
                    name: 'staff',
                    path: 'staff',
                    pageBuilder: (BuildContext context, GoRouterState mState) {
                      Provider.of<TitleProvider>(context, listen: false)
                          .changeTitle('Staffs');
                      return pageTransitionWidget(
                          const StaffList(), mState.pageKey);
                    },
                    routes: [
                      GoRoute(
                        path: 'parent-add-staff',
                        name: 'parent-add-staff',
                        pageBuilder:
                            (BuildContext context, GoRouterState mState) {
                          final args = mState.extra as Map;
                          print("args['isEdit'] : ${args['isEdit']}");
                          args['isEdit'] == null || args['isEdit'] == true
                              ? Provider.of<TitleProvider>(context,
                                      listen: false)
                                  .changeTitle('Edit Staff')
                              : Provider.of<TitleProvider>(context,
                                      listen: false)
                                  .changeTitle('Add Staff');
                          return pageTransitionWidget(
                              AddStaff(
                                isEdit: args['isEdit'],
                                firstName: args['firstName'],
                                lastName: args['lastName'],
                                email: args['email'],
                                phone: args['phone'],
                                rate: args['rate'],
                                staffId: args['staffId'],
                                staffType: args['staffType'],
                                friquencyId: args['friquencyId'],
                                activeStatus: args['activeStatus'],
                              ),
                              mState.pageKey);
                        },
                      )
                    ]),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKeyDocument,
          routes: [
            // top route inside branch
            GoRoute(
                name: 'document',
                path: '/document',
                pageBuilder: (BuildContext context, GoRouterState mState) {
                  return pageTransitionWidget(
                      DocumentsScreen(), mState.pageKey);
                },
                routes: [
                  GoRoute(
                      name: 'google-Docs',
                      path: 'google-Docs',
                      // builder: (BuildContext context, GoRouterState state) {
                      //   // Provider.of<TitleProvider>(context, listen: false).title =
                      //   //     'Google Docs';
                      //   return MyFiles();
                      // },
                      pageBuilder:
                          (BuildContext context, GoRouterState mState) {
                        Provider.of<TitleProvider>(context, listen: false)
                            .changeTitle('Google-docs');
                        return pageTransitionWidget(
                            const MyFiles(), mState.pageKey);
                      },
                      routes: [])
                ]),
            // GoRoute(
            //     path: google_docs,
            //     builder: (BuildContext context, GoRouterState state) {
            //       Provider.of<TitleProvider>(context, listen: false).title =
            //           'Google Docs';
            //       return MyFiles();
            //     },
            //     pageBuilder: (context, mState) => CustomTransitionPage<void>(
            //       key: mState.pageKey,
            //       child: MyFiles(),
            //       transitionDuration: const Duration(milliseconds: 600),
            //       transitionsBuilder:
            //           (context, animation, secondaryAnimation, child) {
            //         Provider.of<TitleProvider>(context, listen: false).title =
            //           'Google Docs';
            //         return FadeTransition(
            //           opacity: CurveTween(curve: Curves.easeIn)
            //               .animate(animation),
            //           child: child,
            //         );
            //       },
            //     ),
            //   )
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKeyAdmin,
          routes: [
            // top route inside branch
            GoRoute(
                name: 'admin',
                path: '/admin',
                pageBuilder: (BuildContext context, GoRouterState mState) {
                  Provider.of<TitleProvider>(context, listen: false)
                      .changeTitle('Admin');
                  return pageTransitionWidget(AdminPage(), mState.pageKey);
                },
                routes: [
                  GoRoute(
                    name: 'view-customer',
                    path: 'view-customer',
                    pageBuilder: (BuildContext context, GoRouterState mState) {
                      Provider.of<TitleProvider>(context, listen: false)
                          .changeTitle('Customers');
                      return pageTransitionWidget(
                          const CustomerList(), mState.pageKey);
                    },
                    routes: [
                      GoRoute(
                        path: 'admin-add-customer',
                        name: 'admin-add-customer',
                        pageBuilder:
                            (BuildContext context, GoRouterState mState) {
                          Provider.of<TitleProvider>(context, listen: false)
                              .changeTitle('Add Customer');
                          return pageTransitionWidget(
                              const AddCustomer(), mState.pageKey);
                        },
                      )
                    ],
                  ),
                  GoRoute(
                    name: 'view-staff',
                    path: 'view-staff',
                    pageBuilder: (BuildContext context, GoRouterState mState) {
                      Provider.of<TitleProvider>(context, listen: false)
                          .changeTitle('Staffs');
                      return pageTransitionWidget(
                          const StaffList(), mState.pageKey);
                    },
                    routes: [
                      GoRoute(
                        path: 'admin-add-staff',
                        name: 'admin-add-staff',
                        pageBuilder:
                            (BuildContext context, GoRouterState mState) {
                          Provider.of<TitleProvider>(context, listen: false)
                              .changeTitle('Add Staff');
                          return pageTransitionWidget(
                              const AddStaff(), mState.pageKey);
                        },
                      )
                    ],
                  ),
                  GoRoute(
                    name: 'view-materials',
                    path: 'view-materials',
                    pageBuilder: (BuildContext context, GoRouterState mState) {
                      Provider.of<TitleProvider>(context, listen: false)
                          .changeTitle('Materials');
                      return pageTransitionWidget(
                          const MaterialListPage(), mState.pageKey);
                    },
                    routes: [
                      GoRoute(
                        path: 'admin-add-material',
                        name: 'admin-add-material',
                        pageBuilder:
                            (BuildContext context, GoRouterState mState) {
                          final args = mState.extra as Map;
                          args['isEdit'] == null || args['isEdit'] == false
                              ? Provider.of<TitleProvider>(context,
                                      listen: false)
                                  .changeTitle('Add Material')
                              : Provider.of<TitleProvider>(context,
                                      listen: false)
                                  .changeTitle('Edit Material');
                          // Provider.of<TitleProvider>(context, listen: false)
                          //     .changeTitle('Add Material');
                          return pageTransitionWidget(
                              AddMaterial(
                                isEdit: args['isEdit'],
                                materialName: args['materialName'],
                                categoryId: args['categoryId'] != null
                                    ? args['categoryId'].toString()
                                    : null,
                                subCategoryId: args['subCategoryId'] != null
                                    ? args['subCategoryId'].toString()
                                    : null,
                                rate: args['rate'],
                                unitId: args['unitId'] != null
                                    ? args['unitId'].toString()
                                    : null,
                                materialType: args['materialType'],
                                activeStatus: args['activeStatus'] != null
                                    ? int.parse(args['activeStatus'])
                                    : null,
                                materialId: args['materialId'],
                              ),
                              mState.pageKey);
                        },
                      )
                    ],
                  ),
                  GoRoute(
                    name: 'view-services',
                    path: 'view-services',
                    pageBuilder: (BuildContext context, GoRouterState mState) {
                      Provider.of<TitleProvider>(context, listen: false)
                          .changeTitle('Services');
                      return pageTransitionWidget(
                          const ServiceListPage(), mState.pageKey);
                    },
                    routes: [
                      GoRoute(
                        path: 'admin-add-service',
                        name: 'admin-add-service',
                        pageBuilder:
                            (BuildContext context, GoRouterState mState) {
                          final args = mState.extra as Map;
                          print("args['isEdit'] ----> ${args['isEdit']}");
                          args['isEdit'] == null
                              ? Provider.of<TitleProvider>(context,
                                      listen: false)
                                  .changeTitle('Add Service')
                              : Provider.of<TitleProvider>(context,
                                      listen: false)
                                  .changeTitle('Edit Service');
                          return pageTransitionWidget(
                              AddService(
                                isEdit: args['isEdit'],
                                serviceName: args['serviceName'],
                                serviceRate: args['serviceRate'],
                                serviceUnit: args['serviceUnit'],
                                serviceId: args['serviceId'],
                                activeStatus: args['activeStatus'],
                              ),
                              mState.pageKey);
                        },
                      )
                    ],
                  ),
                  //-----category-----//
                  GoRoute(
                    name: 'view-category',
                    path: 'view-category',
                    pageBuilder: (BuildContext context, GoRouterState mState) {
                      Provider.of<TitleProvider>(context, listen: false)
                          .changeTitle('Add Category');
                      return pageTransitionWidget(
                          const CategorySubcategoryListPage(), mState.pageKey);
                    },
                    routes: [
                      // GoRoute(
                      //   path: 'admin-add-service',
                      //   name: 'admin-add-service',
                      //   pageBuilder:
                      //       (BuildContext context, GoRouterState mState) {
                      //     final args = mState.extra as Map;
                      //     print("args['isEdit'] ----> ${args['isEdit']}");
                      //     args['isEdit'] == null
                      //         ? Provider.of<TitleProvider>(context,
                      //                 listen: false)
                      //             .changeTitle('Add Service')
                      //         : Provider.of<TitleProvider>(context,
                      //                 listen: false)
                      //             .changeTitle('Edit Service');
                      //     return pageTransitionWidget(
                      //         AddService(
                      //           isEdit: args['isEdit'],
                      //           serviceName: args['serviceName'],
                      //           serviceRate: args['serviceRate'],
                      //           serviceUnit: args['serviceUnit'],
                      //           serviceId: args['serviceId'],
                      //           activeStatus: args['activeStatus'],
                      //         ),
                      //         mState.pageKey);
                      //   },
                      // )
                    ],
                  ),
                ]),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKeySettings,
          routes: [
            // top route inside branch
            GoRoute(
              name: 'settings',
              path: '/settings',
              pageBuilder: (BuildContext context, GoRouterState mState) =>
                  pageTransitionWidget(const SettingsPage(), mState.pageKey),
              routes: [
                GoRoute(
                      name: 'tax-setting',
                      path: 'tax-setting',
                      // builder: (BuildContext context, GoRouterState state) {
                      //   // Provider.of<TitleProvider>(context, listen: false).title =
                      //   //     'Google Docs';
                      //   return MyFiles();
                      // },
                      pageBuilder:
                          (BuildContext context, GoRouterState mState) {
                        Provider.of<TitleProvider>(context, listen: false)
                            .changeTitle('Tax Settings');
                        return pageTransitionWidget(
                            TaxSettings(), mState.pageKey);
                      },),

                GoRoute(
                  name: 'staff-permission',
                  path: 'staff-permission',
                  // builder: (BuildContext context, GoRouterState state) {
                  //   // Provider.of<TitleProvider>(context, listen: false).title =
                  //   //     'Google Docs';
                  //   return MyFiles();
                  // },
                  pageBuilder:
                      (BuildContext context, GoRouterState mState) {
                    Provider.of<TitleProvider>(context, listen: false)
                        .changeTitle('Privileges');
                    return pageTransitionWidget(StaffPermissionScreen(), mState.pageKey);
                  },),

                GoRoute(
                  name: 'reminder',
                  path: 'reminder',
                  // builder: (BuildContext context, GoRouterState state) {
                  //   // Provider.of<TitleProvider>(context, listen: false).title =
                  //   //     'Google Docs';
                  //   return MyFiles();
                  // },
                  pageBuilder:
                      (BuildContext context, GoRouterState mState) {
                    Provider.of<TitleProvider>(context, listen: false)
                        .changeTitle('Reminder');
                    return pageTransitionWidget(ReminderWidget(), mState.pageKey);
                  },),

                GoRoute(
                      name: 'time-sheet',
                      path: 'time-sheet',
                      // builder: (BuildContext context, GoRouterState state) {
                      //   // Provider.of<TitleProvider>(context, listen: false).title =
                      //   //     'Google Docs';
                      //   return MyFiles();
                      // },
                      pageBuilder:
                          (BuildContext context, GoRouterState mState) {
                        final args = mState.extra as Map;
                        Provider.of<TitleProvider>(context, listen: false)
                            .changeTitle('Time Sheet Bill');
                        return pageTransitionWidget(
                            TimeSheetBill(data: args['data'],), mState.pageKey);
                      },),
              ]
            ),
          ],
        ),
        // second branch (B)
        /*StatefulShellBranch(
          navigatorKey: _shellNavigatorKeyDocument,
          routes: [
            // top route inside branch
            GoRoute(
              path: '/b',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: RootScreen(label: 'B', path: '/b/details'),
              ),
              routes: [
                // child route
                GoRoute(
                  path: 'details',
                  builder: (context, state) => const DetailsScreen(label: 'B'),
                ),
              ],
            ),
          ],
        ),*/
      ],
    ),
  ],
);

CustomTransitionPage<void> pageTransitionWidget(Widget screen, LocalKey key) {
  return CustomTransitionPage<void>(
    key: key,
    child: screen,
    transitionDuration: const Duration(milliseconds: 600),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
      opacity: CurveTween(curve: Curves.easeIn).animate(animation),
      child: child,
    ),
  );
}

/*class NavRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[




      GoRoute(
        path: reset_password,
        builder: (BuildContext context, GoRouterState state) =>
            ResetPasswordPage(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: ResetPasswordPage(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
      ),




      GoRoute(
        path: home,
        builder: (BuildContext context, GoRouterState state) => DashboardPage(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: DashboardPage(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
        */ /*routes: [
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              // the UI shell
              return ScaffoldWithNestedNavigation(
                navigationShell: navigationShell,
              );
            },
            branches: [
              // first branch Home
              StatefulShellBranch(
                navigatorKey: _shellNavigatorKeyHome,
                routes: [
                  // top route inside branch
                  GoRoute(
                    path: '/home/a',
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: HomePage(),
                    ),
                    routes: [
                      // child route
                      */ /**/ /*GoRoute(
                      path: 'details',
                      builder: (context, state) => const DetailsScreen(label: 'A'),
                    ),*/ /**/ /*
                    ],
                  ),
                ],
              ),
              */ /**/ /* // second branch Document
            StatefulShellBranch(
              navigatorKey: _shellNavigatorKeyDocument,
              routes: [
                // top route inside branch
                GoRoute(
                  path: '/b',
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: RootScreen(label: 'B', path: '/b/details'),
                  ),
                  routes: [
                    // child route
                    GoRoute(
                      path: 'details',
                      builder: (context, state) => const DetailsScreen(label: 'B'),
                    ),
                  ],
                ),
              ],
            ),
            // third branch Admin
            StatefulShellBranch(
              navigatorKey: _shellNavigatorKeyAdmin,
              routes: [
                // top route inside branch
                GoRoute(
                  path: '/a',
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: RootScreen(label: 'A', path: '/a/details'),
                  ),
                  routes: [
                    // child route
                    GoRoute(
                      path: 'details',
                      builder: (context, state) => const DetailsScreen(label: 'A'),
                    ),
                  ],
                ),
              ],
            ),
            // fourth branch Settings
            StatefulShellBranch(
              navigatorKey: _shellNavigatorKeySettings,
              routes: [
                // top route inside branch
                GoRoute(
                  path: '/b',
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: RootScreen(label: 'B', path: '/b/details'),
                  ),
                  routes: [
                    // child route
                    GoRoute(
                      path: 'details',
                      builder: (context, state) => const DetailsScreen(label: 'B'),
                    ),
                  ],
                ),
              ],
            ),*/ /**/ /*
            ],
          ),
        ],*/ /*
      ),
      */ /*GoRoute(
        path: home,
        builder: (BuildContext context, GoRouterState state) => DashboardPage(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: DashboardPage(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
      ),*/ /*
      GoRoute(
        path: view_customer,
        builder: (BuildContext context, GoRouterState state) =>
            CustomerViewPage(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: CustomerViewPage(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: customer_list,
        builder: (BuildContext context, GoRouterState state) => CustomerList(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: CustomerList(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: add_customer,
        builder: (BuildContext context, GoRouterState state) => AddCustomer(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: AddCustomer(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: staff_list,
        builder: (BuildContext context, GoRouterState state) => StaffList(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: StaffList(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: add_staff,
        builder: (BuildContext context, GoRouterState state) => AddStaff(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: AddStaff(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: material_list,
        builder: (BuildContext context, GoRouterState state) => AddMaterial(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: MaterialList(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: add_material,
        builder: (BuildContext context, GoRouterState state) => AddMaterial(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: AddMaterial(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: service_list,
        builder: (BuildContext context, GoRouterState state) => ServiceList(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: ServiceList(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: add_service,
        builder: (BuildContext context, GoRouterState state) => AddService(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: AddService(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: signup,
        builder: (BuildContext context, GoRouterState state) => SignUp(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: SignUp(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
      ),


      GoRoute(
        path: account_page,
        builder: (BuildContext context, GoRouterState state) => AccountPage(),
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: AccountPage(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: CurveTween(curve: Curves.easeIn).animate(animation),
            child: child,
          ),
        ),
      ),

    ],
  );
}*/
