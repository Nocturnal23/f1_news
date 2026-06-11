import 'package:country_flags/country_flags.dart';
import 'package:f1_news/core/providers/screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/auth_controller.dart';
import '../../core/providers/language_provider.dart';
import '../../core/providers/provider.dart';
import '../../core/navigation/routes.dart';
import '../dialogs/info_dialog_alert.dart';

enum MenuOptions { impostazioniAccount, impostazioniApp, logout }

class AppBarCustom extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;
  final bool showAuthButton;

  const AppBarCustom({
    super.key,
    required this.title,
    this.bottom,
    this.showAuthButton = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final screen = ref.watch(screenProvider);
    final currentLocale = ref.watch(localeProvider);

    return AppBar(
      backgroundColor: Colors.red,
      centerTitle: true,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(title, style: TextStyle(fontSize: screen.isSmallPhone ? 20 : 22)),
      ),
      bottom: bottom,

      actions: [
        IconButton(
          onPressed: () {
            ref.read(localeProvider.notifier).toggleLocale();
          },
          icon: SizedBox(
            width: screen.isSmallPhone ? 20 : 30,
            height: screen.isSmallPhone ? 15 : 20,
            child: CountryFlag.fromCountryCode(
              currentLocale.languageCode == 'it' ? 'IT' : 'GB',
            ),
          ),
        ),

        if(showAuthButton) ...[
          if(user == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 3.0),
              child: SizedBox(
                height: screen.isSmallPhone ? 35 : 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.auth);
                  },
                  child: Text("Accedi", style: TextStyle(fontSize: screen.isSmallPhone ? 15 : 18)),
                ),
              ),
            )
          else
            PopupMenuButton<MenuOptions>(
              icon: const Icon(Icons.account_circle_outlined),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              position: PopupMenuPosition.under,
              onSelected: (MenuOptions value) {
                switch (value) {
                  case MenuOptions.impostazioniAccount:
                    final String? currentRoute = ModalRoute.of(context)?.settings.name;
                    if (currentRoute != Routes.profile) {
                      Navigator.pushNamed(context, Routes.profile);
                    }
                    break;
                  case MenuOptions.impostazioniApp:
                    _showAlert(context);
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
                      value: MenuOptions.logout,
                      child: ListTile(
                        leading: Icon(Icons.exit_to_app, color: Colors.red),
                        title: Text('Esci', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ],
            ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }

  Future<void> _signOut() async {
    await AuthController().signOut();
  }

  void _showAlert(BuildContext context){
    showDialog(
      context: context,
      builder: (context) =>
          InfoDialogAlert(messaggio: "Funzionalità in arrivo"),
    );
  }
}
