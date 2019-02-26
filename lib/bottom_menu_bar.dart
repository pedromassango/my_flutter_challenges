import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Bottom Menu Bar",
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        title: Text("Bottom Menu Bar"),
      ),
      bottomNavigationBar: BottomMenuBar(),
    );
  }
}

class BottomMenuBar extends StatefulWidget {
  @override
  _BottomMenuBarState createState() => _BottomMenuBarState();
}

class _BottomMenuBarState
    extends State<BottomMenuBar>
    with SingleTickerProviderStateMixin{

  bool animate = false;
  Animation<double> sizeAnim;
  AnimationController controller;
  final double defaultHeight = 56;

  static const double centerMargin = 40;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    sizeAnim = Tween<double>(begin: defaultHeight, end: 180)
    .animate(
        CurvedAnimation(parent: controller, curve: Curves.linear)
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: width,
          height: sizeAnim.value,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              SlidingContainer(controller: controller,
                centerMargin: centerMargin,
                color: Colors.blue,
              ),

              ClipPath(
                clipper: BottomClipper(38.0),
                child: Container(
                  height: defaultHeight,
                  color: Colors.grey[200],
                ),
              ),

              Container(
                height: defaultHeight,
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.home),
                    Spacer(),
                    Icon(Icons.credit_card),
                    Spacer(),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (controller.isCompleted) {
                          controller.reverse();
                        } else {
                          controller.forward();
                        }
                      },
                      child: Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(bottom: 40),
                          child: Icon(Icons.add, color: Colors.black, size: 32,)),
                    ),
                    Spacer(),
                    Spacer(),
                    Icon(Icons.insert_drive_file),
                    Spacer(),
                    Icon(Icons.person),
                  ],
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}


class SlidingContainer extends StatefulWidget {
  final Color color;
  final double centerMargin;
  final AnimationController controller;

  const SlidingContainer({Key key,this.color,this.centerMargin, this.controller})
      : super(key: key);

  @override
  _SlidingContainerState createState() => _SlidingContainerState();
}

class _SlidingContainerState
    extends State<SlidingContainer>
    with SingleTickerProviderStateMixin{

  double radialPercent = 30;
  Animation<Offset> radiusAnimation;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    radiusAnimation = Tween<Offset>(
        begin: Offset(0, 0),
        end: Offset(width/2.4, 90)
    ).animate(CurvedAnimation(parent: widget.controller, curve: Curves.linear)
    );

    return AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child){
          return ClipPath(
            clipper: MyClipper(radiusAnimation.value, widget.centerMargin),
            child: Container(
              color: widget.color,
            ),
          );
        },
    );
  }

}

class MyClipper extends CustomClipper<Path>{

  final double defaultMargin;
  final Offset radialPercent;
  MyClipper(this.radialPercent, this.defaultMargin);

  @override
  Path getClip(Size size) {
    final p = Path();
    final height = size.height;
    final width = size.width;

    var radius = (height / width) + radialPercent.dx *
        radialPercent.dy / 100;


    var bottomCenter = Offset(width / 2, height - defaultMargin);
    p.addOval(Rect.fromCircle(center: bottomCenter, radius: radius));

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}


class BottomClipper extends CustomClipper<Path>{
  final double radius;

  BottomClipper(this.radius);

  @override
  Path getClip(Size size) {
    final p = Path();

    p.lineTo(0.0, size.height);
    p.lineTo(size.width, size.height);
    p.lineTo(size.width, 0.0);
    p.addOval(Rect.fromCircle(center: Offset(size.width/2, 0.0), radius: radius));
    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}