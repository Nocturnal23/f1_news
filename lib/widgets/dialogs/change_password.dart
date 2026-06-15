import 'dart:math';

import 'package:f1_news/core/providers/provider.dart';
import 'package:f1_news/core/providers/screen_provider.dart';
import 'package:f1_news/widgets/dialogs/info_dialog_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../l10n/app_localizations.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends ConsumerState<ChangePassword> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscuredPassword = true;
  bool _obscuredNewPassword = true;
  AppLocalizations get l10n => AppLocalizations.of(context)!;

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
                    l10n.changePassword,
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
                      labelText: l10n.currentPasswordLabel,
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
                      labelText: l10n.newPasswordLabel,
                      helperText:
                        '${l10n.helperText}\n'
                            '${l10n.detailsHelperText}',

                      helperMaxLines: 6,
                      errorMaxLines: 6,
                    ),
                    validator: FormBuilderValidators.aggregate([
                      FormBuilderValidators.required(),
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

                  //Conferma password
                  FormBuilderTextField(
                    name: 'confirmPassword',
                    obscureText: _obscuredNewPassword,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.done_all, color: Colors.green),
                      labelText: l10n.confirmNewPasswordLabel,
                      suffixIcon: IconButton(
                        icon: Icon(_obscuredNewPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscuredNewPassword = !_obscuredNewPassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return l10n.requiredField;
                      if (value != _formKey.currentState?.fields['newPassword']?.value) {
                        return l10n.passwordNotMatch;
                      }
                      return null;
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.cancelButton),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () { _submit(l10n); },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(l10n.updateButton),
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

  Future<void> _submit(AppLocalizations l10n) async {
    if (!_formKey.currentState!.saveAndValidate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.fillAllFields),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final data = _formKey.currentState!.value;

    if (data['currentPassword'] == data['newPassword']) {
      showDialog(
        context: context,
        builder: (context) => InfoDialogAlert(messaggio: l10n.oldAndNewNotSame),
      );
      return;
    }

    try {
      final authController = ref.read(authControllerProvider);

      await authController.changePassword(data['currentPassword'], data['newPassword']);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.passwordUpdateSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = l10n.updatePasswordError;

      if(e.code == 'invalid-credential') {
        errorMessage = l10n.wrongPassword;
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
