import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../core/providers/provider.dart';
import '../../core/providers/screenProvider.dart';
import 'info_dialog_alert.dart';

class DeletingUser extends ConsumerStatefulWidget {
  const DeletingUser({super.key});

  @override
  ConsumerState<DeletingUser> createState() => _DeletingUser();

}

class _DeletingUser extends ConsumerState<DeletingUser> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscuredPassword = true;

  @override
  Widget build(BuildContext context) {
    final screen = ref.watch(screenProvider);

    return Dialog(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          constraints: BoxConstraints(
            maxWidth: screen.isTablet ? 450 : double.infinity,
            maxHeight: screen.height * 0.85,
          ),

          child: SingleChildScrollView(
            child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
                    Text(
                      "PERICOLO!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: screen.isSmallPhone ? 18 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Attenzione: Questa azione è irreversibile. Tutti i tuoi dati di profilo, i preferiti e le impostazioni verranno cancellati definitivamente.",
                      textAlign: TextAlign.center,
                    ),
                    if (!ref.read(authControllerProvider).isGoogleUser()) ...[
                      FormBuilderTextField(
                        name: 'password',
                        obscureText: _obscuredPassword,
                        decoration: InputDecoration(
                          labelText: 'Inserisci la tua password per confermare',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscuredPassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscuredPassword = !_obscuredPassword),
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: "La password è obbligatoria per confermare"),
                        ]),
                      ),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Annulla"),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                          child: const Text("Elimina definitivamente"),
                        ),
                      ],
                    )
                  ],
                )
            ),
          ),
        )
    );
  }

  Future<void> _submit() async {
    final authController = ref.read(authControllerProvider);
    var password = "";

    if (!authController.isGoogleUser()) {
      if (!_formKey.currentState!.saveAndValidate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Devi inserire la password!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      password = _formKey.currentState!.value['password'];
    }

    try{
      await authController.deleteAccount(password);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account eliminato con successo."), backgroundColor: Colors.green),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Problemi durante l'eliminazione dell'account. Riprova.";

      if (e.code == 'invalid-credential') {
        message = "La password inserita non è corretta.";
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => InfoDialogAlert(messaggio: message),
        );
      }
    }
  }
}
