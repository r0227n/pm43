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

enum DlState {
  start,
  error,
  complete,
}

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
                      final path = ref
                          .read(localStorageProvider.notifier)
                          .workerDirecotryPath;
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
                        .catchError((_) {
                      _showSnackBar(context, DlState.error);
                    }).whenComplete(
                            () => _showSnackBar(context, DlState.complete));

                    _showSnackBar(context, DlState.start);

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

  void _showSnackBar(BuildContext context, DlState state) {
    late final Text textWidtet;

    switch (state) {
      case DlState.start:
        textWidtet = const Text('Download start');
        break;
      case DlState.error:
        textWidtet = const Text('Download error');
        break;
      case DlState.complete:
        textWidtet = const Text('Download complete');
        break;
      default:
        throw Exception('Unknown state $state');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
        content: textWidtet,
        duration: const Duration(milliseconds: 1500),
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
