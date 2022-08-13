import 'package:flutter/material.dart';
import '../../../util/video_format.dart';

/// Horizontal list [FilterChip]'s
class WrapFilterChip extends StatelessWidget {
  const WrapFilterChip(
    this.state,
    this.labels, {
    super.key,
    this.space = 15.0,
  });

  /// List of [FilterChip] selected states
  final ValueNotifier<int> state;

  /// List of [FilterChip] labels
  final List<String> labels;

  /// Space between [FilterChip]'s
  /// Default value is [15.0]
  final double space;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: state,
      builder: (BuildContext context, int select, Widget? child) {
        return Wrap(
          spacing: space,
          children: [
            for (var index = 0; index < VideoFormat.values.length; index++) ...[
              FilterChip(
                label: Text(
                  labels[index],
                ),
                selected: select == index,
                onSelected: (bool value) => state.value = index,
              ),
            ],
          ],
        );
      },
    );
  }
}