import 'package:f1_news/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../core/providers/language_provider.dart';
import '../../core/providers/provider.dart';
import '../dialogs/info_dialog_alert.dart';
import 'package:f1_news/l10n/app_localizations.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormBuilderState>(); // Questa chiave serve per verificare la validità del form.
  bool obscuredPassword = true;

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  AuthController get _auth => ref.read(authControllerProvider);

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
                name: 'displayName',
                textInputAction: TextInputAction.next,
                //Con invio passo al campo successivo.
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: l10n.usernameLabel,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: l10n.emptyFieldError
                  ),
                ]),
              ),

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
                  icon: Icon(Icons.password),
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
                  helperText:
                      '${l10n.helperText}\n'
                      '${l10n.detailsHelperText}',
                  helperMaxLines: 6,
                  errorMaxLines: 6,
                ),
                validator: FormBuilderValidators.aggregate([
                  FormBuilderValidators.required(
                      errorText: l10n.emptyFieldError
                  ),
                  FormBuilderValidators.hasLowercaseChars(
                    errorText: l10n.validatorHasLowercaseChars,
                  ),
                  FormBuilderValidators.hasUppercaseChars(
                    errorText: l10n.validatorHasUppercaseChars,
                  ),
                  FormBuilderValidators.hasNumericChars(
                    errorText: l10n.validatorHasNumericChars,
                  ),
                  FormBuilderValidators.hasSpecialChars(
                    errorText: l10n.validatorHasSpecialChars,
                  ),
                  FormBuilderValidators.minLength(
                    6,
                    errorText: l10n.validatorMinLength,
                  ),
                ]),
              ),

              Column(
                children: [
                  ElevatedButton(onPressed: _signUp, child: Text(l10n.registerButton)),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(l10n.orText, style: TextStyle(color: Colors.grey)),
                  ),

                  ElevatedButton(
                    onPressed: _signInWithGoogle,
                    child: Text(l10n.registerWithGoogleButton),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;
      try {
        await _auth.signUp(
          displayName: data['displayName'],
          email: data['email'],
          password: data['password'],
        );

        // Registrazione fatta, quindi compare popup d'avviso.
        await FirebaseAuth.instance.signOut();

        if (mounted) {
          _showAlert( //Il popup che appare a registrazione avvenuta e che chiede la conferma della mail.
            titolo: l10n.titleRegistrationComplete,
            messaggio: l10n.messageRegistrationComplete,
            onConfirm: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          );
        }

      } on FirebaseAuthException catch (e) {
        if (!mounted) {
          return;
        }
        String error = l10n.genericError;

        if (e.code == 'email-already-in-use') { //Il controllo qualora la registrazione non è andata a buon fine e la causa è la mail già presente.
          error = l10n.messageAlreadyInUse;
        }

        _showAlert(messaggio: error);
      }
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

  void _showAlert({required String messaggio, String? titolo, VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (context) =>
          InfoDialogAlert(
              titolo: titolo,
              messaggio: messaggio,
              onPressed: onConfirm,
          ),
    );
  }
}
