import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Crazy Switch",
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crazy Switch"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: CrazySwitch(),
        ),
      ),
    );
  }
}


class CrazySwitch extends StatefulWidget {
  @override
  _CrazySwitchState createState() => _CrazySwitchState();
}

class _CrazySwitchState extends
  State<CrazySwitch> with
  SingleTickerProviderStateMixin {

  bool isChecked = false;
  Animation<Alignment> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 450)
    );

    _animation = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceIn,
        reverseCurve: Curves.bounceOut
      )
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (animation, child){
        return Container(
          width: 130,
          height: 60,
          decoration: BoxDecoration(
            color: isChecked ? Colors.green : Colors.red,
            borderRadius: BorderRadius.all(
                Radius.circular(32)
            ),
            boxShadow: [
              BoxShadow(
                color: isChecked ? Colors.green : Colors.red,
                blurRadius: 15,
                offset: Offset(0, 15)
              )
            ]
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: _animation.value,
                child: GestureDetector(
                  onTap: (){
                    if(_animationController.isCompleted){
                      _animationController.reverse();
                    }else{
                      _animationController.forward();
                    }

                    isChecked = !isChecked;
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    margin: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}


