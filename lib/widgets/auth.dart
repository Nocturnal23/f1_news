import 'package:flutter/material.dart';

import 'homepage.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  String? username;
  String? email;
  String? password;
  final _formKey = GlobalKey<FormState>(); // Questa chiave serve per verificare la validità del form.
  Map signUp = {"username":"", "email":"", "password":""};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: .center,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Devi inserire lo userneame!";
                }
                return null;
              },
              onSaved: (value){
                signUp["username"] = value;
              },
              textInputAction: TextInputAction.next,
              //Con invio passo al campo successivo.
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Username',
              ),
            ),

            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Devi inserire una mail valida!";
                }
                return null;
              },
              onSaved: (value){
                signUp["email"] = value;
              },
              textInputAction: TextInputAction.next,
              //Con invio passo al campo successivo.
              decoration: const InputDecoration(
                icon: Icon(Icons.mail),
                labelText: 'Email',
              ),
            ),

            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 10) {
                  return "Devi inserire una password valida!";
                }
                return null;
              },
              onSaved: (value){
                signUp["password"] = value;
              },
              obscureText: true,
              decoration: const InputDecoration(
                icon: Icon(Icons.password),
                labelText: 'Password',
              ),
            ),

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save(); // Se il form risulta valido salvo le credenziali.
                  print(signUp);
                }
              },
              child: Text("INVIA"),
            ),
          ],
        ),
      ),
    );
  }
}

void loadHomepage(BuildContext context, dynamic controller) {
  final username = controller.name;
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (context) => homepage(user: username)),
  );
}
