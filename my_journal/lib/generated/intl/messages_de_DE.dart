// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de_DE locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de_DE';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "loginScreenErrorDefault" : MessageLookupByLibrary.simpleMessage("Ups, da ist wohl etwas schief gelaufen. Bitte versuche es erneut."),
    "loginScreenErrorInvalidEmail" : MessageLookupByLibrary.simpleMessage("Bitte gib eine valide E-Mail Adresse ein."),
    "loginScreenErrorUserNotFound" : MessageLookupByLibrary.simpleMessage("Sorry, wir können keinen Account mit dieser E-Mail Adresse finden."),
    "loginScreenErrorWrongPassword" : MessageLookupByLibrary.simpleMessage("Die E-Mail Adresse oder das Passwort sind nicht korrekt. Bitte versuche es erneut."),
    "registrationScreenBackToLoginButton" : MessageLookupByLibrary.simpleMessage("Zurück zum Log-In"),
    "registrationScreenEmailTextFieldHint" : MessageLookupByLibrary.simpleMessage("E-Mail eingeben"),
    "registrationScreenErrorDefault" : MessageLookupByLibrary.simpleMessage("Ups, da ist wohl etwas schief gelaufen. Bitte versuche es erneut."),
    "registrationScreenErrorEmailAlreadyInUse" : MessageLookupByLibrary.simpleMessage("Diese E-Mail Adresse ist bereits vergeben."),
    "registrationScreenErrorInvalidEmail" : MessageLookupByLibrary.simpleMessage("Bitte gib eine valide E-Mail Adresse ein."),
    "registrationScreenErrorWeakPassword" : MessageLookupByLibrary.simpleMessage("Das Passwort muss mindestens 6 Zeichen lang sein."),
    "registrationScreenPasswordTextFieldHint" : MessageLookupByLibrary.simpleMessage("Passwort eingeben"),
    "registrationScreenRegistrationButton" : MessageLookupByLibrary.simpleMessage("Registrieren"),
    "registrationScreenTopLabel" : MessageLookupByLibrary.simpleMessage("Registrieren"),
    "welcomeScreenAppName" : MessageLookupByLibrary.simpleMessage("MyJournal"),
    "welcomeScreenEmailTextFieldHint" : MessageLookupByLibrary.simpleMessage("E-Mail eingeben"),
    "welcomeScreenForgotPasswordButton" : MessageLookupByLibrary.simpleMessage("Password vergessen?"),
    "welcomeScreenLoginButton" : MessageLookupByLibrary.simpleMessage("Einloggen"),
    "welcomeScreenPasswordTextFieldHint" : MessageLookupByLibrary.simpleMessage("Passwort eingeben"),
    "welcomeScreenRegistrationButton" : MessageLookupByLibrary.simpleMessage("Registrieren")
  };
}
