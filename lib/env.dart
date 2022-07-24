import 'dart:io' show Directory;
import 'dart:convert' show jsonDecode;
import 'package:flutter/services.dart' show rootBundle;

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
		// Load setting.json.
    const String jsonPath = 'lib/setting.json';
		// TODO: file読み込み処理でjsonを開き、flutterに依存しない形で実装する
    final jsonString = await rootBundle.loadString(jsonPath).catchError(
        (e) => throw Exception('Failed to read configuration file: $e'));
    final json = jsonDecode(jsonString);
    return Env.fromJson(json);
  }
}
