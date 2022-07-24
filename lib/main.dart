import 'dart:io' show Process;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;
import 'env.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Env env;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<String>>(
        future: _init(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final List<String> _files = snapshot.data ?? const [];
          return ListView.builder(
            itemCount: _files.length - 1,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_files[index]),
                onTap: () {
                  // TODO: URL作成処理をきれいにする
                  launchUrl(Uri.parse('file:///${env.workDirecotryPath}/${_files[index]}'))
                      .then(print)
                      .catchError(print);
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Read the configuration file
  /// initialize the path to the directory to search.
  /// return a list of files in the directory.
  Future<List<String>> _init() async {
		// Load the configuration file
    env = await Env.initialize().catchError(print);
    final lsResult = Process.runSync('ls', [env.workDirecotryPath]);

    return lsResult.stdout.toString().split('\n');
  }
}
