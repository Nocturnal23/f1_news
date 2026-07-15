import 'package:f1_news/screens/appbar/profile.dart';
import 'package:f1_news/screens/auth.dart';
import 'package:f1_news/screens/drawer/competitors_list.dart';
import 'package:f1_news/screens/drawer/news_list.dart';
import 'package:f1_news/screens/drawer/races.dart';
import 'package:f1_news/screens/drawer/standings.dart';
import 'package:f1_news/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/navigation/routes.dart';
import 'core/providers/language_provider.dart';
import 'core/providers/screen_provider.dart';
import 'core/providers/network_monitor.dart';
import 'firebase_options.dart';
import 'package:f1_news/l10n/app_localizations.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope( //Questo serve per permettere al provider di funzionar.e
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef sRef) {
    final currentLocale = sRef.watch(localeProvider);
    sRef.watch(startNetworkMonitoring);

    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final size = MediaQueryData.fromView(view).size;
    final shortestSide = size.shortestSide;
    final isTablet = shortestSide >= 600;
    if (!isTablet) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    return ProviderScope(
      overrides: [
        screenProvider.overrideWithValue(
          ScreenProvider(
            width: size.width,
            height: size.height,
            isSmallPhone: size.width < 360,
            isStandardPhone: size.width >= 360 && size.width < 600,
            isTablet: size.width >= 600,
          ),
        ),
      ],

      child: MaterialApp(
        locale: currentLocale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        scaffoldMessengerKey: scaffoldMessengerKey,

        title: "Apex F1",
        home: Homepage(),

        routes: {
          Routes.homepage: (context) => const Homepage(),
          Routes.auth: (context) => const Auth(),
          Routes.drivers: (context) => const CompetitorsList(type: "drivers"),
          Routes.teams: (context) => const CompetitorsList(type: "constructors"),
          Routes.standings: (context) => const Standings(),
          Routes.races: (context) => Races(),
          Routes.profile: (context) => const Profile(),
          // Routes.settings: (context) => const Settings(),
          // Routes.favorite: (context) => const Favorite(),
          Routes.news: (context) => const NewsList(),
        },
      ),
    );
  }
}