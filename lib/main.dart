import 'dart:io' show Process;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;
import 'env.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

final workDirectoryFilePathProvider = StateProvider<List<String>>((ref) {
  final env = ref.watch(envProvider);
  final lsResult = Process.runSync('ls', [env.workDirecotryPath]);

  return lsResult.stdout.toString().split('\n');
});

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(workDirectoryFilePathProvider.state).state;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: files.length - 1,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(files[index]),
            onTap: () {
              // TODO: URL作成処理をきれいにする
              launchUrl(Uri.parse(
                      'file:///${ref.read(envProvider).workDirecotryPath}/${files[index]}'))
                  .then(print)
                  .catchError(print);
            },
          );
        },
      ),
    );
  }
}
