import 'package:f1_news/widgets/authentication/register_form.dart';
import 'package:f1_news/widgets/navigation/app_bar_custom.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../widgets/authentication/login_form.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBarCustom(
          title: l10n.titleAuthLabel,
          bottom: TabBar(
            dividerColor: Colors.black,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: l10n.loginTab),
              Tab(text: l10n.registerTab),
            ],
          ),
          showAuthButton: false,
        ),
        body: const TabBarView(
          children: [
            LoginForm(),

            RegisterForm(),
          ],
        ),
      ),
    );
  }
}