import 'dart:async' show Future;

abstract class Exec {
  /// Exec command
  abstract final String command;

  /// Help command option
  abstract final String help;

  /// Execute command
  Future<int> exec(List<String> arguments);
}
