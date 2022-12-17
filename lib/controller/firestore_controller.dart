import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:wit/model/UserAuthInfo.dart';
import 'package:wit/model/enums/auth_type.dart';

import 'auth_controller.dart';
import 'cache/shared_pref_manager.dart';

class FireStoreController {
  static final fireStoreInstance = FirebaseFirestore.instance;
  final String uuid = const Uuid().v4();

  static FireStoreController? _instance;

  factory FireStoreController() {
    _instance ??= FireStoreController._();
    return _instance!;
  }

  FireStoreController._();

  Future<void> createDocument() async {
    try {
      UserAuthInfo? userAuthInfo = await AuthController().getUserAuthInfo();
      int? loginType = await SharedPrefManager().getInt('login_type');
      AuthType type = loginType != null
          ? AuthType.values
              .firstWhere((element) => element.intValue == loginType)
          : AuthType.ANONYMOUS_LOGIN;

      Map<String, Map<String, String>> profile = {};

      if (userAuthInfo != null ) {
        profile = {
          type.providerValue: {
            'displayName': userAuthInfo.displayName ?? '',
            'email': userAuthInfo.email ?? '',
          }
        };
      }

      if (userAuthInfo == null) return;

      if (userAuthInfo.fireBaseUserId?.isNotEmpty ?? false) {
        DocumentSnapshot<Map<String, dynamic>> doc = await fireStoreInstance
            .collection('users')
            .doc(userAuthInfo.fireBaseUserId)
            .get();
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        if (!doc.exists) {
          print('object' + userAuthInfo.fireBaseUserId.toString());
          fireStoreInstance
              .collection('users')
              .doc(userAuthInfo.fireBaseUserId)
              .set(
            {
              'created_at': timestamp,
              'displayName': userAuthInfo.displayName,
              'email': userAuthInfo.email,
              'id': {'uuid': uuid},
              'profiles': [profile],
              'updated_at': timestamp
            },
            SetOptions(merge: true),
          );
        }
        else {
          List<dynamic>? profiles = doc.data()?['profiles'] ?? [];
          if (profiles == null) {
            profiles = [profile];
          } else {
            bool profileExists = false;
            for (var element in profiles) {
              if (element.containsKey(type.providerValue)) {
                profileExists = true;
              }
            }
            if (!profileExists) profiles.add(profile);
          }

          fireStoreInstance
              .collection('users')
              .doc(userAuthInfo.fireBaseUserId)
              .set(
            {
              'profile': profiles,
              'updated_at': timestamp
            },
            SetOptions(merge: true),
          );
        }
        String setUUID = await getUUID();
        SharedPrefManager()
            .setString('${userAuthInfo.fireBaseUserId}-uuid', setUUID);
      }
    } catch (error, stackTrack) {
      print(error.toString());
      // FirebaseCrashlytics.instance.recordError(error, stackTrack);
    }
  }

  Future<String> getUUID() async {
    try {
      UserAuthInfo? userAuthInfo = await AuthController().getUserAuthInfo();
      if (userAuthInfo == null) return uuid;
      DocumentSnapshot<Map<String, dynamic>> doc = await fireStoreInstance
          .collection('users')
          .doc(userAuthInfo.fireBaseUserId)
          .get();
      if (doc.data() != null) {
        return doc.data()!['id']['uuid'];
      } else {
        return uuid;
      }
    } catch (error, stackTrack) {
      return '';
    }
  }

}
