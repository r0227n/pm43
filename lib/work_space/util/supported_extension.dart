enum SupportedExtension {
  webm,
  mp3,
  mp4,
}


/// [SupportedExtension] extension.
extension SupportedExtensionUtil on SupportedExtension {
  /// [SupportedExtension] to FileExtension.
  String get extension => '.$name';
}
