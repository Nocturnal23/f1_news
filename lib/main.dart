import 'package:f1_news/screens/auth.dart';
import 'package:f1_news/screens/drawer/constructors.dart';
import 'package:f1_news/screens/drawer/drivers.dart';
import 'package:f1_news/screens/drawer/races.dart';
import 'package:f1_news/screens/drawer/standings.dart';
import 'package:f1_news/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/utils/routes.dart';
import 'firebase_options.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),

      routes: {
        Routes.homepage: (context) => const Homepage(),
        Routes.auth: (context) => const Auth(),
        Routes.drivers: (context) => const Drivers(),
        Routes.teams: (context) => const Constructors(),
        Routes.standings: (context) => const Standings(),
        Routes.races: (context) => const Races(),
        // Routes.profile: (context) => const Profile(),
        // Routes.settings: (context) => const Settings(),
        // Routes.favorite: (context) => const Favorite(),
        // Routes.news: (context) => const News(),

      },
    );
  }
}