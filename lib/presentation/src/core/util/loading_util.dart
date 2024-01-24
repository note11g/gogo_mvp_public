import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:view_model_kit/view_model_kit.dart';
import 'toast_util.dart';

extension LoadingIndicatorExtension on BuildContext {
  Future<T> load<T>(Future<T> Function() func, {bool errorToast = true}) async {
    final closingDialog = Completer();
    showDialog(
            context: this,
            builder: (context) => const Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  CircularProgressIndicator(
                      color: Colors.white, backgroundColor: Colors.transparent),
                ])),
            barrierDismissible: false)
        .whenComplete(() => closingDialog.complete());
    try {
      final res = await func.call();
      pop();
      return res;
    } catch (e) {
      pop();
      if (errorToast) ToastUtil.open(e.toString(), context: this);
      rethrow;
    }
  }
}

Future<V> waitRxValueWhenLoaded<V>(R<V?> rx) async {
  if (rx.value != null) return rx.value as V;

  final completer = Completer<V>();
  void getOnceObserver(V? v) => completer.complete(v!);
  rx.observe(getOnceObserver);

  final result = await completer.future;
  rx.cancelObserve(getOnceObserver);
  return result;
}
