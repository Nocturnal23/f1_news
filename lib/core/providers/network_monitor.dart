import 'dart:async';

import 'package:f1_news/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'language_provider.dart';

bool isAppConnected = true;
Timer? _offlineTimer;

void showOfflineSnackBar(AppLocalizations l10n, bool isAppConnected) {
  scaffoldMessengerKey.currentState?.showSnackBar(
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
  InternetConnection().onStatusChange.listen((InternetStatus status) {
    final currentLocale = ref.read(localeProvider);
    final l10n = lookupAppLocalizations(currentLocale);

    switch (status) {
      case InternetStatus.connected:
        if (!isAppConnected) {
          isAppConnected = true;
          _offlineTimer?.cancel();
          _offlineTimer = null;

          scaffoldMessengerKey.currentState?.hideCurrentSnackBar();

          showOfflineSnackBar(l10n, isAppConnected);
        }
        break;

      case InternetStatus.disconnected:
        if (isAppConnected) {
          isAppConnected = false;

          showOfflineSnackBar(l10n, isAppConnected);

          _offlineTimer = Timer.periodic(
            const Duration(seconds: 10), (_) {
              if (!isAppConnected) {
                final locale = ref.read(localeProvider);
                final l10n = lookupAppLocalizations(locale);

                showOfflineSnackBar(l10n, isAppConnected);
              }
            },
          );
        }
        break;
    }
  });
});
