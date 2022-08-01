import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;
import 'file_directory_provider.dart';

final _currentFile = Provider<File>((ref) => throw UnimplementedError());

class FileList extends HookConsumerWidget {
  const FileList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(fileDirectoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.read(fileDirectoryProvider.notifier).currentName),
      ),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          return ProviderScope(
            overrides: [
              _currentFile.overrideWithValue(files[index]),
            ],
            child: const CurrentFile(),
          );
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
      title: Text(file.path),
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
