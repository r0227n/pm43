import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget, useState;

/// Horizontal list [FilterChip]'s
class WrapFilterChip extends StatelessWidget {
  const WrapFilterChip(
    this.selects,
    this.labels, {
    super.key,
    this.space = 15.0,
  });

  /// List of [FilterChip] selected states
  final ValueNotifier<List<bool>> selects;

  /// List of [FilterChip] labels
  final List<String> labels;

  /// Space between [FilterChip]'s
  /// Default value is [15.0]
  final double space;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: space,
      children: [
        for (var index = 0; index < selects.value.length; index++) ...[
          _FilterChipWidget(
            selects,
            index,
            labels[index],
          )
        ],
      ],
    );
  }
}

/// [WrapFilterChip] item of [FilterChip]
class _FilterChipWidget extends HookWidget {
  const _FilterChipWidget(this.state, this.index, this.name);

  final ValueNotifier<List<bool>> state;
  final int index;
  final String name;

  @override
  Widget build(BuildContext context) {
    final select = useState(state.value[index]);

    return FilterChip(
      label: Text(name),
      selected: select.value,
      onSelected: (bool value) {
        select.value = value;
        state.value[index] = value;
      },
    );
  }
}
