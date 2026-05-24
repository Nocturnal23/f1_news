import 'package:flutter/material.dart';

class InfoDialogAlert extends StatelessWidget {
  final String? titolo;
  final String messaggio;
  final VoidCallback? onPressed;

  const InfoDialogAlert({
    super.key,
    this.titolo,
    required this.messaggio,
    this.onPressed,
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

            if (onPressed != null) {
              onPressed!();
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
