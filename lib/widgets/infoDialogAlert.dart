import 'package:flutter/material.dart';

class InfoDialogAlert extends StatelessWidget {
  String? titolo;
  String messaggio;

  InfoDialogAlert({
    super.key,
    this.titolo = "Errore",
    required this.messaggio,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titolo!),
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
