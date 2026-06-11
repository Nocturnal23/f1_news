import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class LanguageProvider extends Notifier<Locale>{
  // Locale -> oggetto che identifica una lingua rappresentata da standard ISO.
  @override
  Locale build() {
    return const Locale('it');
  }

  void toggleLocale() {
    if (state.languageCode == 'it') {
      state = const Locale('en');
    } else {
      state = const Locale('it');
    }
  }
}

final localeProvider = NotifierProvider<LanguageProvider, Locale>(() {
  return LanguageProvider();
});