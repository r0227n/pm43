import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;
import 'package:path/path.dart' as p show basename;
import 'file_directory_provider.dart';

final _currentFile = Provider<File>((ref) => throw UnimplementedError());

class FileList extends HookConsumerWidget {
  const FileList({super.key, this.panel,});

  final bool? panel;
  
  bool get _display => panel ?? false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(fileDirectoryProvider);
    final scroll = useScrollController();

    return Scaffold(
      appBar: _display ? null :  AppBar(
        title: Text(ref.read(fileDirectoryProvider.notifier).currentName),
      ),
      body: ListView.separated(
        controller: scroll,
        itemCount: files.length,
        itemBuilder: (context, index) {
          return ProviderScope(
            overrides: [
              _currentFile.overrideWithValue(files[index]),
            ],
            child: const CurrentFile(),
          );
        },
        separatorBuilder: (BuildContext context, int index) {  
          return const Divider(height: 0.5);
        },
      ),
    );
  }
}

class CurrentFile extends HookConsumerWidget {
  const CurrentFile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(_currentFile);

    return ListTile(
      title: Text(p.basename(file.path)),
      onTap: () {
        print(file.path);
        // TODO: URL作成処理をきれいにする
        launchUrl(Uri.parse('file:///${file.path}'))
            .then(print)
            .catchError(print);
      },
    );
  }
}
