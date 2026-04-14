import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../core/repository/jolpica_repository.dart';
import '../core/models/drivers_models.dart';
import '../core/services/jolpica_service.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/drawer_app.dart';

class Drivers extends StatefulWidget {
  const Drivers({super.key});

  @override
  State<Drivers> createState() => _DriversState();
}

class _DriversState extends State<Drivers> {
  final user = AuthController().currentUser;
  final F1Repository _repository = F1Repository(ApiService());
  final Set<String> _favoriteIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: "Piloti ${DateTime.now().year}",
      ),

      drawer: const DrawerApp(),

      body: Center(
        child: _buildDriverList(),
      ),
    );
  }

  Widget _buildDriverList() {
    return FutureBuilder<List<DriverModel>>(
      future: _repository.fetchDrivers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Colors.red);
        } else if (snapshot.hasError) {
          return Text("Errore: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Nessun pilota trovato");
        }

        final drivers = snapshot.data!;

        return ListView.builder(
          itemCount: drivers.length,
          itemBuilder: (context, index) {
            final driver = drivers[index];
            final isFav = _favoriteIds.contains(driver.id);

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: Text('${driver.name.substring(0,1)}${driver.surname.substring(0,1)}')
              ),
              title: Text("${driver.name} ${driver.surname}"),
              subtitle: Text(driver.nationality),
              trailing: IconButton(
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
              ),
            );
          },
        );
      },
    );
  }
}
