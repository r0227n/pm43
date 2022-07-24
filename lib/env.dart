import 'dart:io' show Directory, File;
import 'dart:convert' show jsonDecode;

/// Environment variables.
class Env {
  const Env({
    required this.workDirecotry,
		required this.workDirecotryPath,
  });

  /// Work directory.
  final Directory workDirecotry;

	/// Work directory path.
  final String workDirecotryPath;

  /// Convert a json to a [Env] class
  factory Env.fromJson(Map<String, dynamic> json) {
    final Directory work = Directory(json['workDirectory']);

    return Env(
      workDirecotry: work,
			workDirecotryPath: work.path,
    );
  }

  /// Load json file and convert it to a [Env] class
  static Future<Env> initialize() async {
		// setting.json path.
    const String jsonPath = 'lib/setting.json';
		// Load json file.
		final jsonString = await File(jsonPath).readAsString().catchError((e) => throw Exception('Failed to read configuration file: $e'));
		// Convert json to a [Env] class.
    return Env.fromJson(jsonDecode(jsonString));
  }
}
