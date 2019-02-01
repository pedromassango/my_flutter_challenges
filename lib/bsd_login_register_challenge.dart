import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BSD Login & Register",
      theme: ThemeData(primarySwatch: Colors.green),
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

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Animation<double> slideUpAnimation;
  AnimationController slideUpAnimationController;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();

    slideUpAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
  }

  @override
  Widget build(BuildContext context) {
    slideUpAnimation =
        Tween<double>(begin: MediaQuery.of(context).size.height / 1.2, end: 200)
            .animate(CurvedAnimation(
                parent: slideUpAnimationController, curve: Curves.linear));

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: slideUpAnimationController,
            builder: (context, child) {
              return Positioned(
                top: slideUpAnimation.value,
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(100))),
                  child: Center(
                      child: Visibility(
                    visible: !slideUpAnimationController.isAnimating &&
                        !slideUpAnimationController.isCompleted,
                    child: GestureDetector(
                      onTap: _onTap,
                      onPanStart: null,
                      child: Icon(
                        Icons.arrow_upward,
                        size: 50,
                      ),
                    ),
                    replacement: Center(
                      child: Text('Hello World!'),
                    ),
                  )),
                ),
              );
            },
          )
        ],
      ),
    );
  }
/*
  void _onPanStart(DragStartDetails details) {
    startDragY = details.globalPosition.dy;
    startDragPercent = widget.sliderController.sliderValue;

    final sliderWidth = context.size.width;
    final sliderLeftPosition =
        (context.findRenderObject() as RenderBox).localToGlobal(const Offset(0.0, 0.0)).dx;
    final dragHorizontalPercent = (details.globalPosition.dx - sliderLeftPosition) / sliderWidth;

    widget.sliderController.onDragStart(dragHorizontalPercent);
  }*/

  void _onTap() {
    setState(() {
      slideUpAnimationController.forward();
    });
  }
}
/*

class _SliderDraggerState extends State<Item> {
  double startDragY;
  double startDragPercent;

  void _onPanStart(DragStartDetails details) {
    startDragY = details.globalPosition.dy;
    startDragPercent = widget.sliderController.sliderValue;

    final sliderWidth = context.size.width;
    final sliderLeftPosition =
        (context.findRenderObject() as RenderBox).localToGlobal(const Offset(0.0, 0.0)).dx;
    final dragHorizontalPercent = (details.globalPosition.dx - sliderLeftPosition) / sliderWidth;

    widget.sliderController.onDragStart(dragHorizontalPercent);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final dragDistance = startDragY - details.globalPosition.dy;
    final sliderHeight = context.size.height - widget.paddingTop - widget.paddingBottom;
    final dragPercent = dragDistance / sliderHeight;

    final sliderWidth = context.size.width;
    final sliderLeftPosition =
        (context.findRenderObject() as RenderBox).localToGlobal(const Offset(0.0, 0.0)).dx;
    final dragHorizontalPercent = (details.globalPosition.dx - sliderLeftPosition) / sliderWidth;

    widget.sliderController.draggingPercents = new Offset(
      dragHorizontalPercent,
      startDragPercent + dragPercent,
    );
  }

  void _onPanEnd(DragEndDetails details) {
    startDragY = null;
    startDragPercent = null;

    widget.sliderController.onDragEnd();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: widget.child,
    );
  }
}
*/
