import 'package:cricket/addPlayerPage.dart';
import 'package:cricket/db/player_database.dart';
import 'package:cricket/model/player.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class PlayerProvider extends ChangeNotifier {
  PlayerHelper playerDatabaseHelper = PlayerHelper();

  List<Player> playerList = [];

  //Getting the data from database as Map List, converted to Player List and Update the list
  updateListView() {
    final Future<Database> dbFuture = playerDatabaseHelper.initializeDatabase();
    return dbFuture.then((database) async {
      List<Player> playerListFuture =
          await playerDatabaseHelper.getPlayerList();
      playerList = playerListFuture;
      notifyListeners();
    });
  }

  //It will delete a player by getting it's id
  void delete(Player player) async {
    await playerDatabaseHelper.deletePlayer(player.id);
    for (int i = 0; i < playerList.length; i++) {
      if (player.id == playerList[i].id) {
        playerList.removeAt(i);
      }
    }
    notifyListeners();
  }

  /* Navigating to AddPlayerPage depending on from where it will tap,
    if user clicks on the list it will go to AddPlayerPage by the title of Edit Player and its related Data showing in the related field
     if user clicks on the Add Player button, it will go to AddPlayerPage and ready for adding new Player
     */
  void navigateToAddNewPlayer(
      BuildContext context, Player player, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return AddPlayerPage(
          player: player,
          appBarTitle: title,
        );
      }),
    );
  }

  //It will Update the Player name while editing a player
  void updatePlayerName(String playerName, String newPlayerName) {
    playerName = newPlayerName;
  }

  /* It is used to save a new player or an existing player
    if the user is exist it will update the user then save it
    if the user is not exist it will create and save new user
  */
  savePlayer(int id, Player player) async {
    int result;
    if (id != null) {
      result = await playerDatabaseHelper.updatePlayer(player);
      for (int i = 0; i < playerList.length; i++) {
        if (id == playerList[i].id) {
          playerList[i] = player;
        }
      }
    } else {
      result = await playerDatabaseHelper.insertPlayer(player);
      playerList.add(player);
    }
    notifyListeners();
    return result;
  }
}
