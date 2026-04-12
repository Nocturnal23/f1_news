import 'package:f1_news/controllers/auth_controller.dart';
import 'package:f1_news/screens/auth.dart';
import 'package:f1_news/screens/is_email_verified.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StreamBuilder(
          stream: AuthController().authStateChanges,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return IsEmailVerified();
            } else {
              return Auth();
            }
          }
      ),
    );
  }
}
