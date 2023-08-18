import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

GoRouter _appRoute = GoRouter(routes: <RouteBase>[
  GoRoute(
    path: "/",
    builder: (BuildContext context, GoRouterState state) {
      return const HomePage();
    },
  ),
]);


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRoute,
    );
  }
}
