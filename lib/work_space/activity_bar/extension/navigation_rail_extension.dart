import 'package:flutter/material.dart';
import '../../util/navigation_icon.dart';

/// Extension of [NavigationIcon] use in [NavigationRail]
/// [NavigationIcoon] to [NavigationRailDestination]
extension NavigationRailExtension on NavigationIcon {
  /// [NavigationIcon] to [Icon]
  Icon get icon {
    switch (this) {
      case NavigationIcon.folder:
        return const Icon(Icons.folder);
      case NavigationIcon.download:
        return const Icon(Icons.download);
      default:
        throw Exception('$this is not declared');
    }
  }

  /// [NavigationIcon] to outlined [Icon]
  Icon get outlinedIcon {
    switch (this) {
      case NavigationIcon.folder:
        return const Icon(Icons.folder_outlined);
      case NavigationIcon.download:
        return const Icon(Icons.download_outlined);
      default:
        throw Exception('$this is not declared');
    }
  }

  /// [NavigationIcon] to label(String)
  String get label {
    switch (this) {
      case NavigationIcon.folder:
        return 'Folder';
      case NavigationIcon.download:
        return 'Download';
      default:
        throw Exception('$this is not declared');
    }
  }

  /// [NavigationIcon] to [Text] Widget
  Text get toText {
    return Text(label);
  }

  /// [NavigationIcon] to [NavigationRailDestination]
  NavigationRailDestination get toNavigationRailDestination {
    return NavigationRailDestination(
      icon: outlinedIcon,
      selectedIcon: icon,
      label: toText,
    );
  }
}
