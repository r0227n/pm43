import 'package:isar/isar.dart';
part 'app_setting.g.dart';

@Collection()
class AppSetting {
  @Id()
  int? id;

  late String workDirectoryPath;
}