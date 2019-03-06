import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  final List<String> categories = ['Top stories', 'Design', 'Business', 'Auto'];
  List<List<String>> buildData(){
    return List.generate(5, (index){
      return List.generate(5, (i){
        return "Item $i";
      });
    });
  }

  ScrollController controller;
  AnimationController _animationController;
  Animation<double> animation;

  int s = 0;

  @override
  void initState() {
    super.initState();

    controller = ScrollController();
    controller.addListener((){
      var offset = controller.offset;
      print('OFFSET> $offset');

      if(offset == 0){
        _animationController.forward();
        return;
      } else if (offset > 0 && _animationController.isCompleted) {
        _animationController.reverse();
      }
    });

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
    );

    animation = Tween<double>(
        begin: 0, end: 200
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.linear));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child){
              return Container(
                margin: EdgeInsets.only(top: animation.value),
                child: _buildContent(),
              );
            },
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildContent() {
    return ListView.builder(
      controller: controller,
      itemCount: categories.length,
      itemBuilder: (BuildContext context, index) {
        var subList = buildData().elementAt(index);

        return ListItem(
          isLastItem: (categories.length - 1) == index,
          data: categories.elementAt(index),
          secondaryListData: subList.map((title) {
            return SubItemModel(
                title: title,
                description: '${index * 2}min ago'
            );
          }).toList(),
        );
      },
    );
  }
}


class ListItem extends StatefulWidget {

  final String data;
  final bool isLastItem;
  final List<SubItemModel> secondaryListData;
  const ListItem({
    Key key,
    this.secondaryListData,
    this.data,
    this.isLastItem
  }) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {

  final String divider = '...';
  final double height = 200;
  final double primaryListWidth = 60;

  FixedExtentScrollController controller;

  @override
  void initState(){
    super.initState();

    controller = FixedExtentScrollController(
        initialItem: 0
    );
  }

  Widget _buildTitleItem(String data) {
    return RotatedBox(
      quarterTurns: (180.0 - pi / 180.0).toInt(),
      child: Container(
        child: Center(
          child: Text(data, style: TextStyle(
              fontSize: 18,
              fontWeight: data == "..." ? FontWeight.bold : null
          ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: Row(
        children: <Widget>[
          Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 24, bottom: 24),
              width: primaryListWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildTitleItem(widget.data),
                  widget.isLastItem ? Container() : Spacer(),
                  widget.isLastItem? Container() : _buildTitleItem("..."),
                ],
              )
          ),
          Container(
            color: Colors.grey[100],
            margin: EdgeInsets.only(bottom: 1.5),
            width: MediaQuery.of(context).size.width - primaryListWidth,
            child: ListWheelScrollView(
              itemExtent: (height/2.6)/1*0.9,
              controller: controller,
              diameterRatio: 25.1,
              physics: FixedExtentScrollPhysics(),
              children: widget.secondaryListData.map((item){
                return ChildListItemWidget(
                  parentHeight: height,
                  item: item,
                );
              }).toList(),
            ) ,
          ),
        ],
      ),
    );
  }

}


class ChildListItemWidget extends StatelessWidget{

  final SubItemModel item;
  final double parentHeight;
  const ChildListItemWidget({
    Key key,
    this.item,
    this.parentHeight
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: parentHeight/2.5,
      padding: EdgeInsets.only(top: 8,bottom: 8, left: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(item.title, style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(item.description, style: TextStyle(
                ),),
              ),
            ],
          ),

          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomLeft: Radius.circular(6)
                )
            ),
          )
        ],
      ),
    );
  }
}

class SubItemModel{
  final String title;
  final String description;
  final String imageUrl;

  SubItemModel({this.title, this.description, this.imageUrl});
}




///  A working sample in progress...
class _MyHomePageState_ extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.black12,
              child: NumberSelector(
                color: Colors.pink,
              ),
            ),
          )
        ],
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}




class NumberSelector extends StatefulWidget {
  final Color color;

  NumberSelector({Key key,
    this.color,
  }) : super(key: key);

  @override
  _NumberSelectorState createState() => _NumberSelectorState();
}

class _NumberSelectorState extends State<NumberSelector> {

  double sliderPercent = 100;
  double startDragPercent;
  double startDragX;
  bool isAnimating = false;
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Stack(
      children: <Widget>[
        ClipPath(
            clipper: MarksClipper(
                sliderPercent: sliderPercent,
                isAnimating: isAnimating
            ),
            child: Container(
              width: width,
              height: 200,
              color: Colors.pink[400],
            )
        ),

        GestureDetector(
          onHorizontalDragStart: _horizontalDragStart,
          onHorizontalDragUpdate: _horizontalDragUpdate,
          onHorizontalDragEnd: _horizontalDragEnd,
          child: ClipPath(
            clipper: CircleClipper(
                sliderPercent: sliderPercent
            ),
            child: Container(
              color: Color(0XFF212121),
            ),
          ),
        )
      ],
    );
  }

  void _horizontalDragStart(DragStartDetails details) {
    isAnimating = true;
    startDragX = details.globalPosition.dx;
    startDragPercent = (sliderPercent-startDragX);
  }

  void _horizontalDragUpdate(DragUpdateDetails details) {
    isAnimating = true;
    final distance = startDragX + details.globalPosition.dx;
    final sliderWidth = size.width;
    final mDragPercent = distance / sliderWidth;

    // Testing
    final mPercent = startDragPercent + mDragPercent *
        details.globalPosition.distance/1.7;

    print('PERCENT: $mPercent');

    setState(() {
      // Testing
      sliderPercent = mPercent;

      //sliderPercent = startDragPercent + mDragPercent * details.globalPosition.distance/50.5;
    });
  }

  void _horizontalDragEnd(DragEndDetails details) {
    isAnimating = false;
    startDragX = null;
    startDragPercent = null;

  }
}



class CircleClipper extends CustomClipper<Path>{
  final double sliderPercent;
  final double radius = 20;

  CircleClipper({this.sliderPercent});

  @override
  Path getClip(Size size) {
    final p = Path();
    //final positionY = size.height-radius; //TODO: remove this line
    final positionY = size.height/2+radius*1.5;

    p.addOval(Rect.fromCircle(
        center: Offset(sliderPercent, positionY),
        radius: radius
    ));

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class MarksClipper extends CustomClipper<Path> {

  final double sliderPercent;
  final bool isAnimating;

  MarksClipper({
    this.sliderPercent,
    this.isAnimating
  });


  @override
  Path getClip(Size size) {
    final path = Path();

    final elevation = isAnimating ? 10 : 0;
    final circlePosiX = isAnimating ? sliderPercent : size.width;

    final strokeSize = size.height/2-5;

    //print("strokeSize: $strokeSize");

    path.lineTo(0, size.height-strokeSize);
    //path.quadraticBezierTo(size.width-sliderPercent, size.height-strokeSize-elevation, size.width, size.height-strokeSize);

    path.quadraticBezierTo(circlePosiX, size.height-strokeSize-elevation,
        size.width, size.height-strokeSize+elevation);



    path.lineTo(size.width, strokeSize);
    path.lineTo(0, strokeSize);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}