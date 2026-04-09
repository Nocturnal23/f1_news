import 'package:flutter/material.dart';

class InfoDialogAlert extends StatelessWidget {
  final String? titolo;
  final String messaggio;

  InfoDialogAlert({
    super.key,
    this.titolo,
    required this.messaggio,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titolo ?? "Attenzione"),
      content: Text(messaggio),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
