import 'package:f1_news/core/utils/enums.dart';
import 'package:f1_news/widgets/info_dialog_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../controllers/auth_controller.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool obscuredPassword = true;
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FormBuilderTextField(
              name: 'email',
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                icon: Icon(Icons.mail),
                labelText: 'Email',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
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
                labelText: 'Password',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _signIn, child: const Text("Accedi")),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("oppure", style: TextStyle(color: Colors.grey)),
                ),

                TextButton(
                  onPressed: _signAsGuest,
                  child: const Text("Entra come ospite"),
                ),
              ],
            ),

            TextButton(
              onPressed: _restorePassword,
              child: const Text(
                'Password dimenticata?',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("oppure", style: TextStyle(color: Colors.grey)),
            ),

            TextButton(
              onPressed: _signInWithGoogle,
              child: const Text("Accedi con Google"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.saveAndValidate()) {
      return;
    }

    final data = _formKey.currentState!.value;

    try {
      await _authController.signIn(
        email: data['email'],
        password: data['password'],
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) {
        return;
      }
      String error = "Errore generico. Riprova";

      if (e.code == ErrorsEnums.INVALID_CREDENTIAL.label) {
        error = "Email o password errate. Riprova.";
      }
      _showAlert(messaggio: error);
    }
  }

  Future<void> _signAsGuest() async {
    try {
      await _authController.signAsGuest();
    } on FirebaseAuthException catch (e) {
      if (!mounted) {
        return;
      }

      String error = "Errore generico. Riprova";

      _showAlert(messaggio: error);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _authController.googleSignIn();
    } on FirebaseAuthException catch (e) {
      String error = "Errore generico. Riprova";
      if (!mounted) {
        return;
      }
      _showAlert(messaggio: error);
    }
  }

  Future<void> _restorePassword() async {
    final formState = _formKey.currentState;

    if (formState != null) {
      formState.save();
      final email = formState.value['email'];

      if (email == null || email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Inserisci prima l'email nel campo apposito"),
          ),
        );
        return;
      }

      try {
        await _authController.restorePassword(email);

        if (context.mounted) {
          _showAlert(
            titolo: "Reset password",
            messaggio:
                "Se l'email è registrata, riceverai a breve un link per reimpostare la password.",
          );
        }
      } on FirebaseAuthException catch (e) {
        String error = "Errore durante il recupero. Riprova.";

        if (e.code == ErrorsEnums.INVALID_EMAIL.label) {
          error = "Il formato dell'email non è valido.";
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
