import 'package:f1_news/core/models/user.dart';
import 'package:f1_news/core/navigation/routes.dart';
import 'package:f1_news/core/providers/provider.dart';
import 'package:f1_news/l10n/app_localizations.dart';
import 'package:f1_news/widgets/dialogs/change_password.dart';
import 'package:f1_news/widgets/dialogs/deleting_user.dart';
import 'package:f1_news/widgets/navigation/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/screen_provider.dart';
import '../../widgets/dialogs/manage_favorite.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /*
    listener necessario per rilevare i cambi di stato. Poichè a differenza delle
    altre pagina questa viene creata e disegnata solo se l'utente è loggato.
    Per evitare bug allora bisogna catturare il momento in cui l'utente slogga
    o elimina l'account per distruggere questa pagina e passare alla home.
    */
    ref.listen(currentUserProvider, (previous, next) {
      if (next is AsyncData && next.value == null) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.homepage, (route) => false);
      }
    });

    final userState = ref.watch(currentUserProvider);
    final screen = ref.watch(screenProvider);
    final l10n = AppLocalizations.of(context)!;

    return userState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBarCustom(title: l10n.profile),
        body: Center(child: Text("Errore: $error")),
      ),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBarCustom(title: l10n.profile),
          body: _buildBody(user, screen, context, ref, l10n),
        );
      },
    );
  }

  Widget _buildBody(
    UserModel? user,
    ScreenProvider screen,
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
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
            l10n.accountInfo,
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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.username,
                      style: TextStyle(fontSize: screen.isSmallPhone ? 13 : 16),
                    ),

                    SizedBox(width: screen.isSmallPhone ? 13 : 16),

                    Expanded(
                        child: Text(
                          user.displayName,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: screen.isSmallPhone ? 13 : 16,
                            color: Colors.grey,
                          ),
                        ),
                    )
                  ]
                ),
              ),

              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.email,
                      style: TextStyle(fontSize: screen.isSmallPhone ? 13 : 16),
                    ),

                    SizedBox(width: screen.isSmallPhone ? 13 : 16),

                    Expanded(
                        child: Text(
                          user.email,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: screen.isSmallPhone ? 13 : 16,
                            color: Colors.grey,
                          ),
                        ),
                    )
                  ]
                ),
              ),

              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.subscribe,
                      style: TextStyle(fontSize: screen.isSmallPhone ? 13 : 16),
                    ),

                    SizedBox(width: screen.isSmallPhone ? 13 : 16),

                    Expanded(
                      child: Text(
                        "${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}",
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: screen.isSmallPhone ? 13 : 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ]
                ),
              ),
            ],
          ),
        ),

        //Parte sulla gestine preferiti.
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Text(
            l10n.favorite,
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
            title: Text(l10n.manageFavorite),
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
            l10n.security,
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
                  title: Text(l10n.managePassword),
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
                title: Text(
                  l10n.manageAccount,
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
                  showDialog(
                    context: context,
                    builder: (context) => const DeletingUser(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
