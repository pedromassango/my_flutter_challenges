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


  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SlidingContainer(color: Colors.black, child: Container(),)
        ],
      )
    );
  }
}

class SlidingContainer extends StatefulWidget {
  final Widget child;
  final Color color;

  const SlidingContainer({Key key,this.color, this.child}) : super(key: key);

  @override
  _SlidingContainerState createState() => _SlidingContainerState();
}

class _SlidingContainerState
    extends State<SlidingContainer>
    with SingleTickerProviderStateMixin{

  double radialPercent = 20;
  Animation<Offset> radiusAnimation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

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

    return GestureDetector(
      onTap: (){
        setState(() {
          controller.forward();
        });
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child){
          return ClipPath(
            clipper: MyClipper(radiusAnimation.value, Position.TOP_CENTER),
            child: Container(
              child: widget.child,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }

}

enum Position{
  TOP_CENTER, BOTTOM_CENTER
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
    }else{
      var topCenter = Offset(size.width /2, 0);
      p.addOval(Rect.fromCircle(center: topCenter, radius: radius));
    }

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

