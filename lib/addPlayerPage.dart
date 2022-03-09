import 'package:cricket/Widget/customTextFormField.dart';
import 'package:cricket/model/player.dart';
import 'package:cricket/provider/playerProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

import 'HomePage.dart';

class AddPlayerPage extends StatefulWidget {
  static const routeName = "add_player_page";

  final String appBarTitle;
  final Player player;
  AddPlayerPage({
    this.player,
    this.appBarTitle,
  });

  @override
  _AddPlayerPageState createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController playerNameController = TextEditingController();
  String _chosenValue;
  double _ratingValue;

  String playerName;
  @override
  void initState() {
    super.initState();
    //getting the data from HomePage
    playerName = widget.player.name;
    playerNameController.text = widget.player.name;
    _ratingValue = widget.player.rateValue;
    _chosenValue = widget.player.role ?? 'BATSMAN';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.appBarTitle}'),
          leading: InkWell(
            onTap: () async {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    controller: playerNameController,
                    label: 'Player name',
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: RequiredValidator(
                        errorText: "* Player nam is required"),
                    onChanged: (value) {
                      Provider.of<PlayerProvider>(context, listen: false)
                          .updatePlayerName(playerName, widget.player.role);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Player rating ',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: RatingBar(
                      glow: false,
                      initialRating: _ratingValue,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      minRating: 1,
                      ratingWidget: RatingWidget(
                        empty: Icon(
                          Icons.star_border_rounded,
                          color: Colors.black54,
                        ),
                        half: Icon(
                          Icons.star_half,
                          color: Colors.amber,
                        ),
                        full: Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                      itemPadding: EdgeInsets.symmetric(horizontal: 12.0),
                      itemSize: 50,
                      onRatingUpdate: (rating) {
                        _ratingValue = rating;
                        print(_ratingValue);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Player Role",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black38,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton<String>(
                      value: _chosenValue,
                      onTap: () => FocusManager.instance.primaryFocus.unfocus(),
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                      underline: Container(),
                      isExpanded: true,
                      items: <String>[
                        'BATSMAN',
                        'WICKETKEEPER',
                        'ALLROUNDER',
                        'BOWLER',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        FocusManager.instance.primaryFocus.unfocus();
                        setState(() {
                          _chosenValue = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Player player;
                        player = widget.player;
                        player.name = playerNameController.text;
                        player.role = _chosenValue;
                        player.rateValue = _ratingValue;
                        FocusManager.instance.primaryFocus.unfocus();
                        if (_formKey.currentState.validate()) {
                          print("Validated");
                          Provider.of<PlayerProvider>(context, listen: false)
                              .savePlayer(player.id, player)
                              .then((value) {
                            if (value != 0) {
                              Fluttertoast.showToast(
                                msg: 'Saved Player Successfully!',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Problem saving Player',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          });
                        } else {
                          print("Not Validated");
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
