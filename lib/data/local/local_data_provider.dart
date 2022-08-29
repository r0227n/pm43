import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'schema/app_setting.dart';

export 'schema/app_setting.dart';

final isarInstanceProvider = Provider<Isar>((_) => throw UnimplementedError());

final localStorageProvider = StateNotifierProvider((ref) {
  final instance = ref.watch(isarInstanceProvider);

  return LocalStorageNotifier(instance);
});

class LocalStorageNotifier extends StateNotifier<Isar> {
  LocalStorageNotifier(this.instance) : super(instance) {
    _id = appSetting.where().findFirstSync()?.id ?? throwError;
  }

  final Isar instance;
  late final int _id;

  IsarCollection<AppSetting> get appSetting => instance.appSettings;

  String? get workerDirecotryPath => appSetting.getSync(_id)?.workDirectoryPath;

  void updateWorkDirectoryPath(String path) {
    final update = AppSetting()
                    ..id = _id
                    ..workDirectoryPath = path; 
                    
    state.writeTxnSync((isar) => appSetting.putSync(update));
  }

  get throwError => throw UnimplementedError();
}
