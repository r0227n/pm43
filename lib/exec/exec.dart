import 'dart:async' show Future;
import 'dart:io' show ProcessResult;

abstract class Exec {
  /// Exec command
  abstract final String command;

  /// Help command option
  abstract final String help;

  /// Run command async
  Future<ProcessResult> run(List<String> arguments);

  /// Process validation
  void validateProcess(ProcessResult result);
}
