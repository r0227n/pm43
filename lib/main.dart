import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show ProviderScope;
import 'env.dart';
import 'features/work_space.dart';

void main() {
  Env.initialize().then((env) {
    runApp(
      ProviderScope(
        overrides: [
          envProvider.overrideWithValue(env),
        ],
        child: const MyApp(),
      ),
    );
  }).catchError(print);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WorkSpace(title: 'Flutter Demo Home Page'),
    );
  }
}