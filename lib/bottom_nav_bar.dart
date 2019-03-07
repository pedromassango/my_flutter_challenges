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
      floatingActionButton: GestureDetector(
        onTap: (){
          Navigator.push(context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (c)=> GDialog()
          )
          );
        },
          child: GMenu(),
      ),
      bottomNavigationBar: BottomNavyBar(
        onItemSelected: (index) => setState(() {
            _index = index;
            _controller.animateTo(_index);
        }),
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
        ],
      ),

    );
  }
}

class GMenu extends StatefulWidget {
  @override
  _GMenuState createState() => _GMenuState();
}
class _GMenuState extends State<GMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15
          )
        ]
      ),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: Column(
          children: <Widget>[
            Hero(
              tag: '1',
              child: Container(
                color: Colors.orange,
                width: double.maxFinite,
                height: 5,
              ),
            ),
            Hero(
              tag: '2',
              child: Container(
                margin: EdgeInsets.only(top: 3, bottom: 3),
                color: Colors.blue,
                width: double.maxFinite,
                height: 5,
              ),
            ),
            Hero(
              tag: '3',
              child: Container(
                color: Colors.green,
                width: double.maxFinite,
                height: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GDialog extends StatefulWidget {
  @override
  _GDialogState createState() => _GDialogState();
}

class _GDialogState extends State<GDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 200,
          width: 300,
          child: Column(
            children: <Widget>[
              Hero(
                tag: '1',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    color: Colors.orange,
                    width: double.maxFinite,
                    height: 50,
                    child: Center(
                      child: Text("Settings"),
                    ),
                  ),
                ),
              ),
              Hero(
                tag: '2',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    color: Colors.blue,
                    width: double.maxFinite,
                    height: 50,
                    child: Center(
                      child: Text("Messages"),
                    ),
                  ),
                ),
              ),
              Hero(
                tag: '3',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    color: Colors.green,
                    width: double.maxFinite,
                    height: 50,
                    child: Center(
                      child: Text("New Post"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
