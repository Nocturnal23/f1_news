import 'package:f1_news/widgets/racing/card_competitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:f1_news/core/theme/teams_cols.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/providers/provider.dart';
import '../../core/providers/screenProvider.dart';
import '../../widgets/navigation/app_bar_custom.dart';
import '../../widgets/navigation/drawer_app.dart';

class CompetitorsList extends ConsumerWidget {
  final String type; // Prende "drivers" o "constructors"

  const CompetitorsList({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final screen = ref.watch(screenProvider);
    final favoriteIds = ref.watch(favoritesProvider);

    //Caricamento dei dati in base a chi chiama la pagina.
    final dataState = ref.watch(
      type == "drivers" ? driversProvider : constructorsProvider,
    );

    final String title = type == "drivers"
        ? "Piloti ${DateTime.now().year}"
        : "Costruttori ${DateTime.now().year}";

    return Scaffold(
      appBar: AppBarCustom(title: title),
      drawer: const DrawerApp(),
      body: dataState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (err, stack) =>
            Center(child: Text("Errore nel caricamento: $err")),
        data: (listData) {
          if (listData.isEmpty) {
            return const Center(child: Text("Nessun dato disponibile"));
          }

          //Differenziazione di vista tra smartphone e tablet.
          if (screen.isTablet) {
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screen.width > 1000 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.8,
              ),
              itemCount: listData.length,
              itemBuilder: (context, index) {
                return _buildItemCard(
                  context,
                  ref,
                  listData[index],
                  authState.value,
                  favoriteIds,
                  screen,
                );
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: listData.length,
            itemBuilder: (context, index) {
              return _buildItemCard(
                context,
                ref,
                listData[index],
                authState.value,
                favoriteIds,
                screen,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    WidgetRef ref,
    dynamic itemData,
    User? user,
    Set<String> favoriteIds,
    ScreenProvider screen,
  ) {
    final String id = type == "drivers" ? itemData.driver.id : itemData.id;

    final String title = type == "drivers"
        ? "${itemData.driver.name} ${itemData.driver.surname}"
        : itemData.name;

    String subtitle = type == "drivers" ? itemData.teamName : "";

    if (type == "constructors") {
      final teamDrivers = ref.watch(driversProvider).value
          ?.where((d) => d.teamId == itemData.id) // Filtro per team.
          .map((d) => d.driver.surname)           // Recupero dei cognomi dei piloti.
          .take(2)
          .join(" - ");

      subtitle = (teamDrivers?.isNotEmpty == true) ? teamDrivers! : "Scuderia F1";
    }

    final String teamId = type == "drivers" ? itemData.teamId : itemData.id;
    final Color teamColor = TeamsCols.getBackground(teamId);
    final isFav = favoriteIds.contains(id);

    return InkWell(
      onTap: () async {
        final repository = ref.read(f1RepositoryProvider);
        final extraData = await repository.fetchCompetitorExtra(type, id);
        showDialog(
          context: context,
          builder: (context) => CardCompetitor(type: type, item: itemData, name: title, extraData: extraData),
        );
      },

      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        margin: screen.isTablet
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [teamColor.withValues(), Colors.black87],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: screen.isTablet ? 16 : 12,
              vertical: screen.isTablet ? 12 : 6,
            ),

            leading: Container(
              width: screen.isTablet ? 65 : 50,
              height: screen.isTablet ? 65 : 50,
              decoration: BoxDecoration(
                color: TeamsCols.getForeground(teamId),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  type == "drivers"
                      ? "lib/assets/drivers/$id.webp"
                      : "lib/assets/logos/$id.webp",
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        title.substring(0, 2).toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            title: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screen.isTablet
                    ? 18
                    : (screen.isSmallPhone ? 14 : 16),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                fontSize: screen.isTablet
                    ? 14
                    : (screen.isSmallPhone ? 11 : 13),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (type == "drivers")
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: screen.isSmallPhone ? 24 : 30,
                      height: screen.isSmallPhone ? 24 : 30,
                      child: Image.asset(
                        "lib/assets/logos/$teamId.webp",
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                      ),
                    ),
                  ),
                if (user != null)
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      isFav ? Icons.star : Icons.star_border,
                      color: isFav ? Colors.amber : Colors.white60,
                      size: screen.isTablet ? 26 : 22,
                    ),
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).toggleFavorite(id);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
