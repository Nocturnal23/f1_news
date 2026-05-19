import 'package:f1_news/core/models/user.dart';
import 'package:f1_news/core/navigation/routes.dart';
import 'package:f1_news/core/providers/provider.dart';
import 'package:f1_news/widgets/dialogs/change_password.dart';
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

      body: _buildBody(user, screen, context, ref),
    );
  }

  Widget _buildBody(
    UserModel? user,
    ScreenProvider screen,
    BuildContext context,
    WidgetRef ref,
  ) {

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.homepage,
                (route) => false,
          );
        }
      });

      return const SizedBox.shrink();
    }

    return ListView(
      // padding: EdgeInsets.all(16.0),
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: screen.isTablet ? screen.width * 0.15 : 16.0,
      ),
      children: [
        //Parte info account.
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Text(
            "INFORMAZIONI ACCOUNT",
            style: TextStyle(
              fontSize: screen.isSmallPhone ? 13 : 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          elevation: 2,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "Nome utente",
                  style: TextStyle(fontSize: screen.isSmallPhone ? 13 : 16),
                ),
                trailing: Text(
                  user.displayName,
                  style: TextStyle(
                    fontSize: screen.isSmallPhone ? 13 : 16,
                    color: Colors.grey,
                  ),
                ),
              ),

              ListTile(
                title: Text(
                  "Email",
                  style: TextStyle(fontSize: screen.isSmallPhone ? 13 : 16),
                ),
                trailing: Text(
                  user.email,
                  style: TextStyle(
                    fontSize: screen.isSmallPhone ? 13 : 16,
                    color: Colors.grey,
                  ),
                ),
              ),

              ListTile(
                title: Text(
                  "Iscritto dal",
                  style: TextStyle(fontSize: screen.isSmallPhone ? 13 : 16),
                ),
                trailing: Text(
                  "${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}",
                  style: TextStyle(
                    fontSize: screen.isSmallPhone ? 13 : 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),

        //Parte sulla gestine preferiti.
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Text(
            "I TUOI PREFERITI",
            style: TextStyle(
              fontSize: screen.isSmallPhone ? 13 : 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          elevation: 2,
          child: ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text("Gestisci i preferiti"),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const ManageFavorite(),
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Text(
            "SICUREZZA",
            style: TextStyle(
              fontSize: screen.isSmallPhone ? 13 : 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          elevation: 2,
          child: Column(
            children: [
              if (!ref.read(authControllerProvider).isGoogleUser()) ...[
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: Colors.blue),
                  title: const Text("Modifica Password"),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ChangePassword(),
                    );
                  },
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
              ],

              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  "Elimina Account",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.red,
                ),
                onTap: () {
                  //GESTIONE ELIMINA ACCOUNT.
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
