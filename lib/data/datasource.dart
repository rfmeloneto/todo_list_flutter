import 'dart:async';
import 'package:fazer/domain/atividade_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String tableName = 'activities';

  DatabaseHelper._privateConstructor();

  static DatabaseHelper get instance {
    _databaseHelper ??= DatabaseHelper._privateConstructor();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = await getDatabasesPath();
    String dbName = 'activities_database.db';
    String completePath = join(path, dbName);

    return await openDatabase(
      completePath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, activity TEXT)',
    );
  }

  // Inserir dados
  insert(String atividades) async {
    Database db = await instance.database;
    var result = await db.insert(tableName, {'activity': atividades});
    return result;
  }

  // Selecionar todos os dados
  Future<List<AtividadeEntity>> getAll() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> list = await db.query(tableName);
    List<AtividadeEntity> atividades = List.generate(list.length, (index) {
      return AtividadeEntity(
        id: list[index]['id'],
        activity: list[index]['activity'],
      );
    });
    return atividades;
  }

  // // Selecionar dados por ID
  // Future<AtividadeEntity> getById(int id) async {
  //   Database db = await instance.database;
  //   List<Map<String, dynamic>> list = await db.query(
  //     tableName,
  //     where: 'id = ?',
  //     whereArgs: [id],
  //   );
  //   if (list.isNotEmpty) {
  //     return AtividadeEntity(
  //       id: list[0]['id'],
  //       title: list[0]['title'],
  //     );
  //   } else {
  //     throw Exception('Atividade não encontrada');
  //   }
  // }

  // Atualizar dados
  // update(AtividadeEntity atividade) async {
  //   Database db = await instance.database;
  //   var result = await db.update(
  //     tableName,
  //     atividade.toMap(),
  //     where: 'id = ?',
  //     whereArgs: [atividade.id],
  //   );
  //   return result;
  // }

  // Deletar dados
  delete(int id) async {
    Database db = await instance.database;
    int result = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }
}
