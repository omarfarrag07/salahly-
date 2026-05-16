import 'package:email_validator/email_validator.dart';
import 'package:flutter/widgets.dart';
import 'package:kafa2a/l10n/languages/app_localizations.dart';

class Validators {
  static String? validateEmail(String? email, BuildContext context) {
    if (email == null || email.trim().isEmpty) {
      return AppLocalizations.of(context).emailRequired;
    }
    if (!EmailValidator.validate(email)) {
      return AppLocalizations.of(context).invalidEmail;
    }
    return null;
  }

  static String? validatePassword(String? password, BuildContext context) {
    if (password == null || password.trim().isEmpty) {
      return AppLocalizations.of(context).passwordRequired;
    } else if (password.length < 6) {
      return AppLocalizations.of(context).passwordIsSmall;
    }
    return null;
  }

  static String? validateConfirmationPasswords(
      String? password, String? confirmPassword, BuildContext context) {
    if (password != confirmPassword) {
      return AppLocalizations.of(context).passwordsDontMatch;
    }
    return null;
  }

  static String? validateNull(String? text, String message) {
    if (text == null || text.trim().isEmpty) {
      return message;
    }
    return null;
  }
}
