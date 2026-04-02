import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'homepage.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String? email;
  String? password;
  final _formKey = GlobalKey<FormBuilderState>();
  Map signIn = {"email":"", "password":""};

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
              name: 'email',
              onSaved: (value){
                signIn["email"] = value;
              },
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
              onSaved: (value){
                signIn["password"] = value;
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
                  _formKey.currentState!.saveAndValidate();
                  print(signIn);
                }
              },
              child: Text("Accedi"),
            ),
          ],
        ),
      ),
    );
  }
}
