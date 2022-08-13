import 'dart:io' show Process;
import 'dart:convert' show utf8;
import 'dart:async' show Completer, StreamController;
import '../exec.dart';
import '../../work_space/util/video_format.dart';

/// Wrap youTube-dl command
class YoutubeDlCommand implements Exec {
  YoutubeDlCommand() {
    Process.run(command, [help]).then((result) {
      if (result.exitCode != 0) {
        throw Exception(
            'youtube-dl error status ${result.exitCode}: ${result.stderr}');
      }
    }).catchError((e) => throw Exception(e));
  }

  @override
  final String command = 'youtube-dl';

  @override
  final String help = '--help';

  /// Get youtube-dl progress
  Stream<double> get progress => _progressController.stream;

  /// Controller of [progress]
  /// control or youtube-dl command progress
  final _progressController = StreamController<double>();

  /// Parse youtube-dl command standard output
  double _parseStdout(String stdout) {
    if (!stdout.contains('[download]')) {
      return 0.0;
    }

    // Get a percentage from the standard output content
    final percentage = stdout
        .split(' ')
        .firstWhere((separate) => separate.contains('%'), orElse: (() => ''));

    // Delete the symbol and make double value
    final double? num =
        double.tryParse(percentage.substring(0, percentage.length - 1));

    if (num == null) {
      throw Exception('youtube-dl standard output parse error: $percentage');
    }

    return num;
  }

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
      .forEach((String output) => _progressController.add(_parseStdout(output)))
      .whenComplete(() async => completer.complete(await process.exitCode))
      .catchError((e) => throw Exception(e));

    /// Error handling
    /// If an error occurs even once during command execution, the process is terminated.
    process.stderr
      .transform(utf8.decoder)
      .listen((error) => throw Exception(error));

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
