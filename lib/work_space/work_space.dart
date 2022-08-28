import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useState, useTextEditingController;
import 'package:pm43/data/local/local_data_provider.dart';
import 'util/navigation_icon.dart';
import 'activity_bar/activity_bar.dart';
import 'panel/panel.dart';
import 'panel/download/widgets/input_text_field.dart';

class WorkSpace extends HookConsumerWidget {
  const WorkSpace({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedIndex = useState<NavigationIcon>(NavigationIcon.folder);
    final _txtController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  title: const Text('Setting Workdirectory'),
                  content: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: InputTextField(
                          _txtController,
                          ref.read(localStorageProvider.notifier).workerDirecotryPath ?? 'null',
                          focus: true,
                        ),
                      )),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Row(
        children: <Widget>[
          ActivityBar(
            _selectedIndex,
          ),
          Expanded(
            flex: 8,
            child: Panel(
              _selectedIndex,
            ),
          ),
        ],
      ),
    );
  }
}
