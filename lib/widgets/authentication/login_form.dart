import 'package:f1_news/widgets/dialogs/info_dialog_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../controllers/auth_controller.dart';
import '../../core/providers/language_provider.dart';
import '../../core/providers/provider.dart';
import 'package:f1_news/l10n/app_localizations.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool obscuredPassword = true;

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(localeProvider, (previous, next) {
      if (previous != next) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_formKey.currentState != null && _formKey.currentState!.errors.isNotEmpty) {
            _formKey.currentState!.validate();
          }
        });
      }
    });

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormBuilderTextField(
                name: 'email',
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  icon: Icon(Icons.mail),
                  labelText: l10n.emailLabel,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: l10n.emptyFieldError
                  ),
                  FormBuilderValidators.email(
                    errorText: l10n.emailFieldError
                  ),
                ]),
              ),

              FormBuilderTextField(
                name: 'password',
                obscureText: obscuredPassword,
                decoration: InputDecoration(
                  icon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscuredPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscuredPassword = !obscuredPassword;
                      });
                    },
                  ),
                  labelText: l10n.passwordLabel,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: l10n.emptyFieldError
                  ),
                ]),
              ),

              Column(
                children: [
                  ElevatedButton(onPressed: _signIn, child: Text(l10n.loginButton)),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(l10n.orText, style: TextStyle(color: Colors.grey)),
                  ),

                  ElevatedButton(
                    onPressed: _signInWithGoogle,
                    child: Text(l10n.loginWithGoogleButton),
                  ),

                  TextButton(
                    onPressed: _restorePassword,
                    child: Text(
                      l10n.forgotPasswordButton,
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AuthController get _auth => ref.read(authControllerProvider);

  Future<void> _signIn() async {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    final data = _formKey.currentState!.value;

    try {
      await _auth.signIn(
        email: data['email'],
        password: data['password'],
      );

      if (mounted) { //Credenziali corrette e verificate.
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      String error = l10n.genericError;

      if (e.toString().contains('email-not-verified')) {
        _showAlert(
          titolo: l10n.titleAccessDenied,
          messaggio: l10n.messageAccessDenied,
        );
        return;
      } else if (e is FirebaseAuthException && e.code == 'invalid-credential') {
        error = l10n.messageAccessError;
      }

      _showAlert(messaggio: error);
      return;
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _auth.googleSignIn();

      if (mounted) {
        Navigator.pop(context);
      }

    } catch (e) {
      if (!mounted) {
        return;
      }

      if (e.toString().contains('google-sign-in-aborted-by-user')) {
        return;
      }
    }
  }

  Future<void> _restorePassword() async {
    final formState = _formKey.currentState;

    if (formState != null) {
      formState.save();
      final email = formState.value['email'];

      if (email == null || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.snackBarRestorePassword),
          ),
        );
        return;
      }

      try {
        await _auth.restorePassword(email);

        if (context.mounted) {
          _showAlert(
            titolo: l10n.titleRestorePassword,
            messaggio: l10n.messageRestorePassword
          );
        }
      } on FirebaseAuthException catch (e) {
        String error = l10n.messageRestoreError;

        if (e.code == 'invalid-email') {
          error = l10n.messageInvalidEmail;
        }

        if (context.mounted) {
          _showAlert(messaggio: error);
        }
      }
    }
  }

  void _showAlert({required String messaggio, String? titolo}) {
    showDialog(
      context: context,
      builder: (context) =>
          InfoDialogAlert(titolo: titolo, messaggio: messaggio),
    );
  }
}
