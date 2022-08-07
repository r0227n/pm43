import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField(
    this.txtController,
    this.hintText, {
      super.key,
      this.focus = false
    }
  );

  /// [TextEditingController] for input text
  final TextEditingController txtController;

  /// [InputDecoration] hint text
  final String hintText;

  /// [InputTextField] focus
  final bool focus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: txtController,
      autofocus: focus,
      decoration: InputDecoration(
        hintText: hintText,
        suffix: IconButton(
          icon: const Icon(Icons.cancel_outlined),
          onPressed: () => txtController.clear(),
        ),
      ),
    );
  }
}
