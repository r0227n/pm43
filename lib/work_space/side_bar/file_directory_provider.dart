import 'dart:io' show File, Directory, FileSystemCreateEvent, FileSystemDeleteEvent;
import 'package:hooks_riverpod/hooks_riverpod.dart' show StateNotifier, StateNotifierProvider;
import 'package:path/path.dart' as p show context;
import 'extension/file_directory_extension.dart';
import '../../env.dart';


/// Provide a [FileDirectoryNotifier]
final fileDirectoryProvider = StateNotifierProvider.autoDispose<FileDirectoryNotifier, List<File>>((ref) {
  final directory = ref.watch(envProvider).workDirecotry;

  return FileDirectoryNotifier(directory);
});

/// Retrieves and manages files in a specified directory.
/// Handles events when there is a change in the specified directory.
class FileDirectoryNotifier extends StateNotifier<List<File>> {
  FileDirectoryNotifier(this.directory) : super(const []) {
    // Retrieves files in the specified directory
    state = directory
        .listSync(recursive: true, followLinks: false)
        .where((e) => FileDirectoryNotifier.monitoreExtensions
            .contains(p.context.extension(e.path)))
        .map((e) => File(e.path))
        .toList()
      ..sortLastModifired();

    _watchDirectory();
  }

  /// The directory to watch.
  final Directory directory;

  /// Files to be monitore with [FileDirectoryNotifier] & [fileDirectoryProvider]
  static const List<String> monitoreExtensions = ['.webm', '.mp3', '.mp4'];

  /// Get the directory name.
  String get currentName => directory.name;

  /// Watching a Directory for Changes
  /// An event is fired when a file is created, renamed, or deleted in the specified directory.
  /// Add to state: Creating or Renaming file
  /// Delete to state: Deleting or Renaming file
  void _watchDirectory() {
    directory.watch(recursive: false).listen((entity) {
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
