import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'homepage.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String? username;
  String? email;
  String? password;
  final _formKey = GlobalKey<FormBuilderState>(); // Questa chiave serve per verificare la validità del form.
  Map signUp = {"username":"", "email":"", "password":""};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(16.0),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisAlignment: .center,
          children: [
            FormBuilderTextField(
              name: 'username',
              onSaved: (value){
                signUp["username"] = value;
              },
              textInputAction: TextInputAction.next,
              //Con invio passo al campo successivo.
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
              onSaved: (value){
                signUp["email"] = value;
              },
              textInputAction: TextInputAction.next, //Con invio passo al campo successivo.
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
              onSaved: (value){
                signUp["password"] = value;
              },
              obscureText: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.password),
                labelText: 'Password',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.saveAndValidate(); // Se il form risulta valido salvo le credenziali.
                  print(signUp);
                }
              },
              child: Text("Registrati"),
            ),
          ],
        ),
      ),
    );
  }
}