import 'package:flutter/material.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Create',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<SlidingContainer> pages =[
    SlidingContainer(color: Colors.black, child: Container(), show: true,),
    SlidingContainer(color: Colors.deepOrange, child: Container(),),
    SlidingContainer(color: Colors.blue, child: Container(),),
    SlidingContainer(color: Colors.deepPurple, child: Container(),),
  ];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: pages.map((page){
          return SlidingContainer(
            color: page.color,
            child: page.child,
            pages: pages,
          );
        }).toList(),
      )
    );
  }
}

class SlidingContainer extends StatefulWidget {
  final Widget child;
  final Color color;
  final bool show;
  final List<SlidingContainer> pages;

  SlidingContainer({
    Key key,
    this.color,
    this.child,
    this.pages,
    this.show
  }) : super(key: key);

  @override
  _SlidingContainerState createState() => _SlidingContainerState(
    show: show
  );
}

class _SlidingContainerState
    extends State<SlidingContainer>
    with SingleTickerProviderStateMixin{

  double radialPercent = 20;
  Animation<Offset> radiusAnimation;
  AnimationController controller;
  bool _show;
  final bool show;

  _SlidingContainerState({this.show});

  @override
  void initState() {
    super.initState();
    if(show == true){
      _show = true;
    }else{
      _show = false;
    }

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2)
    );

  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    radiusAnimation = Tween<Offset>(
        begin: Offset(80, 80),
        end: Offset(width, height)
    ).animate(CurvedAnimation(parent: controller, curve: Curves.linear)
    );

    return Visibility(
      visible: true,
      child: GestureDetector(
        onTap: (){
          setState(() {
            controller.forward();
          });
        },
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child){
            return ClipPath(
              clipper: MyClipper(radiusAnimation.value, Position.BOTTOM_RIGHT),
              child: Container(
                child: widget.child,
                color: widget.color,
              ),
            );
          },
        ),
      ),
    );
  }

}

enum Position{
  TOP_CENTER, BOTTOM_CENTER, BOTTOM_RIGHT
}

class MyClipper extends CustomClipper<Path>{

  final double defaultMargin = 0;
  final Offset radialPercent;
  final Position position;
  MyClipper(this.radialPercent, this.position);

  @override
  Path getClip(Size size) {
    final p = Path();

    var radius = (size.height / size.width) + radialPercent.dx *
        radialPercent.dy / 100;


    if(position == Position.BOTTOM_CENTER) {
      var bottomCenter = Offset(size.width /2, size.height - defaultMargin);
      p.addOval(Rect.fromCircle(center: bottomCenter, radius: radius));
    }else if(position == Position.TOP_CENTER){
      var topCenter = Offset(size.width /2, 0);
      p.addOval(Rect.fromCircle(center: topCenter, radius: radius));
    }else if(position == Position.BOTTOM_RIGHT){
      var bottomRight = Offset(size.width, size.height);
      p.addOval(Rect.fromCircle(center: bottomRight, radius: radius));
    }

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

