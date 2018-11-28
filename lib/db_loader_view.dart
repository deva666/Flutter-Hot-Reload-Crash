
import 'package:flutter/material.dart';
import 'package:flutter_hot_reload_crash/home_view.dart';

class DbLoaderView extends StatefulWidget {
  @override
  createState() => DbLoaderViewState();
}

class DbLoaderViewState extends State<DbLoaderView> {


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500)).then(
            (v) => Navigator.pushReplacement(context, new MaterialPageRoute(builder: (c) => HomeView())),
        onError: (e) {

        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "Loading database data ...",
              style: new TextStyle(fontSize: 25.0),
            ),
            new Padding(padding: new EdgeInsets.all(10.0)),
            new CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
