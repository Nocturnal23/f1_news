import 'dart:async';

import 'package:f1_news/controllers/authController.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class IsEmailVerified extends StatefulWidget {
  const IsEmailVerified({super.key});

  @override
  State<IsEmailVerified> createState() => _IsEmailVerifiedState();
}

class _IsEmailVerifiedState extends State<IsEmailVerified> with WidgetsBindingObserver {
  bool _isEmailVerified = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkEmailVerified();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //Cambio stato.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //L'app è tonata in foreground
      _checkEmailVerified();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isEmailVerified) {
      return const homepage();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Verifica la tua email')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Controllo della verifica della tua email...'),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resendEmail,
              child: const Text('Reinvia email di verifica'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkEmailVerified() async {
    setState(() {
      _isLoading = true;
    });

    bool verificato = await AuthController().isEmailVerified();

    if (mounted) {
      setState(() {
        _isEmailVerified = verificato;
        _isLoading = false;
      });
    }
  }

  Future<void> _resendEmail() async {
    try {
      await AuthController().sendVerificationEmail();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nuova email inviata! Controlla la casella di posta.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Errore: non possiamo inviare troppe mail. Riprova più tardi.')),
        );
      }
    }
  }
}


