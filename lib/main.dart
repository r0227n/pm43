import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
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
  late List<String> _files;

  @override
  void initState() {
    super.initState();
    var result = Process.runSync('ls', [path]);
      final results = result.stdout.toString().split('\n');
      _files = results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _files.length-1,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_files[index]),
            onTap: () {
              // TODO: URL作成処理をきれいにする
              final url = 'file:///$path';
              launchUrl(Uri.parse(url + '/'+ _files[index]))
                .then(print)
                .catchError(print);
            },
          );
        },
      ),
    );
  }
}
