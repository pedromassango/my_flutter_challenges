import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(LiquidApp());

class LiquidApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Swipe',
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {


  Widget _buildHeaderWidgets() {
    return Container(
      margin: EdgeInsets.only(top: 42),
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("GameCoin"),
          Text('SKIP')
        ],
      ),
    );
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomContainer(),

          _buildHeaderWidgets(),

        ],
      ),
    );
  }

}

class CustomContainer extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return CustomContainerState();
  }
}

class CustomContainerState extends State<CustomContainer>{

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.red,
        ),
      ),
    );
  }

}

class MyClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    var path = Path();

    // colored background
//    path.addRect(
//        Rect.fromLTRB(0, size.height, size.width-4, 0)
//    );
    
    // swipe button area button
//
//    path.addRRect(
//        RRect.fromLTRBAndCorners(size.width, size.height-200, size.width-50, size.height-270,
//          topLeft: Radius.circular(50),
//          bottomLeft: Radius.circular(50)
//    )
//    );

    //path.quadraticBezierTo(0, size.height-200, size.height-200, size.height-200);
/*
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height-200),
        radius: 40
    )
    );*/

    path.lineTo(size.width, size.height);
    path.lineTo(size.height, size.width);


    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}