import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'viewmodels/counter_viewmodel.dart';
import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CounterViewModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: Routes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
