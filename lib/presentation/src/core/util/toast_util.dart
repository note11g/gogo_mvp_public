import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast_plus/flutter_styled_toast.dart';
import 'package:gogo_mvp/presentation/src/core/util/keyboard_util.dart';
import '../../design/component/components.dart';

class ToastUtil {
  static Future<void> open(
    String text, {
    required BuildContext context,
    double seconds = 3,
  }) {
    final keyboardHeight = KeyboardUtil.getKeyBoardHeight(context);
    final bottomOffset = MediaQuery.sizeOf(context).height * 0.1;

    final completer = Completer<void>();
    showToastWidget(ToastWidget(text),
        context: context,
        position: StyledToastPosition(
            align: Alignment.bottomCenter,
            offset: bottomOffset + keyboardHeight),
        animation: StyledToastAnimation.fade,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: const Duration(milliseconds: 400),
        onDismiss: () => completer.complete(),
        duration: Duration(milliseconds: (seconds * 1000).toInt()));
    return completer.future;
  }

  ToastUtil._();
}

extension ToastUtilExtension on BuildContext {
  Future<void> openToast(String text, {double seconds = 3}) =>
      ToastUtil.open(text, context: this, seconds: seconds);
}
