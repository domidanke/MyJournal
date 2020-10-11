// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_US locale. All the
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
  String get localeName => 'en_US';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "loginScreenEmailTextFieldHint":
            MessageLookupByLibrary.simpleMessage("Enter your email"),
        "loginScreenErrorDefault": MessageLookupByLibrary.simpleMessage(
            "Something went wrong. Please try again later."),
        "loginScreenErrorInvalidEmail": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email address."),
        "loginScreenErrorUserNotFound": MessageLookupByLibrary.simpleMessage(
            "Sorry, we can\'t find an account with this email address."),
        "loginScreenErrorWrongPassword": MessageLookupByLibrary.simpleMessage(
            "Email or password is invalid. Please try again."),
        "loginScreenLoginButton":
            MessageLookupByLibrary.simpleMessage("Log In"),
        "loginScreenPasswordTextFieldHint":
            MessageLookupByLibrary.simpleMessage("Enter your password"),
        "registrationScreenEmailTextFieldHint":
            MessageLookupByLibrary.simpleMessage("Enter your email"),
        "registrationScreenErrorDefault": MessageLookupByLibrary.simpleMessage(
            "Something went wrong. Please try again later."),
        "registrationScreenErrorEmailAlreadyInUse":
            MessageLookupByLibrary.simpleMessage(
                "The email address is already in use by another account."),
        "registrationScreenErrorInvalidEmail":
            MessageLookupByLibrary.simpleMessage(
                "Please enter a valid email address."),
        "registrationScreenErrorWeakPassword":
            MessageLookupByLibrary.simpleMessage(
                "The password must be at least 6 characters long."),
        "registrationScreenPasswordTextFieldHint":
            MessageLookupByLibrary.simpleMessage("Enter your password"),
        "registrationScreenRegistrationButton":
            MessageLookupByLibrary.simpleMessage("Register"),
        "welcomeScreenLoginButton":
            MessageLookupByLibrary.simpleMessage("Log In"),
        "welcomeScreenRegistrationButton":
            MessageLookupByLibrary.simpleMessage("Register")
      };
}
