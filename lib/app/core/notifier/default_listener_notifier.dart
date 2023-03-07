import 'package:flutter/cupertino.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/core/ui/messages.dart';

class DefaultListenerNotifier {
  final DefaultChangeNotifier changeNotifier;

  DefaultListenerNotifier({
    required this.changeNotifier,
  });

  void listener({
    required BuildContext context,
    required SuccessVoidCallBack successCallBack,
    EverVoidCallBack? everCallback,
    ErrorVoidCallBack? errorCallBack,
  }) {
    changeNotifier.addListener(() {
      if (everCallback != null) {
        everCallback(changeNotifier, this);
      }
      if (changeNotifier.loading) {
        Loader.show(context);
      } else {
        Loader.hide();
      }
      if (changeNotifier.hasError) {
        if (errorCallBack != null) {
          errorCallBack(changeNotifier, this);
        }
        Messages.of(context).showError(
          changeNotifier.error ?? 'Erro interno',
        );
      } else if (changeNotifier.isSuccess) {
        successCallBack(changeNotifier, this);
      }
    });
  }

  void dispose() {
    changeNotifier.removeListener(() {});
  }
}

typedef SuccessVoidCallBack = void Function(
    DefaultChangeNotifier notifer, DefaultListenerNotifier listenerInstace);
typedef ErrorVoidCallBack = void Function(
    DefaultChangeNotifier notifer, DefaultListenerNotifier listenerInstace);
typedef EverVoidCallBack = void Function(
    DefaultChangeNotifier notifer, DefaultListenerNotifier listenerInstace);
