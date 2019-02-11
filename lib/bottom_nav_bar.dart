import 'package:flutter/material.dart';

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

class BottomNavyBar extends StatefulWidget {
  final int currentIndex;
  final double iconSize;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;
  final List<BottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;

  const BottomNavyBar(
      {Key key,
      this.currentIndex = 0,
      this.iconSize = 24,
      this.activeColor,
      this.inactiveColor,
      this.backgroundColor,
      @required this.items,
      @required this.onItemSelected})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BottomNavyBarState(
        items: items,
        backgroundColor: backgroundColor,
        currentIndex: currentIndex,
        iconSize: iconSize,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        onItemSelected: onItemSelected);
  }
}

class BottomNavyBarState extends State<BottomNavyBar> {
  final int currentIndex;
  final double iconSize;
  Color activeColor;
  Color inactiveColor;
  Color backgroundColor;
  List<BottomNavyBarItem> items;
  int _selectedIndex;
  ValueChanged<int> onItemSelected;

  BottomNavyBarState(
      {@required this.items,
      this.currentIndex,
      this.activeColor,
      this.inactiveColor = Colors.black,
      this.backgroundColor,
      this.iconSize,
      @required this.onItemSelected}) {
    _selectedIndex = currentIndex;
  }

  Widget _buildItem(BottomNavyBarItem item, bool isSelected) {
    return AnimatedContainer(
      width: isSelected ? 124 : 50,
      height: double.maxFinite,
      duration: Duration(milliseconds: 250),
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              color: activeColor,
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconTheme(
                  data: IconThemeData(
                      size: iconSize,
                      color: isSelected ? backgroundColor : inactiveColor),
                  child: item.icon,
                ),
              ),
              isSelected
                  ? DefaultTextStyle.merge(
                      style: TextStyle(color: backgroundColor),
                      child: item.title)
                  : SizedBox.shrink()
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    activeColor =
        (activeColor == null) ? Theme.of(context).accentColor : activeColor;

    backgroundColor = (backgroundColor == null)
        ? Theme.of(context).bottomAppBarColor
        : backgroundColor;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 56,
      padding: EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
      decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items.map((item) {
          var index = items.indexOf(item);
          return GestureDetector(
            onTap: () {
              onItemSelected(index);

              setState(() {
                _selectedIndex = index;
              });
            },
            child: _buildItem(item, _selectedIndex == index),
          );
        }).toList(),
      ),
    );
  }
}

class BottomNavyBarItem {
  final Icon icon;
  final Text title;

  BottomNavyBarItem({
    @required this.icon,
    @required this.title,
  });
}
