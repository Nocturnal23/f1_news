import 'package:f1_news/widgets/registerForm.dart';
import 'package:flutter/material.dart';

import 'loginForm.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red.shade500,
          title: const Text('Benvenuto in F1 News'),
          bottom: TabBar(
            dividerColor: Colors.black,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'ACCEDI'),
              Tab(text: 'REGISTRATI'),
            ],
          ),
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