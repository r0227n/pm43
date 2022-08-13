import 'dart:io' show Process;
import 'dart:async' show Completer;
import 'dart:convert' show utf8;
import '../exec.dart';
import '../../work_space/util/video_format.dart';

/// Wrap youTube-dl command
class YoutubeDlCommand implements Exec {
  YoutubeDlCommand() {
    Process.run(command, [help])
      .then((result) {
        if (result.exitCode != 0) {
          throw Exception('youtube-dl error status ${result.exitCode}: ${result.stderr}');
        }
      })
      .catchError((e) => throw Exception(e));
  }

  @override
  final String command = 'youtube-dl';

  @override
  final String help = '--help';

  /// Execute youtube-dl command
  /// arguments: command options
  /// return: Exit code
  @override
  Future<int> exec(List<String> arguments) async {
    final completer = Completer<int>();
    final process = await Process.start(command, arguments);

    /// Get the output of the command
    process.stdout
      .transform(utf8.decoder)
      .forEach(print) // TODO: % を取得し、double値で外部から閲覧できるようにする
      .whenComplete(() async => completer.complete(await process.exitCode))
      .catchError((e) => throw Exception(e));

    /// Error handling
    /// If an error occurs even once during command execution, the process is terminated.
    process.stderr
      .transform(utf8.decoder)
      .first
      .then((error) => throw Exception(error));
    
    return completer.future;
  }

  Future<int> download(VideoFormat format, String outputPath, String videoId) {
    switch (format) {
      case VideoFormat.mp3:
        // Download youtube videos as mp3
        return exec([
          '--extract-audio',
          '--audio-format',
          format.name,
          '--embed-thumbnail',
          '--add-metadata',
          '--output',
          '$outputPath/%(title)s.%(ext)s',
          videoId
        ]);
      case VideoFormat.mp4:
        // Download youtube videos as mp4
        return exec([
          '-f',
          format.name,
          '--output',
          '$outputPath/%(title)s.%(ext)s',
          videoId
        ]);
    }
  }
}
