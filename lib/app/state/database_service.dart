import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as developer;

import '../../models/avatar_image.dart';

class DatabaseService {
  DatabaseService._internal();

  static final _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  late final Database? _database;

  late final String _databaseName = 'app_data.db',
      _table = 'avatars',
      _column1 = 'avatarKey',
      _column2 = 'bytes';

  Future<Database?> initDatabase() async {
    final devicesPath = await getDatabasesPath();
    final path = join(devicesPath, _databaseName);
    try {
      return await openDatabase(path, onCreate: (db, version) {
        db.execute(
            'CREATE TABLE $_table($_column1 TEXT PRIMARY KEY, $_column2 BLOB)');
      }, version: 1);
    } on DatabaseException catch (e) {
      developer.log('SQLite database failed to open table ${e.result}');
    }
    return null;
  }

  Future<int> insertAvatars({required List<SavedAvatar> avatars}) async {
    _database = await initDatabase();

    try {
      for (int i = 0; i < avatars.length; i++) {
        await _database?.insert(_table, avatars[i].toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    } on DatabaseException catch (e) {
      developer.log('Saving avatars to Sqlite database failed ${e.result}');
    }

    return avatars.length;
  }
}
