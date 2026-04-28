import 'package:f1_news/core/utils/teams_cols.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';
import '../../core/repository/jolpica_repository.dart';
import '../../core/models/drivers_models_standings.dart';
import '../../core/services/jolpica_service.dart';
import '../../core/utils/provider.dart';
import '../../widgets/navigation/app_bar_custom.dart';
import '../../widgets/navigation/drawer_app.dart';

class Drivers extends ConsumerStatefulWidget {
  const Drivers({super.key});

  @override
  ConsumerState<Drivers> createState() => _DriversState();
}

class _DriversState extends ConsumerState<Drivers> {
  final F1Repository _repository = F1Repository(ApiService());
  final Set<String> _favoriteIds = {};

  // late Future<List<DriverModelStandings>> _driversFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   _driversFuture = _repository.fetchOfficialDriversByTeam();
  // }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final driversState = ref.watch(driversProvider);

    return Scaffold(
      appBar: AppBarCustom(title: "Piloti ${DateTime.now().year}"),

      drawer: const DrawerApp(),

      body: driversState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (err, stack) => Center(child: Text("Errore: $err")),
        data: (drivers) {
          return _buildDriverList(drivers, authState.value);
        },
      ),
    );
  }

  Widget _buildDriverList(AsyncValue<User?> authState) {
    return FutureBuilder<List<DriverModelStandings>>(
      future: _driversFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Colors.red);
        } else if (snapshot.hasError) {
          return Text("Errore: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Nessun pilota trovato");
        }

        final drivers = snapshot.data!;

        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 1),
          itemCount: drivers.length,
          itemBuilder: (context, index) {
            final driverStand = drivers[index];
            final driver = driverStand.driver;
            final isFav = _favoriteIds.contains(driver.id);

            return Container(
              color: TeamsCols.getBackground(driverStand.teamId),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: TeamsCols.getForeground(driverStand.teamId),
                  child: SizedBox(
                    child: Image(
                      width: 50,
                      height: 50,
                      image: AssetImage("lib/assets/drivers/${driver.id}.webp"),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                          '${driver.name.substring(0, 1)}${driver.surname.substring(0, 1)}',
                        );
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
                      width: 32,
                      height: 32,
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

                trailing: authState.when(
                  error: (error, stack) => const Text("Errore durante il caricamento dei dati."),
                  loading: () => const CircularProgressIndicator(),
                  data: (user) {
                    if (user == null) return const SizedBox();

                    return IconButton(
                      icon: Icon(
                        isFav ? Icons.star : Icons.star_border,
                        color: isFav ? Colors.amber : null,
                      ),
                      onPressed: () {
                        setState(() {
                          if (isFav) {
                            _favoriteIds.remove(driver.id);
                          } else {
                            _favoriteIds.add(driver.id);
                          }
                        });
                      },
                    );
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
