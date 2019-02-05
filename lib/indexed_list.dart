import 'package:flutter/material.dart';

void main() {
  runApp(MainAppWidget());
}

class MainAppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main App Widget',
      theme: ThemeData(primarySwatch: Colors.red),
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyState();
  }
}
// Love song (Adele)

class MyState extends State<SplashPage> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> angle;

  String header;

  List<String> names() {
    return [
      'Pedro',
      'Pedro',
      'Pedro',
      'Pedro',
      'Pedro',
      'Pedro',
      'Pedro',
      'Pedro',
      'Pedro',
      'Pedro',
      'Anna',
      'Anna',
      'Anna',
      'Anna',
      'Anna',
      'Anna',
      'Anna',
      'Anna',
      'Maria',
      'Maria',
      'Maria',
      'Maria',
      'Maria',
      'Maria',
      'Maria',
      'Maria',
    ];
  }

  Widget _buildItem(String name) {
    List<Color> _colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.purple,
      Colors.deepPurple
    ];

    return Container(
      width: double.maxFinite,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1
          )
        ],
      ),
      child: Center(child: Text(name, style: TextStyle(color: Colors.black, fontSize: 18),),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          "List whit Header: $header",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: names().length,
        itemBuilder: (c, index) {
          var name = names().elementAt(index);
          try{
            print('INDEX: $name');
            setState(() {
              header = name;
            });
          }catch(e){}

          return _buildItem(name);
        },
      ),
    );
  }
}
