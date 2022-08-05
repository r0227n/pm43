import 'package:flutter/material.dart';
import 'extension/navigation_rail_extension.dart';
import '../util/navigation_icon.dart';

class ActivityBar extends StatelessWidget {
  const ActivityBar(
    this.segue, {
      super.key,
      this.icons = NavigationIcon.values,
    }
  );

  final ValueNotifier<NavigationIcon> segue;
  final List<NavigationIcon> icons;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: NavigationRail(
        selectedIndex: segue.value.index,
        onDestinationSelected: (int select) => segue.value = icons[select],
        labelType: NavigationRailLabelType.selected,
        destinations: <NavigationRailDestination>[
          for (final icon in icons) icon.toNavigationRailDestination,
        ],
      ),
    );
  }
}
