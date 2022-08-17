import 'dart:io' show File, Directory, FileSystemDeleteEvent;
import 'package:hooks_riverpod/hooks_riverpod.dart' show StateNotifier, StateNotifierProvider;
import 'extension/file_directory_extension.dart';
import '../../util/video_format.dart';
import '../../../data/local/local_data_provider.dart';

/// Provide a [FileDirectoryNotifier]
final fileDirectoryProvider = StateNotifierProvider.autoDispose<FileDirectoryNotifier, List<File>>((ref) {
  final directory = Directory(ref.watch(localStorageProvider.notifier).workerDirecotryPath ?? '');

  return FileDirectoryNotifier(directory);
});

/// Retrieves and manages files in a specified directory.
/// Handles events when there is a change in the specified directory.
class FileDirectoryNotifier extends StateNotifier<List<File>> {
  FileDirectoryNotifier(this.directory) : super(const []) {
    // Retrieves files in the specified directory
    state = directory
        .listSync(recursive: true, followLinks: false)
        .where((e) => monitoreExtensions.contains(e.path.split('.').last))
        .map((e) => File(e.path))
        .toList()
      ..sortLastModifired();

    _watchDirectory();
  }

  /// The directory to watch.
  final Directory directory;

  /// Files to be monitore with [FileDirectoryNotifier] & [fileDirectoryProvider]
  final List<String> monitoreExtensions =
      VideoFormat.values.map((e) => e.name).toList();

  /// Get the directory name.
  String get currentName => directory.name;

  /// Watching a Directory for Changes
  /// An event is fired when a file is created, renamed, or deleted in the specified directory.
  /// Add to state: Creating or Renaming file
  /// Delete to state: Deleting or Renaming file
  void _watchDirectory() {
    directory.watch(recursive: false).forEach((entity) {
      // Skip files other than those to be monitore.
      if (monitoreExtensions.contains(entity.path.split('.').last)) {
        switch (entity.runtimeType) {
          case FileSystemDeleteEvent:
            // Deleteing from the list when deleting or renaming file
            state = state.where((file) => file.path != entity.path).toList();
            break;
          default:
            print(entity);
            break;
        }
      }
    });
  }
}
