import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(LiquidApp());

class LiquidApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Swipe',
      theme: ThemeData(primarySwatch: Colors.red),
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

  Widget _buildChild(){
    return Text('Liquid Swipe',
      style: TextStyle(
          fontSize: 36,
        color: Colors.white
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
          CustomContainer(
              MediaQuery.of(context).size,
              Container(
                color: Colors.purple,
                child: Center(child: _buildChild(),),
              )
          ),
          //CustomContainer( Colors.orange),
        ],
      ),
    );
  }
}

class CustomContainer extends StatefulWidget {
  final Size mSize;
  final Widget child;

  CustomContainer(this.mSize, this.child);

  @override
  State<StatefulWidget> createState() {
    return CustomContainerState();
  }
}

class CustomContainerState
    extends State<CustomContainer>
    with SingleTickerProviderStateMixin {

  Animation<double> animation;
  AnimationController controller;
  double sliderPercent = 30;
  double startDragPercent;
  double startDragX;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 700)
    );

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    animation = Tween<double>(
        begin: sliderPercent,
        end: width
    ).animate(
        CurvedAnimation(parent: controller, curve: Curves.linear)
    );

    return GestureDetector(
      onHorizontalDragStart: _horizontalDragStart,
      onHorizontalDragUpdate: _horizontalDragUpdate,
      onHorizontalDragEnd: _horizontalDragEnd,
      child: AnimatedBuilder(
        animation: controller,
        builder: (con, c) {
          return ClipPath(
            clipper: MyClipper(animation.value),
            child: widget.child,
          );
        },
      ),
    );
  }

  void _horizontalDragStart(DragStartDetails details) {
    startDragX = details.globalPosition.dx;
    startDragPercent = sliderPercent;
  }

  void _horizontalDragUpdate(DragUpdateDetails details) {
    final distance = startDragX - details.globalPosition.dx;
    final sliderWidth = widget.mSize.width;
    final mDragPercent = distance / sliderWidth;

    setState(() {
      sliderPercent = startDragPercent + mDragPercent *
          details.globalPosition.distance/1.5;
    });
  }

  void _horizontalDragEnd(DragEndDetails details) {
      startDragX = null;
      startDragPercent = null;

        setState(() {
          //controller.forward();
        });

  }
}

class MyClipper extends CustomClipper<Path> {
  final double sliderPercent;

  MyClipper(this.sliderPercent);

  @override
  Path getClip(Size size) {
    var path = Path();

    // colored background
    path.addRect(
        Rect.fromLTRB(
          size.width - sliderPercent,
          0, 
          size.width,
          size.height
        ),
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
