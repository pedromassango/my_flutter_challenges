import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MainAppWidget());
}

class MainAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main App Widget',
      theme: ThemeData(primarySwatch: Colors.red),
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyState();
  }
}
// Love song (Adele)

class MyState extends State<SplashPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> angle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Hello There",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (c, index) {
          return _buildItem(index);
        },
      ),
    );
  }
}

Widget _buildItem(int index) {
  List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.deepPurple
  ];

  return Transform(
    transform: Matrix4.identity()
      ..setEntry(3, 2, 0.01)
      ..rotateX(0.2),
    alignment: FractionalOffset.center,
    child: Container(
      margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
      padding: EdgeInsets.fromLTRB(16, 32, 16, 8),
      decoration: BoxDecoration(
          color: _colors.elementAt(index),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      height: 150,
      width: 100,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Icons.place, color: Colors.white,),
              ),
              Text('Time Square', style: TextStyle(color: Colors.white),),
              Spacer(),
              Text('${index}0%', style: TextStyle(color: Colors.white),)
            ],
          )
        ],
      ),
    ),
  );
}
