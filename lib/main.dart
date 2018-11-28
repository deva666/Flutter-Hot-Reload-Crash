
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hot_reload_crash/startup_view.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final themeData = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
    primaryColorDark: Colors.blue.shade700,
    primaryColorLight: Colors.blue.shade400,
    accentColor: Colors.deepPurpleAccent,
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarColor: themeData.canvasColor, systemNavigationBarColor: themeData.canvasColor));
    return new MaterialApp(
      home: StartupView(),
      title: 'Foodster',
      theme: themeData.copyWith(textTheme: themeData.textTheme.apply(fontFamily: 'Raleway') ),
    );
  }
}