import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp( MobileApp());

class MobileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mobile Dashboard",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Color accentColor = Color(0XFFFA2B0F);

  List<ItemModel> items = [
    ItemModel("Tasks", 12, 1830),
    ItemModel("Analytics", 4, 883),
    ItemModel("Works", 2, 326),
  ];

  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  Widget _buildTitle() {
    return Text("Home",
      style: TextStyle(
        fontSize: 40,
        color: Colors.black,
        fontWeight: FontWeight.bold
      ),
    );
  }

  Text _buildText(String title){
    return Text(title,
    style: TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold
    ),
    );
  }

  IconButton _buildButton(IconData icon){
    return IconButton(
      onPressed: (){},
      icon: Icon(icon, color: Colors.white,),
    );
  }

  Widget _buildBottomCardChildren(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            _buildText("All"),
            Spacer(),
            _buildText("Done")
          ],
        ),
        Container(height: 24,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildButton(Icons.radio_button_checked),
            _buildButton(Icons.home),
            _buildButton(Icons.settings),
          ],
        )
      ],
    );
  }

  Widget _buildBottomCard(double width, double height){
    return Container(
      width: width,
      height: height/3,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16)
        )
      ),
      child: _buildBottomCardChildren(),
    );
  }

  Widget _buildItemCardChild(ItemModel item){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(item.title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(item.numOne.toString(), style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.pie_chart, color: accentColor,)
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.menu, color: Colors.grey,),
            ),

            Text(item.numTwo.toString(), style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
            ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildItemCard(ItemModel item){
    return Container(
      width: 120,
      height: 145,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      margin: EdgeInsets.only(left: 32, right: 32, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1
          )
        ]
      ),
      child: _buildItemCardChild( item),
    );
  }
  Widget _buildCardsList(){
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index){
        var item = items.elementAt(index);
        return _buildItemCard( item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[300],
        title: _buildTitle(),
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.notifications,
                color: Colors.blueGrey,
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 16),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
                child: _buildBottomCard(width, height)
            ),
            _buildCardsList(),
          ],
        ),
      ),
    );
  }
}

class ItemModel{
  final String title;
  final int numOne;
  final int numTwo;

  ItemModel(this.title, this.numOne, this.numTwo);
}



