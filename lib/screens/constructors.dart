import 'package:f1_news/core/models/constructors_models.dart';
import 'package:f1_news/core/models/constructors_models_standings.dart';
import 'package:flutter/material.dart';

import '../core/repository/jolpica_repository.dart';
import '../core/services/jolpica_service.dart';
import '../core/utils/teams_cols.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/drawer_app.dart';

class Constructors extends StatefulWidget {
  const Constructors({super.key});

  @override
  State<Constructors> createState() => _ConstructorsState();
}

class _ConstructorsState extends State<Constructors> {
  final F1Repository _repository = F1Repository(ApiService());
  final Set<String> _favoriteIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: "Costruttori ${DateTime.now().year}",
      ),

      drawer: const DrawerApp(),

      body: Center(
        child: _buildConstructorList(),
      ),
    );
  }

  Widget _buildConstructorList() {
    return FutureBuilder<List<ConstructorModel>>(
      future: _repository.fetchTeams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Colors.red);
        } else if (snapshot.hasError) {
          return Text("Errore: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Nessun team trovato");
        }

        final teams = snapshot.data!;

        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 1),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            final isFav = _favoriteIds.contains(team.id);

            return Container(
              color: TeamsCols.getBackground(team.id),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: TeamsCols.getForeground(team.id),
                  child: SizedBox(
                    child: Image(
                      width: 50,
                      height: 50,
                      image: AssetImage("lib/assets/logos/${team.id}.webp"),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                          team.name.substring(0,2).toUpperCase(),
                        );
                      },
                    ),
                  ),
                ),

                title: Text(
                  team.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
                  ),
                ),
                subtitle: Text(
                  team.nationality,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
                  ),
                ),

                trailing: IconButton(
                  icon: Icon(
                    isFav ? Icons.star : Icons.star_border,
                    color: isFav ? Colors.amber : null,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isFav) {
                        _favoriteIds.remove(team.id);
                      } else {
                        _favoriteIds.add(team.id);
                      }
                    });
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
