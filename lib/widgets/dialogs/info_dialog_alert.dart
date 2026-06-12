import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(titolo ?? l10n.warningTitle),
      content: Text(messaggio),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();

            if (onPressed != null) {
              onPressed!();
            }
          },
          child: Text(l10n.okButton),
        ),
      ],
    );
  }
}
