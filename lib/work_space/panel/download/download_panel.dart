import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget, useValueNotifier;
import 'components/wrap_filter_chip.dart';
import '../../util/supported_extension.dart';

/// WorkSpace Download Panel
class DownloadPanel extends HookWidget {
  const DownloadPanel({super.key});

  @override
  Widget build(BuildContext context) {
    /// [_FilterChipWidget] State
    final chipState = useValueNotifier(List<bool>.filled(
        SupportedExtension.values.length, false,
        growable: false));

    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'URL',
              ),
            ),
            const Spacer(),
            const Text('Encode Type'),
            const Divider(),
            WrapFilterChip(
              chipState,
              SupportedExtension.values.map((e) => e.name).toList(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => print(chipState),
                child: const Text('hoge'),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}