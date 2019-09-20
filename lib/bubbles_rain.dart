import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bubble Rain',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double maxScreenWith;
  double maxScreenHeight;

  @override
  Widget build(BuildContext context) {
    maxScreenWith = MediaQuery.of(context).size.width;
    maxScreenHeight = MediaQuery.of(context).size.height;
    final size = Size(maxScreenWith, maxScreenHeight);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: GameField(size),
      ),
    );
  }
}

class Circle extends StatelessWidget {
  final Color color;
  final double _size = 50;

  const Circle({Key key, this.color = Colors.green})
      : assert(color != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle
      ),
    );
  }
}
class CircleController {
}

class GameField extends StatefulWidget {
  final Size size;
  GameField(this.size);

  @override
  _GameFieldState createState() => _GameFieldState();
}

class _GameFieldState extends State<GameField> {

  Size get size => widget.size;

  Size _randomPosition(Size size) {
    final x = Random().nextInt(size.width~/2);
    final y = Random().nextInt(size.height~/2);
    return Size(x.toDouble(), y.toDouble());
  }

  addItem(){

  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[

        Center(child: Circle(color: Colors.orange,),)
      ],
    );
  }
}