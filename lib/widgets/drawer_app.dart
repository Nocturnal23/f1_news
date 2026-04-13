import 'package:f1_news/core/utils/routes.dart';
import 'package:flutter/material.dart';

import 'chequered_flag.dart';

class DrawerApp extends StatelessWidget {
  const DrawerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(color: Colors.red),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: const Text(
                    'F1 News',
                    style: TextStyle(fontSize: 24,
                    fontWeight: FontWeight.bold),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 20,
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
            title: const Text('Homepage'),
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
            title: const Text('Ultime Notizie'),
            onTap: () {
            },
          ),

          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Classifiche'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Calendario'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
