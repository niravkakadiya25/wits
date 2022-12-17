enum AuthType {
  ANONYMOUS_LOGIN,
  Email_LOGIN,
}

extension AuthTypeExtension on AuthType {
  int get intValue {
    switch (this) {
      case AuthType.ANONYMOUS_LOGIN:
        return 0;
      case AuthType.Email_LOGIN:
        return 1;
      default:
        return -1;
    }
  }

  String get stringValue {
    switch (this) {
      case AuthType.ANONYMOUS_LOGIN:
        return 'anonymous';
      case AuthType.Email_LOGIN:
        return 'email';
      default:
        return 'null';
    }
  }

  String get providerValue {
    switch (this) {
      case AuthType.ANONYMOUS_LOGIN:
        return 'anonymous';
      case AuthType.Email_LOGIN:
        return 'email';
      default:
        return 'undefined';
    }
  }
}
