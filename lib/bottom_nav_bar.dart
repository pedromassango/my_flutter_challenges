import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Bottom Navy',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  TabController _controller;

  List<String> pages = [
    'Page One',
    'Page Two',
    'Page Three',
    'Page Four',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(
        vsync: this,
        length: pages.length,
      initialIndex: _index
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _controller,
        children: pages.map((title) {
          return Center(
            child: Text(
              '$title',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 52),
            ),
          );
        }).toList(),
      ),
      appBar: AppBar(
        elevation: 1,
        title: Text("BottomNavyBar"),
        actions: <Widget>[
          Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        onItemSelected: (index) {
          setState(() {
            _index = index;
            _controller.animateTo(_index);
          });
        },
        items: [
          BottomNavyBarItem(icon: Icon(Icons.apps), title: Text('Home')),
          BottomNavyBarItem(icon: Icon(Icons.people), title: Text('Users')),
          BottomNavyBarItem(icon: Icon(Icons.message), title: Text('Messages')),
          BottomNavyBarItem(icon: Icon(Icons.settings), title: Text('Settings')),
        ],
      ),
    );
  }
}

