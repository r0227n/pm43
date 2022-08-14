import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show useState;
import 'util/navigation_icon.dart';
import 'activity_bar/activity_bar.dart';
import 'panel/panel.dart';

class WorkSpace extends HookConsumerWidget {
  const WorkSpace({super.key, required this.title});

  final String title;

  static const icons = [
    NavigationIcon.folder,
    NavigationIcon.download,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectedIndex = useState<NavigationIcon>(NavigationIcon.folder);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Row(
        children: <Widget>[
          ActivityBar(_selectedIndex,),
          Expanded(
            flex: 8,
            child: Panel(_selectedIndex,),
          ),
        ],
      ),
    );
  }
}
