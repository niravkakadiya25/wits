import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wit/controller/auth_controller.dart';

import 'firestore_controller.dart';

class LoginController {
  static LoginController? _instance;

  factory LoginController() {
    _instance ??= LoginController._();
    return _instance!;
  }

  LoginController._();

  handleSignIn(BuildContext context,
      {required String email, required String password}) async {
    User? firebaseUser = await AuthController()
        .handleSignInEmail(context,email: email, password: password);
    if (firebaseUser != null) {
      await FireStoreController().createDocument();
    }
  }
}
