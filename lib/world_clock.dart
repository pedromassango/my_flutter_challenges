import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//final Color bgColor = Color(0xFF142550);
final Color bgColor = Colors.white;

class _HomePageState extends State<HomePage> {

  Stopwatch stopwatch;
  double hour = 0;
  double minute = 0;
  double seconds = 0;
  DateTime now = DateTime.now();

  int currentIndex = 0;
  final items = ["Clock", "List", "Settings"];
  final icons = [Icons.alarm, Icons.list, Icons.settings];

  double _secondPercent() => stopwatch.elapsed.inSeconds / 60;
  double _minutesPercent() => minute / 60;
  double _hoursPercent() => hour / 24;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    stopwatch = Stopwatch();
    hour = now.hour.toDouble();
    minute = now.minute.toDouble();

    Timer.periodic(Duration.zero, (t){
      if(stopwatch.elapsed.inSeconds == 60){
        minute = DateTime.now().minute.toDouble();
        stopwatch.reset();
      }else if(stopwatch.elapsed.inMinutes == 60){
        hour = DateTime.now().second.toDouble();
        stopwatch.reset();
      }

      setState(() {});
    });

    stopwatch.start();
  }

  Widget _addButton(){
    return Container(
      height: 50,
      width: 50,
      margin: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 2
          )
        ]
      ),
      child: Center(
        child: Icon(Icons.add, color: Colors.white, size: 32,),
      ),
    );
  }

  Widget _editButton(){
    return Container(
      height: 50,
      width: 50,
      margin: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 10
          )
        ]
      ),
      child: Center(
        child: Icon(Icons.edit, color: Colors.redAccent, size: 32,),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    stopwatch?.stop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: bgColor,
        body: Container(
          child: Stack(
            children: <Widget>[

              Positioned(
                top: 40,
                  child: _addButton(),
              ),

              Positioned(
                top: 40,
                  right: 16,
                  child: _editButton(),
              ),

              Column(
                children: <Widget>[
                  Spacer(),
                  Spacer(),
                  Center(
                    child: Container(
                      height: 310,
                      width: 310,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26.withOpacity(0.04),
                            blurRadius: 10,
                            offset: Offset(-12, 0),
                            spreadRadius: 2
                          ),
                          BoxShadow(
                              color: Colors.black26.withOpacity(0.04),
                              blurRadius: 10,
                              offset: Offset(12, 0),
                              spreadRadius: 5
                          ),
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomPaint(
                          painter: LinesPainter(),
                          child: Container(
                            margin: const EdgeInsets.all(32.0),
                            decoration: BoxDecoration(
                              color: bgColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26.withOpacity(0.03),
                                    blurRadius: 5,
                                    spreadRadius: 8
                                ),
                              ]
                            ),
                            child: CustomPaint(
                              painter: TimeLinesPainter(
                                lineType: LineType.minute,
                                tick: _minutesPercent()
                              ),
                              child: CustomPaint(
                                painter: TimeLinesPainter(
                                    lineType: LineType.hour,
                                    tick: _hoursPercent()
                                ),
                                child: CustomPaint(
                                  painter: TimeLinesPainter(
                                    lineType: LineType.second,
                                    tick: _secondPercent()
                                  )
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40,),
                  Text("Luanda", style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 32,
                  ),),
                  Text("${hour.round()}:${minute.round()} ${TimeOfDay.fromDateTime(now).period == DayPeriod.am ? 'AM' : 'PM'}", style: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                  )),
                  Spacer()
                ],
              ),

            ],
          ),
        ),
        bottomNavigationBar: Builder(
          builder: (context){

            return Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items.map((t){
                  return _getItem(t, items.indexOf(t));
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getItem(String t, int index) {
    final selected = index == currentIndex;
    final color = selected ? Colors.black : Colors.grey;

    return GestureDetector(
      onTap: (){
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        children: <Widget>[
          Icon(icons.elementAt(index), size: selected ? 40 : 32, color: color,),
          Text(t, style: TextStyle(
              color: color
          ),)
        ],
      ),
    );
  }
}

enum LineType{ hour, minute, second }


class LinesPainter extends CustomPainter{

  final Paint linePainter;

  final double lineHeight = 8;
  final int maxLines = 30;

  LinesPainter():
        linePainter = Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width/2, size.height/2);

    canvas.save();

    final radius = size.width/2;

    List.generate(maxLines, (i){

      canvas.drawLine(
        Offset(0,  radius),
        Offset(0, radius - 8),
        linePainter
      );

      canvas.rotate(2 * pi / maxLines);
    });

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TimeLinesPainter extends CustomPainter{

  final Paint linePainter;
  final Paint hourPainter;
  final Paint minutePainter;
  final double tick;
  final LineType lineType;

  TimeLinesPainter({this.tick, this.lineType}):
        linePainter = Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
        minutePainter = Paint()
          ..color = Colors.black38
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5,
        hourPainter = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.5;

  @override
  void paint(Canvas canvas, Size size) {

    final radius = size.width / 2;

    canvas.translate(radius, radius);

    switch(lineType){
      case LineType.hour:
        canvas.rotate(24 * pi * tick );
        canvas.drawPath(_hourPath(radius), hourPainter);
        break;
      case LineType.minute:
        canvas.rotate(2 * pi * tick );
        canvas.drawPath(_minutePath(radius), minutePainter);
        break;
      case LineType.second:
        canvas.rotate(2 * pi * tick );
        canvas.drawPath(_secondPath(radius), linePainter);
        canvas.drawShadow(_secondPath(radius), Colors.black26, 100, true);

        break;
    }
  }

  Path _hourPath(double radius){
    return Path()
        ..lineTo(0, -((radius/1.4)/2))
        ..close();
  }

  Path _minutePath(double radius){
    return Path()
        ..lineTo(0, -(radius/1.4))
        ..close();
  }

  Path _secondPath(double radius){
    return Path()
        ..lineTo(0, -(radius+10))
        ..close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}