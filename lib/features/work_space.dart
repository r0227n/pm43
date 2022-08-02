import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useState;
import 'side_bar/file_list.dart';

class WorkSpace extends HookConsumerWidget {
  const WorkSpace({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedIndex = useState<int>(0);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex.value,
            onDestinationSelected: (int index) {
              _selectedIndex.value = index;
            },
            labelType: NavigationRailLabelType.selected,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.folder_outlined),
                selectedIcon: Icon(Icons.folder),
                label: Text('Folder'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.download_outlined),
                selectedIcon: Icon(Icons.download),
                label: Text('Download'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          const Expanded(
            flex: 2,
            child: FileList(),
          ),
          Expanded(
            flex: 8,
            child: IndexedStack(
              index: _selectedIndex.value,
              children: [
                Container(
                  color: Colors.red,
                ),
                Container(
                  color: Colors.blue,
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
