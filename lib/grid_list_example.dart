import 'package:flutter/material.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grid List',
      home: MainPage(),
    );
  }
}


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid Sample'),
      ),
      body: GridView.count(
         crossAxisCount: 2,
        scrollDirection: Axis.vertical,
        children: List.generate(8, (index){
          return Container(
            color: Colors.primaries[index],
            child: Center(
              child: Text('Item ${index+1}'),
            ),
          );
        }),
      ),
    );
  }
}
