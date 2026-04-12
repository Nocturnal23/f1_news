import 'package:flutter/material.dart';

import '../chequered_flag.dart';

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
            onTap: () => {},
          ),

          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Ultime Notizie'),
            onTap: () {},
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
