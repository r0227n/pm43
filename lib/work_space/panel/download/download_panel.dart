import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'components/wrap_filter_chip.dart';
import 'components/output_selecter.dart';
import 'widgets/section_title.dart';
import 'widgets/input_text_field.dart';
import '../../util/supported_extension.dart';

/// WorkSpace Download Panel
class DownloadPanel extends HookWidget {
  const DownloadPanel({super.key});

  @override
  Widget build(BuildContext context) {
    /// [WrapFilterChip] State
    final chipState = useValueNotifier(List<bool>.filled(
        SupportedExtension.values.length, false,
        growable: false));
    final urlTxtController = useTextEditingController();
    final directorPathController = useTextEditingController();
    final saveDirectory = useValueNotifier(SaveDirectory.woerkDirectory);

    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SectionTitle('YouTube video URL'),
            InputTextField(
              urlTxtController,
              'URL',
              focus: true,
            ),
            const Spacer(),
            const SectionTitle(
              'Encode Type',
              bottomMargin: 10.0,
            ),
            WrapFilterChip(
              chipState,
              SupportedExtension.values.map((e) => e.name).toList(),
            ),
            const Spacer(),
            OutputSelecter(directorPathController, saveDirectory),
            Center(
              child: ElevatedButton(
                child: const Text('Download'),
                onPressed: () {
                  // TODO: youtube-dl を実行する
                  print(urlTxtController.text);
                  print(directorPathController.text);
                  print(chipState);
                  print(saveDirectory.value);
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
