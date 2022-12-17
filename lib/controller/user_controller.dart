import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wit/model/UserAuthInfo.dart';
import 'auth_controller.dart';
import 'cache/shared_pref_manager.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import 'providers/AuthProvider.dart';

class UserController {
  static UserController? _instance;

  factory UserController() {
    _instance ??= UserController._();
    return _instance!;
  }

  UserController._();


  String userId='';

  firebase.User? firebaseUser;

  Future<String> getUserId(BuildContext context)async{
    if(userId!='') {
      return userId;
    }

    AuthProvider authModel = Provider.of(context, listen: false);
    UserAuthInfo? info = authModel.userAuthInfo;
    String? fireBaseUserId = await SharedPrefManager()
        .getString('${info?.fireBaseUserId}-uuid');

    userId=fireBaseUserId??'';

    return userId;
  }

}
