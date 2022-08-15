import 'package:hooks_riverpod/hooks_riverpod.dart' show Provider;
import 'package:isar/isar.dart' show Isar;

export 'schema/app_setting.dart';

final isarInstanceProvider = Provider<Isar>((_) => throw UnimplementedError());