import 'package:flutter/material.dart';

class DownloadPanel extends StatelessWidget {
  const DownloadPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'URL',
                 prefixIcon: Icon(Icons.help_outline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
