import 'dart:io';

import 'package:cricket/model/player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

//Initializing the the table name and its columns
final String playerTable = 'player';
final String colId = 'id';
final String colName = 'name';
final String colRate = 'rate';
final String colRole = 'role';

//Creating the SQLite database and operate its functionalities
class PlayerHelper {
  static Database _database;
  static PlayerHelper _playerHelper;
  PlayerHelper._createInstance();
  factory PlayerHelper() {
    if (_playerHelper == null) {
      _playerHelper = PlayerHelper._createInstance();
    }
    return _playerHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  //Creating and initializing the SQLite database with the table and its related columns
  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'player.db';
    var database =
        await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
      create table $playerTable(
      $colId integer primary key autoincrement,
      $colName text not null,
      $colRate double not null,
      $colRole text not null)
      ''');
    });
    return database;
  }

  //Fetch PlayerMap List from the database
  Future<List<Map<String, dynamic>>> getPlayerMapList() async {
    Database db = await this.database;
    var result = await db.query(playerTable, orderBy: '$colId DESC');
    return result;
  }

  //Insert a new player to the database
  Future<int> insertPlayer(Player player) async {
    Database db = await this.database;
    var result = db.insert(playerTable, player.toMap());
    print('result: $result');
    return result;
  }

  //Update an existing player from the database
  Future<int> updatePlayer(Player player) async {
    var db = await this.database;
    var result = await db.update(playerTable, player.toMap(),
        where: '$colId = ?', whereArgs: [player.id]);
    return result;
  }

  //Delete a player from the database
  Future<int> deletePlayer(int id) async {
    Database db = await this.database;
    int result =
        await db.rawDelete('delete from $playerTable where $colId = $id');
    return result;
  }

  //Get the 'Map List' [ List<Map> ] and convert it to 'Player List'[ List<Player> ]
  Future<List<Player>> getPlayerList() async {
    var playerMapList = await getPlayerMapList();
    int count = playerMapList.length;
    List<Player> playerList = [];
    //for loop to create a ' Player List '  from ' Map List '
    for (int i = 0; i < count; i++) {
      playerList.add(Player.fromMapObject(playerMapList[i]));
    }
    return playerList;
  }
}
