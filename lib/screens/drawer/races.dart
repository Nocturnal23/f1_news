import 'package:f1_news/widgets/navigation/drawer_app.dart';
import 'package:flutter/material.dart';

import '../../core/repository/jolpica_repository.dart';
import '../../core/services/jolpica_service.dart';
import '../../widgets/card_custom.dart';
import '../../widgets/navigation/app_bar_custom.dart';

class Races extends StatelessWidget {
  Races({super.key});

  final F1Repository _repository = F1Repository(ApiService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: "Calendario ${DateTime.now().year}"),

      drawer: const DrawerApp(),

      body: FutureBuilder<List<dynamic>>(
        future: _repository.fetchCalendar(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Colors.red)),
            );
          } else if (snapshot.hasError) {
            return Text("Errore: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("Nessun dato disponibile!");
          }

          final data = snapshot.data!;

          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 1),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return CardCustom(item: item);
            },
          );
        },
      ),
    );
  }
}
