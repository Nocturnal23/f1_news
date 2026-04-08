import 'package:f1_news/widgets/infoDialogAlert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../controllers/authController.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool obscuredPassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisAlignment: .center,
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

            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.saveAndValidate()) {
                  final data = _formKey.currentState!.value;
                  try {
                    await signIn(data['email'], data['password']);
                  } on FirebaseAuthException catch (e) {
                    String error = "Errore generico. Riprova";

                    if (e.code == 'invalid-credential') {
                      error = "Email o password errate. Riprova.";
                    }

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return InfoDialogAlert(messaggio: error);
                      },
                    );
                  }
                }
              },
              child: const Text("Accedi"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signIn(String email, String password) async {
    await AuthController().signIn(email: email, password: password);
  }
}


