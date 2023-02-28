import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/exceptions/auth_exception.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class RegisterController extends ChangeNotifier {
  final UserService _userService;
  String? error;
  bool success = false;

  RegisterController({required UserService userService})
      : _userService = userService;

  Future<void> registerUser(String email, String password) async {
    try {
      error = null;
      success = false;

      notifyListeners();

      final user = await _userService.register(email, password);
      if (user != null) {
        //sucesso
        success = true;
      } else {
        // Erro
        error = 'Erro ao registrar usuário';
      }
      notifyListeners();
    } on AuthException catch (e, s) {
      error = e.message;
    } finally {
      notifyListeners();
    }
  }
}