import 'package:flutter/material.dart';
import '../../side_bar/file_list.dart';

class FoloderPanel extends StatelessWidget {
  const FoloderPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const FileList(panel: true,);
  }
}
