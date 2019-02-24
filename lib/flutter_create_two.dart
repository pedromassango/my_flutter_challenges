import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

void main()=> runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My App",
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
      appBar: AppBar(
        title: Text("Foldable Options"),
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: FoldableOptions(),
          ),


        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        onItemSelected: (i){},
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.apps),
              title: Text('Home'),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.people),
                title: Text('Users'),
                activeColor: Colors.green
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.message),
                title: Text('Messages'),
                activeColor: Colors.deepPurple
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.settings),
                title: Text('Settings'),
                activeColor: Colors.blue
            ),
          ]
      ),
    );
  }
}




class FoldableOptions extends StatefulWidget {
  @override
  _FoldableOptionsState createState() => _FoldableOptionsState();
}

class _FoldableOptionsState
    extends State<FoldableOptions>
    with SingleTickerProviderStateMixin{

  final List<IconData> options =[
    Icons.folder,
    Icons.share,
    Icons.visibility_off,
    Icons.star_border,
    Icons.notifications_none
  ];

  Animation<Alignment> firstAnim;
  Animation<Alignment> secondAnim;
  Animation<Alignment> thirthAnim;
  Animation<Alignment> fourthAnim;
  Animation<Alignment> fivethAnim;
  Animation<double> verticalPadding;
  AnimationController controller;
  final duration = Duration(milliseconds: 270);


  Widget getItem(IconData source){
    final size = 40.0;
    return GestureDetector(
      onTap: (){
        controller.reverse();
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Color(0XFF212121),
          borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        child: Icon(source, color: Colors.white, size: 18,),
      ),
    );
  }

  Widget buildPrimaryItem(IconData source){
    final size = 40.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black87,
            blurRadius: verticalPadding.value
          )
        ]
      ),
      child: Icon(source, color: Colors.white, size: 20 ,),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);

    final anim = CurvedAnimation(parent: controller, curve: Curves.linear);
    firstAnim = Tween<Alignment>(begin: Alignment.centerRight, end: Alignment.topRight).animate( anim);
    secondAnim = Tween<Alignment>(begin: Alignment.centerRight, end: Alignment.topLeft).animate( anim);
    thirthAnim = Tween<Alignment>(begin: Alignment.centerRight, end: Alignment.centerLeft).animate( anim);
    fourthAnim = Tween<Alignment>(begin: Alignment.centerRight, end: Alignment.bottomLeft).animate( anim);
    fivethAnim = Tween<Alignment>(begin: Alignment.centerRight, end: Alignment.bottomRight).animate( anim);
    verticalPadding = Tween<double>(begin: 0, end: 26).animate( anim);

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 150,
      height: 200,
      margin: EdgeInsets.only(right: 2),
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child){
          return Stack(
            children: <Widget>[
             Align(alignment: firstAnim.value, child: getItem(options.elementAt(0)),),
              Align(
                  alignment: secondAnim.value,
                  child: Container(
                    padding: EdgeInsets.only(left: 50, top: verticalPadding.value),
                      child: getItem(options.elementAt(1)))
              ),

              Align(alignment: thirthAnim.value, child: getItem(options.elementAt(2))),
              Align(alignment: fourthAnim.value,
                    child: Container(
                      padding: EdgeInsets.only(left: 50, bottom: verticalPadding.value),
                      child: getItem(options.elementAt(3)),
                    )
              ),

              Align(alignment: fivethAnim.value, child: getItem(options.elementAt(4))),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: (){
                      if(controller.isCompleted){
                        controller.reverse();
                      }else{
                        controller.forward();
                      }
                    },
                    child: buildPrimaryItem(controller.isCompleted || controller.isAnimating? Icons.close : Icons.add)),
              )
            ],
          );
        },
      ),
    );
  }
}