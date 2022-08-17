import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show HookConsumer;
import '../widgets/input_text_field.dart';
import '../widgets/section_title.dart';
import '../../../../data/local/local_data_provider.dart';


enum SaveDirectory {
  woerkDirectory,
  custom,
}

class OutputSelecter extends StatelessWidget {
  const OutputSelecter(this.controller, this.selectSaveDirectory, {super.key});

  final TextEditingController controller;
  final ValueNotifier<SaveDirectory> selectSaveDirectory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionTitle('Select output directory'),
        ValueListenableBuilder<SaveDirectory>(
          valueListenable: selectSaveDirectory,
          builder: (BuildContext context, SaveDirectory select, Widget? _) {
            return Column(
              children: <RadioListTile<SaveDirectory>>[
                RadioListTile<SaveDirectory>(
                  title: const Text('Work Directory'),
                  subtitle: HookConsumer(
                    builder: ((context, ref, child) {
                      final String workerDirecotryPath = ref.watch(localStorageProvider.notifier).workerDirecotryPath ?? 'Worker Directory is not set';
                      
                      return Text(workerDirecotryPath);
                    }),
                  ),
                  value: SaveDirectory.woerkDirectory,
                  groupValue: select,
                  onChanged: (SaveDirectory? select) => selectSaveDirectory.value = select ?? SaveDirectory.woerkDirectory,
                ),
                RadioListTile<SaveDirectory>(
                  title: const Text('Custom Directory'),
                  subtitle: InputTextField(controller, 'Custom Directory'),
                  value: SaveDirectory.custom,
                  groupValue: select,
                  onChanged: (SaveDirectory? select) => selectSaveDirectory.value = select ?? SaveDirectory.custom,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
