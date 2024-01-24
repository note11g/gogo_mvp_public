import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gogo_mvp/presentation/presentation.dart';
import 'initialize/initialize_util.dart';

void main() async {
  await InitializeUtil.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GetIt.I.get<GoGoRouteHelper>().routerForInitialize,
      theme: ThemeData(),
    );
  }
}
