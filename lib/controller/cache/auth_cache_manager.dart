

// class AuthCacheManager extends BaseCacheManager {
//   static const key = "customCache";
//
//   static AuthCacheManager _instance;
//
//   factory AuthCacheManager() {
//     if (_instance == null) {
//       _instance = new AuthCacheManager._();
//     }
//     return _instance;
//   }
//
//   AuthCacheManager._() : super(key,
//       maxAgeCacheObject: Duration(days: 7),
//       maxNrOfCacheObjects: 20);
//
//   Future<String> getFilePath() async {
//     var directory = await getTemporaryDirectory();
//     return path.join(directory.path, key);
//   }
//
//   Future<String> getLocalCachePath() async {
//     final _appDocDir = await getApplicationDocumentsDirectory();
//     final folderName = describeEnum(CacheType.USER_AUTH_INFO);
//     final Directory _appDocDirFolder = Directory(path.join(_appDocDir.path, folderName));
//     if(await _appDocDirFolder.exists()){
//       return _appDocDirFolder.path;
//     } else {
//       final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
//       return _appDocDirNewFolder.path;
//     }
//   }
//
//   Future<File> getUserAuthInfoCacheFile() async {
//     final localCachePath = await getLocalCachePath();
//     final fileName = path.setExtension(describeEnum(CacheType.USER_AUTH_INFO),'.json');
//     return File(path.join(localCachePath, fileName));
//   }
//
//   Future<File> putUserInfo(UserAuthInfo userAuthInfo) async {
//     final file = await getUserAuthInfoCacheFile();
//     String encodedUserAuthInfo = jsonEncode(userAuthInfo.toJson());
//     // Write the file.
//     return file.writeAsString(encodedUserAuthInfo);
//   }
//
//
//   Future<UserAuthInfo> getUserAuthInfo() async {
//     try {
//       final file = await getUserAuthInfoCacheFile();
//       UserAuthInfo userAuthInfo;
//       if(file.existsSync()) {
//         // Read the file.
//         String userAuthInfoJson = await file.readAsString();
//         Map<String, dynamic> userAuthInfoMap = jsonDecode(userAuthInfoJson);
//         userAuthInfo = UserAuthInfo.fromJson(userAuthInfoMap);
//       }
//       return userAuthInfo;
//     } catch (e) {
//       // If encountering an error, return 0.
//       await deleteUserAuthInfo();
//       return null;
//     }
//   }
//
//   Future<int> deleteUserAuthInfo() async{
//     try {
//       final file = await getUserAuthInfoCacheFile();
//       if(file.existsSync()) {
//         await file.delete();
//       }
//       return 1;
//     } catch (e) {
//       return 0;
//     }
//   }
//
//
// }