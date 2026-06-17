import 'package:f1_news/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'language_provider.dart';

final startNetworkMonitoring = Provider<void>((ref) {
  bool isFirstEvent = true;

  InternetConnection().onStatusChange.listen((status) {
    final connected = status == InternetStatus.connected;

    final currentLocale = ref.read(localeProvider);
    final l10n = lookupAppLocalizations(currentLocale);

    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    if (isFirstEvent) {
      isFirstEvent = false;
      if (connected) return;
    }

    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        content: Text(connected ? l10n.okConnection : l10n.noConnection),
        backgroundColor: connected ? Colors.green : Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  });
});
