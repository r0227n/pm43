import 'package:flutter/material.dart';

/// Extends [Text] for section title
class SectionTitle extends StatelessWidget {
  const SectionTitle(
    this.data, {
    super.key,
    this.bottomMargin,
    this.fontSizeStyle = 30.0,
    this.fontWeightStyle = FontWeight.w600,
    this.decorationStyle = TextDecoration.underline,
  });

  final String data;

  final double? bottomMargin;

  /// [SectionTitle] font size
  final double fontSizeStyle;

  /// The typeface thickness to use when painting the text (e.g., bold).
  final FontWeight fontWeightStyle;

  /// The decorations to paint near the text (e.g., an underline).
  ///
  /// Multiple decorations can be applied using [TextDecoration.combine].
  final TextDecoration decorationStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin ?? 0.0),
      child: Text(
        data,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: fontSizeStyle,
          fontWeight: fontWeightStyle,
          decoration: decorationStyle,
        ),
      ),
    );
  }
}
