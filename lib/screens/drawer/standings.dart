import 'package:f1_news/widgets/navigation/app_bar_custom.dart';
import 'package:f1_news/widgets/navigation/drawer_app.dart';
import 'package:flutter/material.dart';

import '../../widgets/standings/standingsList.dart';

class Standings extends StatelessWidget {
  const Standings({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBarCustom(
          title: "Classifica",
          bottom: const TabBar(
            tabs: [
              Tab(text: "Piloti"),
              Tab(text: "Costruttori"),
            ],
          ),
        ),
      
        drawer: const DrawerApp(),

        body: TabBarView(
          children: [
            StandingsList(type: "drivers"),
            StandingsList(type: "constructors"),
          ],
        ),
      ),
    );
  }
}

