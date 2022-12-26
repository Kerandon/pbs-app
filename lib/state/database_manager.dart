import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as developer;

import '../models/avatar_image.dart';

class DatabaseManager {
  DatabaseManager._internal();

  static final _instance = DatabaseManager._internal();

  factory DatabaseManager() => _instance;

  late Database? _database;

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
      developer.log(
          'Failed saving avatar image data to Sqlite database ${e.result}');
    }

    return avatars.length;
  }

  Future<List<SavedAvatar>> getAllAvatars() async {
    List<SavedAvatar> savedAvatar = [];
    _database = await initDatabase();
    final maps = await _database!.rawQuery('SELECT * FROM $_table');
    savedAvatar = List.generate(
        maps.length, (index) => SavedAvatar.fromMap(map: maps[index])).toList();
    return savedAvatar;
  }

  Future<int> deleteAvatar({required String avatarKey}) async {
    _database = await initDatabase();
    return await _database!
        .delete(_table, where: '$_column1=?', whereArgs: [avatarKey]);
  }
}
