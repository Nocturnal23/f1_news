enum ErrorsEnums {
  INVALID_CREDENTIAL('invalid-credential'),
  EMAIL_ALREADY_IN_USE('email-already-in-use'),
  INVALID_EMAIL('invalid-email'),
  EMAIL_NOT_VERIFIED('email-not-verified'),
  GOOGLE_SIGNIN_ABORTED('google-sign-in-aborted-by-user'),
  UNKNOWN('unknown');

  final String label;
  const ErrorsEnums(this.label);
}