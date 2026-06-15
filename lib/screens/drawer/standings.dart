import 'package:f1_news/widgets/navigation/app_bar_custom.dart';
import 'package:f1_news/widgets/navigation/drawer_app.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/racing/standings_list.dart';

class Standings extends StatelessWidget {
  const Standings({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBarCustom(
          title: "${l10n.standings} ${DateTime.now().year}",
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.driverType),
              Tab(text: l10n.constructorType),
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

