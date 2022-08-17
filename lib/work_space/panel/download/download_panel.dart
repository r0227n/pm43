import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show HookConsumer;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'components/output_selecter.dart';
import 'widgets/wrap_filter_chip.dart';
import 'widgets/section_title.dart';
import 'widgets/input_text_field.dart';
import '../../util/video_format.dart';
import '../../../exec/youtube-dl/youtube_dl_command.dart';
import '../../../data/local/local_data_provider.dart';

/// WorkSpace Download Panel
class DownloadPanel extends HookWidget {
  const DownloadPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final selectChip = useValueNotifier<int>(0);
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
              selectChip,
              VideoFormat.values.map((e) => e.name).toList(),
            ),
            const Spacer(),
            OutputSelecter(directorPathController, saveDirectory),
            Center(
              child: HookConsumer(builder: (context, ref, _) {
                return ElevatedButton(
                  child: const Text('Download'),
                  onPressed: () async {
                    late final String videoId;
                    late final String saveDirectoryPath;

                    if (saveDirectory.value == SaveDirectory.woerkDirectory) {
                      final path = ref.read(localStorageProvider.notifier).workerDirecotryPath;
                      saveDirectoryPath = path ?? '';
                    } else {
                      saveDirectoryPath = directorPathController.text;
                    }

                    try {
                      videoId = urlTxtController.text.split('v=')[1];
                    } catch (e) {
                      return;
                    }

                    final yt = YoutubeDlCommand();
                    yt
                        .download(VideoFormat.values[selectChip.value],
                            saveDirectoryPath, videoId)
                        .whenComplete(() => print('fin'));

                    yt.progress.listen((event) {
                      print(event);
                    });
                  },
                );
              }),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
