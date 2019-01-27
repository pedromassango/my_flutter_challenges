import 'package:flutter/material.dart';

void main() {
  runApp( MainAppWidget());
}

class MainAppWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Main App Widget',
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text('Main',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 32
            ),
          ),
        ),
      ),
    );
  }
}