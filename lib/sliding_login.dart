import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sliding Login',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  Animation<double> loginSize;
  AnimationController loginController;
  AnimatedOpacity opacityAnimation;
  Duration animationDuration = Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    loginController =
        AnimationController(vsync: this, duration: animationDuration);

    opacityAnimation =
        AnimatedOpacity(opacity: 0.0, duration: animationDuration);
  }

  @override
  void dispose() {
    loginController.dispose();
    super.dispose();
  }

  Widget _buildLoginWidgets() {
    return Container(
      padding: EdgeInsets.only(bottom: 62, top: 16),
      width: MediaQuery.of(context).size.width,
      height: loginSize.value,
      decoration: BoxDecoration(
          color: Color(0XFF2a3ed7),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(190),
              bottomRight: Radius.circular(190))),
      child: Stack(
        children: <Widget>[

          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 42, right: 42),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    style: TextStyle(color: Colors.white, height: 0.5),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                        hintText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32)))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 16),
                    child: TextField(
                      style: TextStyle(color: Colors.white, height: 0.5),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.vpn_key),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(32)))),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: isLogin ? 0.0 : 1.0,
              duration: animationDuration,
              child: GestureDetector(
                onTap: () {
                  loginController.reverse();

                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  'LOG IN'.toUpperCase(),
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                visible: isLogin,
                child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  child: Center(
                    child: Text(
                      'LOG IN',
                      style: TextStyle(color: Color(0XFF2a3ed7),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterWidgets() {
    return Padding(
      padding: EdgeInsets.only(
        left: 42,
        right: 42,
        top: 32,
        bottom: 32
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Text(
              'Sign Up'.toUpperCase(),
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF2a3ed7)),
            ),
          ),
          TextField(
            style: TextStyle(color: Colors.black, height: 0.5),
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                ),
                hintText: 'Email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32)))),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 16),
            child: TextField(
              style: TextStyle(color: Colors.black, height: 0.5),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)))),
            ),
          ),
          TextField(
            style: TextStyle(color: Colors.black, height: 0.5),
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                hintText: 'Confirm Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32)))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: MaterialButton(
              minWidth: 200,
              color: Color(0XFF2a3ed7),
              onPressed: () {},
              child: Text(
                'SIGN UP',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _defaultLoginSize = MediaQuery.of(context).size.height / 1.6;

    loginSize = Tween<double>(begin: _defaultLoginSize, end: 200).animate(
        CurvedAnimation(parent: loginController, curve: Curves.linear));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: isLogin ? 0.0 : 1.0,
              duration: animationDuration,
                child: Container(child: _buildRegisterWidgets()),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: _defaultLoginSize/1.5,
              child: Visibility(
                visible: isLogin,
                child: GestureDetector(
                  onTap: () {
                    loginController.forward();
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Center(
                    child: Text(
                      'Sign Up'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF2a3ed7),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: loginController,
            builder: (context, child) {
              return _buildLoginWidgets();
            },
          )
        ],
      ),
    );
  }
}
