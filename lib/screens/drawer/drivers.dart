import 'package:f1_news/core/theme/teams_cols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/driver_standing.dart';
import '../../core/providers/provider.dart';
import '../../core/providers/screenProvider.dart';
import '../../widgets/navigation/app_bar_custom.dart';
import '../../widgets/navigation/drawer_app.dart';

class Drivers extends ConsumerStatefulWidget {
  const Drivers({super.key});

  @override
  ConsumerState<Drivers> createState() => _DriversState();
}

class _DriversState extends ConsumerState<Drivers> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final driversState = ref.watch(driversProvider);
    final screen = ref.watch(screenProvider);
    final favoriteId = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBarCustom(title: "Piloti ${DateTime.now().year}"),

      drawer: const DrawerApp(),

      body: driversState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (err, stack) => Center(child: Text("Errore nel caricamento della lista piloti: $err")),
        data: (drivers) {
          return _buildDriverList(drivers, authState.value, screen, favoriteId);
        },
      ),
    );
  }

  Widget _buildDriverList(List<DriverModelStanding> drivers, User? user, ScreenProvider screen, Set<String> favoriteId) {
    if (drivers.isEmpty) {
      return const Center(child: Text("Nessun pilota trovato."));
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(
          horizontal: screen.isTablet ? screen.width * 0.1 : 0
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 2),
      itemCount: drivers.length,
      itemBuilder: (context, index) {
        final driverStand = drivers[index];
        final driver = driverStand.driver;
        final isFav = favoriteId.contains(driver.id);

        return Container(
          color: TeamsCols.getBackground(driverStand.teamId),
          child: ListTile(
            leading: CircleAvatar(
              radius: screen.isSmallPhone ? 20 : 25,
              backgroundColor: TeamsCols.getForeground(driverStand.teamId),
              child: SizedBox(
                child: Image(
                  width: screen.isSmallPhone ? 44 : 56,
                  height: screen.isSmallPhone ? 44 : 56,
                  image: AssetImage("lib/assets/drivers/${driver.id}.webp"),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('${driver.name.substring(0, 1)}${driver.surname.substring(0, 1)}');
                  },
                ),
              ),
            ),

            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${driver.name} ${driver.surname}",
                        style: TextStyle(
                          fontSize: screen.isSmallPhone ? 18 : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 2, color: Colors.black26),
                          ],
                        ),
                      ),
                      Text(
                        driverStand.teamName,
                        style: TextStyle(
                          fontSize: screen.isSmallPhone ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          shadows: [
                            Shadow(blurRadius: 2, color: Colors.black26),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: screen.isSmallPhone ? 28 : 35,
                  height: screen.isSmallPhone ? 28 : 35,
                  child: Image.asset(
                    "lib/assets/logos/${driverStand.teamId}.webp",
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),

            trailing: user != null
                ? IconButton(
                    icon: Icon(
                      isFav ? Icons.star : Icons.star_border,
                      color: isFav ? Colors.amber : null,
                    ),
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).toggleFavorite(driver.id);
                    },
                  )
                : null,
          ),
        );
      },
    );
  }
}
