import 'dart:developer';

import 'package:todo_list_provider/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list_provider/app/exceptions/auth_exception.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class RegisterController extends DefaultChangeNotifier {
  final UserService _userService;

  RegisterController({required UserService userService})
      : _userService = userService;

  Future<void> registerUser(String email, String password) async {
    try {
      showLoadingResetState();
      notifyListeners();

      final user = await _userService.register(email, password);
      if (user != null) {
        //sucesso
        success();
      } else {
        // Erro
        setError('Erro ao registrar usuário');
      }
      notifyListeners();
    } on AuthException catch (e, s) {
      log('Erro ao registrar usuário', error: e, stackTrace: s);
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
