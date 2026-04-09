enum ErrorsEnums {
  INVALID_CREDENTIAL('invalid-credential'),
  EMAIL_ALREADY_IN_USE('email-already-in-use'),
  UNKNOWN('unknown');

  final String label;
  const ErrorsEnums(this.label);
}