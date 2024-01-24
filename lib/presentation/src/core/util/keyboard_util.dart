import 'package:flutter/cupertino.dart';

class KeyboardUtil {
  static void hideKeyboard(BuildContext context) {
    final scope = FocusScope.of(context);
    final tempFocusNode = FocusNode();
    scope.requestFocus(tempFocusNode);
    tempFocusNode
      ..unfocus()
      ..dispose();
  }

  static double getKeyBoardHeight(BuildContext context) =>
      EdgeInsets.fromViewPadding(
              View.of(context).viewInsets, View.of(context).devicePixelRatio)
          .bottom;

  KeyboardUtil._();
}
