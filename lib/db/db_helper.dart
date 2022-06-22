import 'package:geprec_app/db/draft_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:path/path.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();

  static Database? _database;

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('geprec.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $draftTable (
  ${DraftFields.id} $idType,
  ${DraftFields.idPengguna} $textType,
  ${DraftFields.idKunjungan} $textType,
  ${DraftFields.fotoMeteran} $textType,
  ${DraftFields.fotoSelfie} $textType,
  ${DraftFields.pembacaanMeter} $textType,
  ${DraftFields.idGasPelanggan} $textType,
  ${DraftFields.latitudeD} $textType,
  ${DraftFields.longitudeD} $textType,
  ${DraftFields.tglKunjunganD} $textType
  )
  ''');
  }

  Future close() async {
    final db = await instance.database;
    _database = null;

    db.close();
  }

  Future<int> create(DraftModel draft) async {
    final db = await instance.database;

    final id = await db.insert(draftTable, draft.toJson());

    return id;
  }

  Future<int> update(DraftModel draft) async {
    final db = await instance.database;

    return db.update(
      draftTable,
      draft.toJson(),
      where: '${DraftFields.id} = ?',
      whereArgs: [draft.id],
    );
  }

  Future<DraftModel> readDraft(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      draftTable,
      columns: DraftFields.values,
      where: '${DraftFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return DraftModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<DraftModel>> readAllDrafts() async {
    final db = await instance.database;

    final result = await db.query(draftTable);

    return result.map((e) => DraftModel.fromJson(e)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db
        .delete(draftTable, where: '${DraftFields.id} = ?', whereArgs: [id]);
  }
}
