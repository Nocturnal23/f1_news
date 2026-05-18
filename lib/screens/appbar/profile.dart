import 'package:f1_news/core/models/user.dart';
import 'package:f1_news/core/providers/provider.dart';
import 'package:f1_news/widgets/navigation/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/screenProvider.dart';
import '../../widgets/dialogs/manage_favorite.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final screen = ref.watch(screenProvider);

    return Scaffold(
      appBar: AppBarCustom(title: "Profilo"),

      body: _buildBody(user, screen, context),
    );
  }

  Widget _buildBody(
    UserModel? user,
    ScreenProvider screen,
    BuildContext context,
  ) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        ListTile(
          title: Text(
            "Nome utente",
            style: TextStyle(
              fontSize: screen.isSmallPhone ? 13 : 16,
            ),
          ),
          trailing: Text(
            user!.displayName,
            style: TextStyle(
              fontSize: screen.isSmallPhone ? 13 : 16,
              color: Colors.grey,
            ),
          ),
        ),

        ListTile(
          title: Text(
            "Email",
            style: TextStyle(
              fontSize: screen.isSmallPhone ? 13 : 16,
            ),
          ),
          trailing: Text(
            user!.email,
            style: TextStyle(
              fontSize: screen.isSmallPhone ? 13 : 16,
              color: Colors.grey,
            ),
          ),
        ),

        ListTile(
          title: Text(
            "Iscritto dal",
            style: TextStyle(
              fontSize: screen.isSmallPhone ? 13 : 16,
            ),
          ),
          trailing: Text(
            "${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}",
            style: TextStyle(
              fontSize: screen.isSmallPhone ? 13 : 16,
              color: Colors.grey,
            ),
          ),
        ),

        Center(
          child: SizedBox(
            width: screen.isSmallPhone ? double.infinity : 250,
            height: screen.isSmallPhone ? 45 : 50,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 2.0,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const ManageFavorite(),
                );
              },
              icon: const Icon(Icons.favorite),
              label: const Text("Gestisci i preferiti"),
            ),
          ),
        ),
      ],
    );
  }
}
