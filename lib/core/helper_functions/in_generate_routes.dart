import 'package:barcode_scan/home_screen.dart';
import 'package:barcode_scan/login_screen.dart';
import 'package:flutter/material.dart';


Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {

    case HomeScreen.routeName:
    return MaterialPageRoute(builder: (context) => const HomeScreen());


    case LoginPage.routeName:
    return MaterialPageRoute(builder: (context) =>  LoginPage());


    default:
      return MaterialPageRoute(builder: (context) => const Scaffold());
  }
}
