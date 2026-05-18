import 'package:f1_news/core/models/user.dart';
import 'package:f1_news/core/providers/provider.dart';
import 'package:f1_news/widgets/navigation/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/dialogs/manage_favorite.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;

    return Scaffold(
      appBar: AppBarCustom(title: "Benvenuto ${user?.displayName}"),

      body: _buildBody(user, context),
    );
  }

  Widget _buildBody(UserModel? user, BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        ListTile(
          title: const Text("Nome utente"),
          trailing: Text(
            user!.displayName,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),

        ListTile(
          title: const Text("Email"),
          trailing: Text(
            user!.email,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),

        ListTile(
          title: const Text("Iscritto dal"),
          trailing: Text(
            "${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),

        Center(
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
      ],
    );
  }
}
