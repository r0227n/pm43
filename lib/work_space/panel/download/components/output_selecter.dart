import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/section_title.dart';
import '../../../../env.dart';

enum SaveLocation {
  woerkDirectory,
  custom,
}

class OutputSelecter extends HookConsumerWidget {
  const OutputSelecter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(envProvider);
    final location = useState(SaveLocation.woerkDirectory);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionTitle('Select output directory'),
        RadioListTile<SaveLocation>(
          title: const Text('Work Directory'),
          subtitle: Text(env.workDirecotryPath),
          value: SaveLocation.woerkDirectory,
          groupValue: location.value,
          onChanged: (SaveLocation? select) =>
              location.value = select ?? SaveLocation.woerkDirectory,
        ),
        RadioListTile<SaveLocation>(
          title: const Text('Custom Directory'),
          subtitle: TextFormField(
            enabled: location.value == SaveLocation.custom,
            decoration: const InputDecoration(
              hintText: 'Save Location',
            ),
          ),
          value: SaveLocation.custom,
          groupValue: location.value,
          onChanged: (SaveLocation? select) =>
              location.value = select ?? SaveLocation.custom,
        ),
      ],
    );
  }
}
