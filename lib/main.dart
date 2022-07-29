import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;
import 'package:path/path.dart' as p;
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

final _currentFile = Provider<File>((ref) => throw UnimplementedError());

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(fileDirectoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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

/// Provide a [FileDirectoryNotifier]
final fileDirectoryProvider =
    StateNotifierProvider.autoDispose<FileDirectoryNotifier, List<File>>((ref) {
  final directory = ref.watch(envProvider).workDirecotry;

  // Retrieves files in the specified directory
  List<File> files = directory
      .listSync(recursive: true, followLinks: false)
      .where((e) => FileDirectoryNotifier.monitoreExtensions.contains(p.context.extension(e.path)))
      .map((e) => File(e.path))
      .toList()
    ..sortLastModifired();

  return FileDirectoryNotifier(directory, files);
});

/// Retrieves and manages files in a specified directory.
/// Handles events when there is a change in the specified directory.
class FileDirectoryNotifier extends StateNotifier<List<File>> {
  FileDirectoryNotifier(this.direcotry, [List<File>? files]) : super(files ?? const []) {
    _watchDirectory();
  }

  /// The directory to watch.
  final Directory direcotry;

  /// Files to be monitore with [FileDirectoryNotifier] & [fileDirectoryProvider]
  static const List<String> monitoreExtensions = ['.webm', '.mp3', '.mp4'];

  /// Watching a Directory for Changes
  /// An event is fired when a file is created, renamed, or deleted in the specified directory.
  /// Add to state: Creating or Renaming file
  /// Delete to state: Deleting or Renaming file
  void _watchDirectory() {
    direcotry.watch(recursive: false).listen((entity) {
      // // Skip files other than those to be monitore.
      if (monitoreExtensions.contains(entity.path)) {
        return;
      }

      switch (entity.runtimeType) {
        case FileSystemCreateEvent:
          // Adding from the list when creating or renaming file
          state = [
            ...state,
            File(entity.path),
          ]..sortLastModifired();
          break;
        case FileSystemDeleteEvent:
          // Deleteing from the list when deleting or renaming file
          state = state.where((file) => file.path != entity.path).toList();
          break;
        default:
          print(entity);
          break;
        // throw Exception('Unknown event type: ${entity.runtimeType}');
      }
    });
  }
}

/// [List<File>] extension
extension FileDirectoryExtension on List<File> {
  /// Sort by edit date in asc order.
  void sortLastModifired() {
    sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
  }
}
