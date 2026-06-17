import 'package:f1_news/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'language_provider.dart';

void showOfflineSnackBar(AppLocalizations l10n, bool isAppConnected) {
  final messenger = scaffoldMessengerKey.currentState;
  if (messenger == null) return;

  messenger
    ..clearSnackBars()
    ..removeCurrentSnackBar();

  messenger.showSnackBar(
    SnackBar(
      content: Text(
        isAppConnected ?l10n.okConnection : l10n.noConnection,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isAppConnected ? Colors.green : Colors.red,
      duration: const Duration(seconds: 5),
    ),
  );
}

final startNetworkMonitoring = Provider<void>((ref) {
    InternetConnection().onStatusChange.listen((status) {
      final connected = status == InternetStatus.connected;

      final currentLocale = ref.read(localeProvider);
      final l10n = lookupAppLocalizations(currentLocale);

      final messenger = scaffoldMessengerKey.currentState;
      if (messenger == null) return;

      messenger.clearSnackBars();

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            connected ? l10n.okConnection : l10n.noConnection,
          ),
          backgroundColor: connected ? Colors.green : Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    });
});
