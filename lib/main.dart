import 'dart:ui';

import 'package:cricket/LoginPages/signInPage.dart';
import 'package:cricket/HomePage.dart';
import 'package:cricket/addPlayerPage.dart';
import 'package:cricket/provider/playerProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginPages/signUpPage.dart';

String email;
String isLoggedIn;
void main() async {
  //We have to write this code because the main method is async
  WidgetsFlutterBinding.ensureInitialized();
  //Make The status bar transparent for whole the app
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  //Getting data from SharedPreferences to use them for whether stay in HomePage or go to LoginPage
  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString('email');
  isLoggedIn = prefs.getString('isLoggedIn');

  //Start the App
  runApp(
    //Notifying whole the app from our Provider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Stop rotating the app
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Cricket',
      debugShowCheckedModeBanner: false,
      //Changing some Global styles of the app
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          centerTitle: true,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      //If email is not null and isLoggedIn value is yes, then it will Stay in homePage or else it will go to LoginPage
      initialRoute: (email != null && isLoggedIn == 'yes')
          ? HomePage.routeName
          : SignInPage.routeName,

      //Defining the roots of the app
      routes: {
        SignInPage.routeName: (context) => SignInPage(),
        SignUpPage.routeName: (context) => SignUpPage(),
        HomePage.routeName: (context) => HomePage(),
        AddPlayerPage.routeName: (context) => AddPlayerPage(),
      },
    );
  }
}
