import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget, useValueNotifier;
import 'components/wrap_filter_chip.dart';
import 'components/output_selecter.dart';
import 'widgets/section_title.dart';
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
            const SectionTitle('YouTube video URL'),
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'URL',
              ),
            ),
            const Spacer(),
            const SectionTitle('Encode Type', bottomMargin: 10.0,),
            WrapFilterChip(
              chipState,
              SupportedExtension.values.map((e) => e.name).toList(),
            ),
            const Spacer(),
            const OutputSelecter(),
            Center(
              child: ElevatedButton(
                onPressed: () => print(chipState),
                child: const Text('Download'),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}