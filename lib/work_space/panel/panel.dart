import 'package:flutter/material.dart' show StatelessWidget, ValueNotifier, Widget, BuildContext, Material, IndexedStack;
import 'extension/icon_to_panel_extension.dart';
import '../util/navigation_icon.dart';

class Panel extends StatelessWidget {
  const Panel(
    this.segue, {
      super.key,
      this.icons =  NavigationIcon.values,
    }
  );

  final ValueNotifier<NavigationIcon> segue;
  final List<NavigationIcon> icons;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: IndexedStack(
        index: segue.value.index,
        children: <Widget>[
          for (final icon in icons)...[
            icon.toPanel,
          ],
        ],
      ),
    );
  }
}
