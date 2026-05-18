import 'package:f1_news/core/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/navigation/routes.dart';

class ManageFavorite extends ConsumerWidget {
  const ManageFavorite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorite = ref.watch(favoritesProvider);

    final driversAsync = ref.watch(driversProvider);
    final driverIds = driversAsync.value
        ?.map((d) => d.driver.id)
        .toSet() ?? {};

    final favoriteDrivers =
    favorite.where(driverIds.contains).toList();

    final favoriteTeams =
    favorite.where((id) => !driverIds.contains(id)).toList();

    return Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        constraints: const BoxConstraints(maxHeight: 500),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "I TUOI PREFERITI",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),

            Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: _buildFavorite(
                                  context,
                                  ref,
                                  title: "Piloti",
                                  item: favoriteDrivers,
                                  route: Routes.drivers
                                )
                            ),

                            const VerticalDivider(width: 12, thickness: 1),

                            Expanded(
                                child: _buildFavorite(
                                    context,
                                    ref,
                                    title: "Costruttori",
                                    item: favoriteTeams,
                                    route: Routes.teams
                                )
                            ),
                          ],
                        )
                    ),
                  ],
                )
            ),
            const Divider(height: 5),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Chiudi", style: TextStyle(color: Colors.red, fontSize: 16)),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildFavorite(BuildContext context, WidgetRef ref, {required String title, required List<String> item, required String route}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 10),

        if(item.isEmpty)
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, route);
              },

              child: const Text(
                "Nessuno selezionato.\nAggiungili qui.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          )
        else
          Expanded(
              child: ListView.builder(
                itemCount: item.length,
                itemBuilder: (context, index) {
                  final id = item[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            id,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),

                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 18,
                          ),
                          onPressed: () {
                            ref.read(favoritesProvider.notifier).toggleFavorite(id);
                          },
                        ),
                      ],
                    ),
                  );

                }
              )
          )
      ],
    );
  }
}
