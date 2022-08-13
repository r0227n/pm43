import 'dart:async' show Completer;
import 'dart:io' show Process, ProcessResult;
import '../exec.dart';
import '../../work_space/util/video_format.dart';

class YoutubeDlCommand implements Exec {
  YoutubeDlCommand() {
    Process.run(command, [help])
        .then((validateProcess))
        .catchError((e) => throw Exception(e));
  }

  @override
  final String command = 'youtube-dl';

  @override
  final String help = '--help';

  @override
  Future<ProcessResult> run(List<String> arguments) {
    final completer = Completer<ProcessResult>();
    Process.run(command, arguments).then((process) {
      validateProcess(process);
      completer.complete(process);
    }).catchError((e) => throw Exception(e));

    return completer.future;
  }

  @override
  void validateProcess(ProcessResult result) {
    if (result.exitCode != 0) {
      throw Exception('youtube-dl error status ${result.exitCode}: ${result.stderr}');
    }
  }

  Future<ProcessResult> download(VideoFormat format, String outputPath, String videoId) {
    switch (format) {
      case VideoFormat.mp3:
        /// Download youtube videos as mp3
        return run([
          '--extract-audio',
          '--audio-format',
          format.name,
          '--embed-thumbnail',
          '--add-metadata',
          '--output',
          '"$outputPath"',
          videoId
        ]);
      case VideoFormat.mp4:
        /// Download youtube videos as mp4
        return run([
          '-f',
          format.name, 
          '--output',
          '"$outputPath"',
          videoId
        ]);
    }
  }
}
