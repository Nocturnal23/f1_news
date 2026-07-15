import 'package:f1_news/core/navigation/routes.dart';
import 'package:f1_news/core/providers/provider.dart';
import 'package:f1_news/core/providers/screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../common/chequered_flag.dart';

class DrawerApp extends ConsumerWidget {
  const DrawerApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final screen = ref.watch(screenProvider);
    final authState = ref.watch(currentUserProvider);
    final user = authState.isLoading ? null : authState.value?.displayName;
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      width: screen.isTablet ? screen.width * 0.50 : screen.width * 0.75,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.only(bottom: screen.isSmallPhone ? 8 : 16),
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(color: Colors.red),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    user ?? l10n.welcomeMessage,
                    style: TextStyle(
                      fontSize: screen.isSmallPhone ? 20 : 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: screen.isSmallPhone ? 15 : 20,
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: ChequeredFlag(),
                    ),
                  ),
                ),
              ],
            ),
          ),


          ListTile(
            leading: const Icon(Icons.home),
            title: Text(l10n.homepage),
            onTap: () {
              Navigator.pop(context); // Questo permette di chiudere il drawer.

              /*
              Ottengo il nome della route corrente.
              ModalRoute.of(context) -> Recupera la route associata al contesto corrente.
              settings -> Contiene le varie informazioni della route compreso il nome.
              name -> Prende appunto il nome.

              Questo mi permette di controllare che la route di destinazione non corrisponda
              a quella di partenza.
              */
              final String? currentRoute = ModalRoute.of(context)?.settings.name;
              if (currentRoute != Routes.homepage) {
                //pushReplacementNamed serve per non accumulare pagine nello stack.
                Navigator.pushReplacementNamed(context, Routes.homepage);
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.article),
            title: Text(l10n.lastNews),
            onTap: () {
              Navigator.pop(context);

              final String? currentRoute = ModalRoute.of(context)?.settings.name;
              if (currentRoute != Routes.news) {
                Navigator.pushReplacementNamed(context, Routes.news);
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: Text(l10n.standings),
            onTap: () {
              Navigator.pop(context);

              final String? currentRoute = ModalRoute.of(context)?.settings.name;
              if (currentRoute != Routes.standings) {
                Navigator.pushReplacementNamed(context, Routes.standings);
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: Text(l10n.driverType),
            onTap: () {
              Navigator.pop(context);

              final String? currentRoute = ModalRoute.of(context)?.settings.name;
              if (currentRoute != Routes.drivers) {
                Navigator.pushReplacementNamed(context, Routes.drivers);
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.factory),
            title: Text(l10n.constructorType),
            onTap: () {
              Navigator.pop(context);

              final String? currentRoute = ModalRoute.of(context)?.settings.name;
              if (currentRoute != Routes.teams) {
                Navigator.pushReplacementNamed(context, Routes.teams);
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: Text(l10n.calendar),
            onTap: () {
              Navigator.pop(context);

              final String? currentRoute = ModalRoute.of(context)?.settings.name;
              if (currentRoute != Routes.races) {
                Navigator.pushReplacementNamed(context, Routes.races);
              }
            },
          ),
        ],
      ),
    );
  }
}
