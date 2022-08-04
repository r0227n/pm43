import 'package:flutter/material.dart' show Widget;
import '../folder/folder_panel.dart';
import '../download/download_panel.dart';
import '../../util/navigation_icon.dart';

/// [NavigationIcon] to [Widget]
extension IconToPanelExtension on NavigationIcon {

  /// [NavigationIcon] to [Widget]
  Widget get toPanel {
    switch (this) {
      case NavigationIcon.folder:
        return const FoloderPanel();
      case NavigationIcon.download:
        return const DownloadPanel();
      default:
        throw Exception('$this is not declared');
    }
  }
}