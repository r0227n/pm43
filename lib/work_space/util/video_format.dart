enum VideoFormat {
  webm,
  mp3,
  mp4,
}

/// [VideoFormat] extension.
extension VideoFormatExtension on VideoFormat {
  /// [VideoFormat] to FileExtension.
  String get extension => '.$name';
}
