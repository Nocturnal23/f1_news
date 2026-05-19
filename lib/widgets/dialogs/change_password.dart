import 'package:f1_news/core/providers/provider.dart';
import 'package:f1_news/core/providers/screenProvider.dart';
import 'package:f1_news/widgets/dialogs/info_dialog_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePassword> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscuredPassword = true;
  bool _obscuredNewPassword = true;

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

                  Text(
                    "Modifica Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screen.isSmallPhone ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  //Inserimento vecchia password
                  FormBuilderTextField(
                    name: 'currentPassword',
                    obscureText: _obscuredPassword,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock_open),
                      labelText: 'Password attuale',
                      suffixIcon: IconButton(
                        icon: Icon(_obscuredPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscuredPassword = !_obscuredPassword),
                      ),
                    ),
                  ),

                  //Inserimento nuova password
                  FormBuilderTextField(
                    name: 'newPassword',
                    obscureText: _obscuredNewPassword,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.password),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscuredNewPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() => _obscuredNewPassword = !_obscuredNewPassword),
                      ),
                      labelText: 'Nuova password',
                      helperText:
                      'Inserisci almeno 6 caratteri di cui:\n'
                          '• 1 minuscola;\n'
                          '• 1 maiuscola;\n'
                          '• 1 numero;\n'
                          '• 1 carattere speciale.',
                      helperMaxLines: 6,
                      errorMaxLines: 6,
                    ),
                    validator: FormBuilderValidators.aggregate([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.hasLowercaseChars(
                        errorText: 'Almeno un carattere minuscolo',
                      ),
                      FormBuilderValidators.hasUppercaseChars(
                        errorText: 'Almeno un carattere maiuscolo',
                      ),
                      FormBuilderValidators.hasNumericChars(
                        errorText: 'Almeno un numero',
                      ),
                      FormBuilderValidators.hasSpecialChars(
                        errorText: 'Almeno un carattere speciale',
                      ),
                      FormBuilderValidators.minLength(
                        6,
                        errorText: 'Minimo 6 caratteri',
                      ),
                    ]),
                  ),

                  //Conferma password
                  FormBuilderTextField(
                    name: 'confirmPassword',
                    obscureText: _obscuredNewPassword,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.done_all, color: Colors.green),
                      labelText: 'Conferma nuova password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscuredNewPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscuredNewPassword = !_obscuredNewPassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Campo obbligatorio";
                      if (value != _formKey.currentState?.fields['newPassword']?.value) {
                        return "Le password non corrispondono";
                      }
                      return null;
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Annulla"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Aggiorna"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.saveAndValidate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Devi compilare tutti i campi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = _formKey.currentState!.value;

    if (data['currentPassword'] == data['newPassword']) {
      showDialog(
        context: context,
        builder: (context) => InfoDialogAlert(messaggio: "La nuova e la vecchia password non possono combaciare"),
      );
      return;
    }

    try {
      final authController = ref.read(authControllerProvider);

      await authController.changePassword(data['currentPassword'], data['newPassword']);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password aggiornata con successo!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Impossibile aggiornare la password. Riprova.";

      if(e.code == 'invalid-credential') {
        errorMessage = "La password inserita non è corretta.";
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => InfoDialogAlert(messaggio: errorMessage),
        );
      }
    }
  }
}
