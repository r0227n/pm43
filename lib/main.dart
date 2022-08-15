import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show ProviderScope;
import 'package:isar/isar.dart' show Isar;
import 'package:path_provider/path_provider.dart' show getApplicationSupportDirectory;
import 'env.dart';
import 'work_space/work_space.dart';
import 'data/local/local_data_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationSupportDirectory();

  final Isar isar = await Isar.open(
    schemas: [AppSettingSchema],
    directory: dir.path,
  );

  Env.initialize().then((env) {
    runApp(
      ProviderScope(
        overrides: [
          isarInstanceProvider.overrideWithValue(isar),
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