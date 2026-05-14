import 'package:f1_news/core/models/constructor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/provider.dart';
import '../../core/providers/screenProvider.dart';
import '../../core/theme/teams_cols.dart';
import '../../widgets/navigation/app_bar_custom.dart';
import '../../widgets/navigation/drawer_app.dart';

class Constructors extends ConsumerStatefulWidget {
  const Constructors({super.key});

  @override
  ConsumerState<Constructors> createState() => _ConstructorsState();
}

class _ConstructorsState extends ConsumerState<Constructors> {
  final Set<String> _favoriteIds = {};

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final constructorState = ref.watch(constructorsProvider);
    final screen = ref.watch(screenProvider);

    return Scaffold(
      appBar: AppBarCustom(title: "Costruttori ${DateTime.now().year}"),

      drawer: const DrawerApp(),

      body: constructorState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (err, stack) => Center(child: Text("Errore: $err")),
        data: (constructors) {
          return _buildConstructorList(constructors, authState.value, screen);
        },
      ),
    );
  }

  Widget _buildConstructorList(List<ConstructorModel> constructors, User? user, ScreenProvider screen) {
    if (constructors.isEmpty) {
      return const Center(child: Text("Nessun costruttore trovato."));
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(
          horizontal: screen.isTablet ? screen.width * 0.1 : 0
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 2),
      itemCount: constructors.length,
      itemBuilder: (context, index) {
        final team = constructors[index];
        final isFav = _favoriteIds.contains(team.id);

        return Container(
          color: TeamsCols.getBackground(team.id),
          child: ListTile(
            leading: CircleAvatar(
              radius: screen.isSmallPhone ? 20 : 25,
              backgroundColor: TeamsCols.getForeground(team.id),
              child: SizedBox(
                child: Image(
                  width: screen.isSmallPhone ? 44 : 56,
                  height: screen.isSmallPhone ? 44 : 56,
                  image: AssetImage("lib/assets/logos/${team.id}.webp"),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) {
                    return Text(team.name.substring(0, 2).toUpperCase());
                  },
                ),
              ),
            ),

            title: Text(
              team.name,
              style: TextStyle(
                fontSize: screen.isSmallPhone ? 15 : 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
              ),
            ),
            subtitle: Text(
              team.nationality,
              style: TextStyle(
                fontSize: screen.isSmallPhone ? 12 : 14,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
              ),
            ),

            trailing: user != null
                ? IconButton(
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
                  )
                : null,
          ),
        );
      },
    );
  }
}
