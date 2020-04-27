import 'package:cs4261a1/locator.dart';
import 'package:flutter/material.dart';
import 'package:cs4261a1/services/authentication.dart';
import 'package:cs4261a1/pages/root_page.dart';

void main() {
  setupLocator();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // login page parameters:
  // primary swatch color
  static const primarySwatch = Colors.green;
  // button color
  static const buttonColor = Colors.green;
  // app name
  static const appName = 'Tech Connect';
  // boolean for showing home page if user unverified
  static const homePageUnverified = false;

  final params = {
    'appName': appName,
    'primarySwatch': primarySwatch,
    'buttonColor': buttonColor,
    'homePageUnverified': homePageUnverified,
  };


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Tech Connect',
        debugShowCheckedModeBanner: true,
        theme: new ThemeData(
          primarySwatch: params['primarySwatch'],
        ),
        home: new RootPage(params: params, auth: new Auth()));
  }
}