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
          CustomContainer( Colors.purple),
          //CustomContainer( Colors.orange),

        ],
      ),
    );
  }

}

class CustomContainer extends StatefulWidget{

final Color color;

CustomContainer(this.color);

  @override
  State<StatefulWidget> createState() {
    return CustomContainerState();
  }
}

class CustomContainerState extends State<CustomContainer>{

double dragPercent = 30;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(dragPercent),
      child: GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: widget.color,
        ),
      ),
    );
  }

}

class MyClipper extends CustomClipper<Path> {

  final double dragPercent;

  MyClipper(this.dragPercent);

  @override
  Path getClip(Size size) {
    var path = Path();

    // colored background
    path.addRect(
        Rect.fromLTRB(size.width-dragPercent, size.height, size.width, 0)
    );
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}