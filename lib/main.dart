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
          child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: ClipPath(
                    clipper: MyClipper(align: Alignment.bottomLeft),
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ClipPath(
                    clipper: MyClipper(align: Alignment.bottomRight),
                    child: Container(
                      color: Colors.deepPurple,
                    ),
                  ),
                )
              ],
          ),
        ),
      ),
    );
  }
}
// Love song (Adele)

class MyClipper extends CustomClipper<Path>{

   Alignment align;

  MyClipper({this.align});


  @override
  Path getClip(Size size) {
    var p = Path();



    Rect rect;
    if(align == Alignment.bottomLeft){
      rect = Rect.fromLTWH(-40, size.height-55, 100, 100);
    }else{
      rect = Rect.fromLTWH(size.width-40, size.height-60, 100, 100);
    }

    p.addOval(rect);


    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
