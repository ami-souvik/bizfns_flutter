// // private navigators
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// final _rootNavigatorKey = GlobalKey<NavigatorState>();
// final _shellNavigatorKeyHome = GlobalKey<NavigatorState>(debugLabel: 'Home Navigator Stack');
// final _shellNavigatorKeyDocument = GlobalKey<NavigatorState>(debugLabel: 'Document navigator Stack');
// final _shellNavigatorKeyAdmin = GlobalKey<NavigatorState>(debugLabel: 'Admin navigator Stack');
// final _shellNavigatorKeySettings = GlobalKey<NavigatorState>(debugLabel: 'Settings navigator Stack');
//
// final bizfnsRouter = GoRouter(
//   initialLocation: '/a',
//   navigatorKey: _rootNavigatorKey,
//   routes: [
//     StatefulShellRoute.indexedStack(
//       builder: (context, state, navigationShell) {
//         // the UI shell
//         return ScaffoldWithNestedNavigation(
//           navigationShell: navigationShell,
//         );
//       },
//       branches: [
//         // first branch Home
//         StatefulShellBranch(
//           navigatorKey: _shellNavigatorKeyHome,
//           routes: [
//             // top route inside branch
//             GoRoute(
//               path: '/a',
//               pageBuilder: (context, state) => const NoTransitionPage(
//                 child: RootScreen(label: 'A', path: '/a/details'),
//               ),
//               routes: [
//                 // child route
//                 GoRoute(
//                   path: 'details',
//                   builder: (context, state) => const DetailsScreen(label: 'A'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         // second branch Document
//         StatefulShellBranch(
//           navigatorKey: _shellNavigatorKeyDocument,
//           routes: [
//             // top route inside branch
//             GoRoute(
//               path: '/b',
//               pageBuilder: (context, state) => const NoTransitionPage(
//                 child: RootScreen(label: 'B', path: '/b/details'),
//               ),
//               routes: [
//                 // child route
//                 GoRoute(
//                   path: 'details',
//                   builder: (context, state) => const DetailsScreen(label: 'B'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         // third branch Admin
//         StatefulShellBranch(
//           navigatorKey: _shellNavigatorKeyAdmin,
//           routes: [
//             // top route inside branch
//             GoRoute(
//               path: '/a',
//               pageBuilder: (context, state) => const NoTransitionPage(
//                 child: RootScreen(label: 'A', path: '/a/details'),
//               ),
//               routes: [
//                 // child route
//                 GoRoute(
//                   path: 'details',
//                   builder: (context, state) => const DetailsScreen(label: 'A'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         // fourth branch Settings
//         StatefulShellBranch(
//           navigatorKey: _shellNavigatorKeySettings,
//           routes: [
//             // top route inside branch
//             GoRoute(
//               path: '/b',
//               pageBuilder: (context, state) => const NoTransitionPage(
//                 child: RootScreen(label: 'B', path: '/b/details'),
//               ),
//               routes: [
//                 // child route
//                 GoRoute(
//                   path: 'details',
//                   builder: (context, state) => const DetailsScreen(label: 'B'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//
//       ],
//     ),
//   ],
// );