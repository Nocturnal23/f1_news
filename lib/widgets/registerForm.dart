import 'package:f1_news/controllers/authController.dart';
import 'package:f1_news/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'infoDialogAlert.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormBuilderState>(); // Questa chiave serve per verificare la validità del form.
  bool obscuredPassword = true;

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
              name: 'displayName',
              textInputAction: TextInputAction.next, //Con invio passo al campo successivo.
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Username',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),

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
                helperText: 'Inserisci almeno 6 caratteri di cui:\n'
                    '• 1 minuscola;\n'
                    '• 1 maiuscola;\n'
                    '• 1 numero;\n'
                    '• 1 carattere speciale.',
                helperMaxLines: 6,
                errorMaxLines: 6,
              ),
              validator: FormBuilderValidators.aggregate([
                FormBuilderValidators.required(),
                FormBuilderValidators.hasLowercaseChars(errorText: 'Almeno un carattere minuscolo'),
                FormBuilderValidators.hasUppercaseChars(errorText: 'Almeno un carattere maiuscolo'),
                FormBuilderValidators.hasNumericChars(errorText: 'Almeno un numero'),
                FormBuilderValidators.hasSpecialChars(errorText: 'Almeno un carattere speciale'),
                FormBuilderValidators.minLength(6, errorText: 'Minimo 6 caratteri'),
              ]),
            ),

            ElevatedButton(
              onPressed: _signUp,
              child: const Text("Registrati"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final data = _formKey.currentState!.value;
      try {
        await AuthController().signUp(displayName: data['displayName'], email: data['email'], password: data['password']);
      } on FirebaseAuthException catch(e) {
        String error = "Errore generico. Riprova";

        if (e.code == ErrorsEnums.EMAIL_ALREADY_IN_USE.label) {
          error = "La mail inserita è già in uso da un altro utente.";
        }

        _showAlert(messaggio: error);
      }
    }
  }

  void _showAlert({required String messaggio, String? titolo}) {
    showDialog(
      context: context,
      builder: (context) => InfoDialogAlert(
        titolo: titolo,
        messaggio: messaggio,
      ),
    );
  }
}

