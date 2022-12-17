import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:wit/controller/cache/shared_pref_manager.dart';
import 'package:wit/model/UserAuthInfo.dart';
import 'package:wit/model/enums/auth_type.dart';
import 'cache/db_manager.dart';
import 'providers/AuthProvider.dart';
import 'user_controller.dart';

class AuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  AuthProvider? authProvider;

  static Future<Database> get _db async => await DBManager.instance.database;

  static AuthController? _instance;

  factory AuthController() {
    _instance ??= AuthController._();
    return _instance!;
  }

  AuthController._();

  Future<UserAuthInfo?> getUserAuthInfo() async {
    final snapshot = await DBManager.authStore.find(await _db);

    if (snapshot.isEmpty) return null;

    UserAuthInfo userAuthInfo = UserAuthInfo.fromJson(snapshot.last.value);
    return userAuthInfo;
  }

  Future<int> setUserAuthInfo(UserAuthInfo userAuthInfo) async {
    final int result = await DBManager.authStore.add(
      await _db,
      userAuthInfo.toJson(),
    );
    return result;
  }

  Future<int> deleteUserAuthInfo() async {
    final int result = await DBManager.authStore.delete(await _db);
    return result;
  }

  Future<bool> isUserLoggedIn(BuildContext context,
      {bool promptLogin = true}) async {
    int? loginType = await SharedPrefManager().getInt('login_type');
    var type = loginType != null
        ? AuthType.values.firstWhere((element) => element.intValue == loginType)
        : AuthType.ANONYMOUS_LOGIN;

    if (type == AuthType.ANONYMOUS_LOGIN) {
      bool result = false;
      if (promptLogin) {
        // result = await promptUserLogin(context);
      }
      return result;
    } else {
      return true;
    }
  }

  // Sign-in using cached credentials if credentials have expired.
  Future<User?> signInWithCachedCredentials(BuildContext context) async {
    int? loginType = await SharedPrefManager().getInt('login_type');
    var type;
    type = loginType != null
        ? AuthType.values.firstWhere((element) => element.intValue == loginType)
        : AuthType.ANONYMOUS_LOGIN;

    User? firebaseUser;
    UserAuthInfo? userAuthInfo = await getUserAuthInfo();

    switch (type) {
      case AuthType.ANONYMOUS_LOGIN:
        firebaseUser = await signInAnonymously(context);
        break;
    }
    UserController().firebaseUser = firebaseUser;
    return firebaseUser;
  }

  /* Sign-in methods */
  Future<User?> signInAnonymously(BuildContext context) async {
    try {
      User? firebaseUser;
      if (auth.currentUser == null) {
        firebaseUser = (await auth.signInAnonymously()).user;
      } else if (!auth.currentUser!.isAnonymous) {
        firebaseUser = (await auth.signInAnonymously()).user;
      } else {
        firebaseUser = auth.currentUser;
      }

      String? firebaseToken = await firebaseUser?.getIdToken();
      if (firebaseUser != null) {
        UserAuthInfo userAuthInfo = UserAuthInfo.fromJson({
          'email':firebaseUser.email ??'',
          'fireBaseUserId':firebaseUser.uid ??'',
          'displayName':firebaseUser.displayName ??'',
        });
        authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider?.userAuthInfo = userAuthInfo;
        setUserAuthInfo(userAuthInfo);

        await SharedPrefManager()
            .setInt('login_type', AuthType.ANONYMOUS_LOGIN.intValue);
      }
      return firebaseUser;
    } catch (error, stack) {
      return null;
    }
  }

  Future<User?> handleSignInEmail(context,
      {required String email, required String password}) async {
    if (await checkAccount(email: email)) {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user!;
      await saveUserLocal(user, context);
      return user;
    } else {
      User user = await handleSignUp(email, password, context);
      return user;
    }
  }

  Future<bool> checkAccount({required String email}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<User> handleSignUp(email, password, context) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User? firebaseUser = result.user;
    await saveUserLocal(firebaseUser, context);
    return firebaseUser!;
  }

  saveUserLocal(firebaseUser, context) async {
    if (firebaseUser != null) {
      UserAuthInfo userAuthInfo = UserAuthInfo.fromJson({
        'email':firebaseUser.email ??'',
        'fireBaseUserId':firebaseUser.uid ??'',
        'displayName':firebaseUser.displayName ??'',
      });
      authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider?.userAuthInfo = userAuthInfo;
      setUserAuthInfo(userAuthInfo);

      await SharedPrefManager()
          .setInt('login_type', AuthType.ANONYMOUS_LOGIN.intValue);
    }
  }
}
