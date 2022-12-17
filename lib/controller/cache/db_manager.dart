import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DBManager {
  final String dbName = 'wit.db';
  final int _version = 1;
  static final authStore = intMapStoreFactory.store('auth');
  static final recipeStore = intMapStoreFactory.store('recipes');


  static final DBManager _instance = DBManager._();

  // Singleton accessor
  static DBManager get instance => _instance;

  // Completer is used for transforming synchronous code into asynchronous code.
  Completer<Database>? _dbOpenCompleter;

  DBManager._();

  // Database object accessor
  Future<Database> get database async {
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      _openDatabase();
    }
    return _dbOpenCompleter!.future;
  }

  Future _openDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, dbName);

    final database = await databaseFactoryIo
        .openDatabase(dbPath, version: _version,
            onVersionChanged: (Database db, oldVersion, newVersion) async {
      if (kDebugMode) {
        print('old version: $oldVersion || new version: $newVersion');
      }
      if (oldVersion != newVersion) {
        await recipeStore.delete(db);
      }
    });
    // Any code awaiting the Completer's future will now start executing
    _dbOpenCompleter?.complete(database);
  }
}
