import 'package:flutter/material.dart';
import 'package:flutter_hot_reload_crash/db_loader_view.dart';
import 'package:flutter_hot_reload_crash/home_view.dart';

class StartupView extends StatefulWidget {
  @override
  _StartupViewState createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  @override
  void initState() {
    super.initState();
    final v = true;
    if (v) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => HomeView()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => DbLoaderView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
