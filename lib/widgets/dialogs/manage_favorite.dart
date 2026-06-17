import 'package:f1_news/core/providers/provider.dart';
import 'package:f1_news/core/providers/screen_provider.dart';
import 'package:f1_news/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/navigation/routes.dart';

class ManageFavorite extends ConsumerWidget {
  const ManageFavorite({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorite = ref.watch(favoritesProvider);
    final screen = ref.watch(screenProvider);
    final l10n = AppLocalizations.of(context)!;

    final driversAsync = ref.watch(driversProvider);
    if (driversAsync.isLoading) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.red),
              SizedBox(height: 16),
              Text(l10n.loadingFav, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }
    final driverIds = driversAsync.value
        ?.map((d) => d.driver.id)
        .toSet() ?? {};

    final favoriteDrivers =
    favorite.where(driverIds.contains).toList();

    final favoriteTeams =
    favorite.where((id) => !driverIds.contains(id)).toList();

    return Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: screen.isSmallPhone ? 16 : 24,
          vertical: 24,
        ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        constraints: BoxConstraints(maxHeight: screen.height * 0.7),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.favorite,
              style: TextStyle(fontSize: screen.isSmallPhone ? 18 : 20, fontWeight: FontWeight.bold),
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
                                  title: l10n.driver,
                                  item: favoriteDrivers,
                                  route: Routes.drivers,
                                  screen: screen,
                                  l10n: l10n
                                )
                            ),

                            VerticalDivider(width: screen.isSmallPhone ? 16 : 24, thickness: 1),

                            Expanded(
                                child: _buildFavorite(
                                    context,
                                    ref,
                                    title: l10n.team,
                                    item: favoriteTeams,
                                    route: Routes.teams,
                                    screen: screen,
                                    l10n: l10n
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
              child: Text(l10n.windowClose, style: TextStyle(color: Colors.red, fontSize: 16)),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildFavorite(BuildContext context, WidgetRef ref, {required String title, required List<String> item, required String route, required ScreenProvider screen, required AppLocalizations l10n,}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: screen.isSmallPhone ? 15 : 16, color: Colors.grey),
        ),
        const SizedBox(height: 10),

        if(item.isEmpty)
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, route);
              },

              child: Text(
                "${l10n.noSelected}\n${l10n.addFav}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: screen.isSmallPhone ? 12 : 14, color: Colors.blue, decoration: TextDecoration.underline),
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
                            "${id[0].toUpperCase()}${id.substring(1)}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: screen.isSmallPhone ? 12 : 14),
                          ),
                        ),

                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: screen.isSmallPhone ? 16 : 18,
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
