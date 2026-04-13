import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';

enum MenuOptions { impostazioniAccount, impostazioniApp, preferiti, logout }

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isAnonymous;
  final user = AuthController().currentUser;

  AppBarCustom({
    super.key,
    required this.title,
    required this.isAnonymous,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red,
      centerTitle: true,
      title: Text(title),

      actions: [
        if(isAnonymous)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 3.0),
            child: ElevatedButton(
              onPressed: _clearSession,
              child: const Text("Accedi"),
            ),
          ),

        if (!isAnonymous)
          PopupMenuButton<MenuOptions>(
            icon: const Icon(Icons.account_circle_outlined),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            position: PopupMenuPosition.under,
            onSelected: (MenuOptions value) {
              switch (value) {
                case MenuOptions.impostazioniAccount:
                  print("Vai al profilo");
                  break;
                case MenuOptions.impostazioniApp:
                  print("Apri impostazioni");
                  break;
                case MenuOptions.preferiti:
                  print("Gestisci i tuoi preferiti");
                  break;
                case MenuOptions.logout:
                  _signOut();
                  break;
              }
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<MenuOptions>>[
                  const PopupMenuItem<MenuOptions>(
                    value: MenuOptions.impostazioniAccount,
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profilo'),
                    ),
                  ),
                  const PopupMenuItem<MenuOptions>(
                    value: MenuOptions.impostazioniApp,
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Impostazioni'),
                    ),
                  ),
                  const PopupMenuItem<MenuOptions>(
                    value: MenuOptions.preferiti,
                    child: ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text('Preferiti'),
                    ),
                  ),
                  const PopupMenuItem<MenuOptions>(
                    value: MenuOptions.logout,
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app, color: Colors.red),
                      title: Text('Esci', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _clearSession() async {
    await AuthController().clearSession();
  }

  Future<void> _signOut() async {
    await AuthController().signOut();
  }
}
