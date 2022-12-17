
import 'package:flutter/foundation.dart';
import 'package:wit/model/UserAuthInfo.dart';

class AuthProvider extends ChangeNotifier {
  UserAuthInfo? _userAuthInfo;

  UserAuthInfo? get userAuthInfo => _userAuthInfo;

  set userAuthInfo(UserAuthInfo? userAuthInfo) {
    _userAuthInfo = userAuthInfo;
    notifyListeners();
  }
}
