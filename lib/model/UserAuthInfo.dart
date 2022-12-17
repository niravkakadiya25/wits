class UserAuthInfo {
  String? userId;
  String? fireBaseUserId;
  String? firebaseToken;
  String? email;
  String? displayName;

  UserAuthInfo.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        fireBaseUserId = json['fireBaseUserId'],
        email = json['email'],
        displayName = json['displayName'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'fireBaseUserId': fireBaseUserId,
        'email': email,
        'displayName': displayName,
      };
}
