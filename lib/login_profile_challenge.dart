import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login & Register",
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32)
              ),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Login Now", style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    Text("Please login to continue using our app.",
                      style: TextStyle(
                        color: Colors.blueGrey
                      ),
                    ),
                    SizedBox(height: 90,),
                    Text("Email ID"),
                    SizedBox(height: 10,),
                    Material(
                      elevation: 4,
                        borderRadius: BorderRadius.all(
                            Radius.circular(32),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                        ),
                    ),

                    SizedBox(height: 32,),
                    Text("Password"),
                    SizedBox(height: 10,),
                    Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(32),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text("Forgot your password?",
                            style: TextStyle(
                              color: Colors.deepPurple
                            ),
                          ),
                        ),
                    ),

                    MaterialButton(
                      shape: BeveledRectangleBorder(
                        side: BorderSide(
                            width: 16.0, color: Colors.lightBlue.shade50
                        ),
                          borderRadius: BorderRadius.circular(32)
                      ),
                      minWidth: double.maxFinite,
                      color: Colors.deepPurple,
                      onPressed: (){},
                      child: Text("Login"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
