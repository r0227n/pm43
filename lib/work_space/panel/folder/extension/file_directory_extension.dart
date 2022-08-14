import 'dart:io' show Directory, File;
import 'package:path/path.dart' as p;

/// [List<File>] extension
extension FileDirectoryExtension on List<File> {
  /// Sort by edit date in asc order.
  void sortLastModifired() {
    sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
  }
}

/// [Directory] extension
extension DirectoryExtension on Directory {
  /// Get the directory name.
  String get name => p.split(path).last;
}
