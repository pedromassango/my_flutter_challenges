import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: MediaQuery.of(context).size.height/2,
              child: Image.asset(
                "images/martian_surface.png",
              ),
            ),

            Positioned(
              top: 100,
              left: 32,
              child: Text('Sign in',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),

            Positioned(
              top: 190,
              child: Container(
                padding: EdgeInsets.all(32),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(62),
                    topRight: Radius.circular(62)
                  )
                ),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Username'
                      )
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 62),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Password'
                        ),
                      ),
                    ),

                    Container(
                      height: 45,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(32)
                        ),
                      ),
                      child: Center(
                        child: Text('LOGIN',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    Container(height: 8,),
                    Text("Forgot your Password?",
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    ),

                    Container(height: 70,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.all(
                                  Radius.circular(100)
                              )
                          ),
                          child: Center(
                            child: Icon(Icons.face,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),

                        Container(width: 30,),

                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.all(
                                  Radius.circular(100)
                              )
                          ),
                          child: Center(
                            child: Icon(Icons.fingerprint,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
