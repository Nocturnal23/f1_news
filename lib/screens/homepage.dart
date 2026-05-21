import 'package:f1_news/widgets/racing/card_custom.dart';
import 'package:f1_news/widgets/common/countdown_race.dart';
import 'package:f1_news/widgets/navigation/drawer_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../core/providers/provider.dart';
import '../widgets/navigation/app_bar_custom.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
class _HomepageState extends ConsumerState<Homepage> {

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => const Scaffold(body: Center(child: Text("Errore auth"))),
      data: (user) {
        return Scaffold(
          appBar: AppBarCustom(
            title: "F1 News",
          ),

          drawer: const DrawerApp(),

          body: Center(
            child: Stack(
              children: [
                _buildNextRace(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> signOut() async {
    await AuthController().signOut();
  }

  Widget _buildNextRace() {
    final nextRaceAsync = ref.watch(nextRaceProvider);
    return nextRaceAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.red),
            SizedBox(height: 16),
            Text("Caricamento evento...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      error: (error, stack) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Impossibile caricare i dati della gara.",
          style: TextStyle(color: Colors.red),
        ),
      ),
      data: (nextRace) {
        if (nextRace == null) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sports_score, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "Nessuna gara in programma",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Torna a controllare più tardi per i prossimi eventi.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("EVENTO IN CALENDARIO", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              CardCustom(item: nextRace),
              const SizedBox(height: 10),
              CountdownRace(fp1Start: nextRace.fp1StartDateTime, raceStart: nextRace.raceStartDateTime),
            ],
          ),
        );
      },
    );
  }
}
