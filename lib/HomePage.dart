import 'package:auto_size_text/auto_size_text.dart';
import 'package:cricket/model/player.dart';
import 'package:cricket/provider/playerProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginPages/signInPage.dart';

class HomePage extends StatefulWidget {
  static const routeName = "home_page";
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

String email;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Getting added Players in the database and update the list of players
    Provider.of<PlayerProvider>(context, listen: false).updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Players'),
        leading: InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('isLoggedIn', 'no');
            Navigator.pushReplacementNamed(
              context,
              SignInPage.routeName,
            );
          },
          child: Tooltip(
            message: 'Log out',
            child: Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: kToolbarHeight),
        child: Consumer<PlayerProvider>(
          builder: (BuildContext context, value, Widget child) {
            return value.playerList.length == 0
                ? Center(
                    child: Text(
                      'No Player added!',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                    itemCount: value.playerList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        color: Colors.white,
                        elevation: 6,
                        shadowColor: Colors.grey.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Center(
                              child: AutoSizeText(
                                value.playerList[index].id.toString(),
                                maxLines: 1,
                                maxFontSize: 15,
                                minFontSize: 9,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          title: Text(
                            value.playerList[index].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                value.playerList[index].role,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              RatingBar(
                                glow: false,
                                initialRating:
                                    value.playerList[index].rateValue,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                ignoreGestures: true,
                                itemSize: 15,
                                ratingWidget: RatingWidget(
                                  full: Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                  ),
                                  half: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Icon(
                                      Icons.star_half_rounded,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  empty: Icon(
                                    Icons.star_border_rounded,
                                    color: Colors.black54,
                                  ),
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              Provider.of<PlayerProvider>(context,
                                      listen: false)
                                  .delete(value.playerList[index]);
                              Fluttertoast.showToast(
                                msg: 'Deleted',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                          ),
                          onTap: () {
                            debugPrint("ListTile Tapped");
                            Provider.of<PlayerProvider>(context, listen: false)
                                .navigateToAddNewPlayer(
                                    context,
                                    Player.withId(
                                      value.playerList[index].id,
                                      value.playerList[index].name,
                                      value.playerList[index].rateValue,
                                      value.playerList[index].role,
                                    ),
                                    'Edit Player');
                          },
                        ),
                      );
                    },
                  );
          },
        ),
      ),
      bottomSheet: SizedBox(
        height: kToolbarHeight,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Navigator.pushNamed(context, AddPlayerPage.routeName);
            Provider.of<PlayerProvider>(context, listen: false)
                .navigateToAddNewPlayer(
                    context,
                    Player(
                      '',
                      1.0,
                      'BATSMAN',
                    ),
                    'Add new Player');
          },
          child: Text(
            'Add Player',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
