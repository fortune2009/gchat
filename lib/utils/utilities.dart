import 'package:flutter/material.dart';

class Utilities {
  static bool isKeyboardShowing(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  static closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static double deviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double keyboardHeight(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double adjustedHeight = screenHeight - keyboardHeight;
    return keyboardHeight > 0.0 ? 32 : adjustedHeight;
  }

  static double deviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static String getInitials(String fullName) {
    String initials = "";
    List<String> splitName = fullName.split(" ");
    for (String name in splitName) {
      if (initials.length < 2) {
        initials += name.substring(0, 1);
      }
    }

    return initials.toUpperCase();
  }
}
