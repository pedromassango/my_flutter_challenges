import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';

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

class MyState extends State<SplashPage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[Positioned(top: -120, child: TimerPicker())],
        ),
      ),
    );
  }
}

class TimerPicker extends StatefulWidget {
  @override
  _TimerPickerState createState() => _TimerPickerState();
}

class _TimerPickerState extends State<TimerPicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width + 90,
      height: MediaQuery.of(context).size.height / 1.8,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          NumberPicker(
            shouldCalculateByFive: true,
            size: Size(MediaQuery.of(context).size.width + 90,
                MediaQuery.of(context).size.width + 90),
            maxNumbers: 12,
          ),
          NumberPicker(
            maxNumbers: 12,
            showIndicator: true,
          ),
        ],
      ),
    );
  }
}

class NumberPicker extends StatefulWidget {
  final Color color;
  final bool showIndicator;
  final int maxNumbers;
  final Size size;
  final bool shouldCalculateByFive;

  const NumberPicker(
      {Key key,
      this.size,
      this.color = Colors.black12,
      this.maxNumbers,
      this.showIndicator = false,
      this.shouldCalculateByFive = false})
      : super(key: key);

  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker>
    with SingleTickerProviderStateMixin {
  Size get size => widget.size ?? Size(280, 280);

  int get maxNumbers => widget.maxNumbers;

  bool get showIndicator => widget.showIndicator;

  bool get shouldCalculateByFive => widget.shouldCalculateByFive;
  double rotationPercent = 0;
  double startRotationPercent = 0;

  PolarCoord dragCord;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CircleDragGestureDetector(
        onCircleDragUpdate: (cord) {
          if (dragCord != null) {
            final angleDiff = cord.angle - dragCord.angle;
            final anglePercent = angleDiff / (0.5235987755982988 * pi);

            rotationPercent = (startRotationPercent + anglePercent);
            setState(() {});
          }
        },
        onCircleDragStart: (cordStart) {
          dragCord = cordStart;
          startRotationPercent = rotationPercent;
        },
        onCircleDragEnd: () {
          dragCord = null;
          startRotationPercent = null;
          print("onRadialDragEnd");
        },
        child: Container(
          height: size.height,
          width: size.width,
          padding: EdgeInsets.all(size.width - size.height / 1.27),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: Transform.rotate(
                  angle: 1.9*pi*0.5235987755982988,
                  child: Container(
                    width: 10,
                    height: 10,
                    child: CustomPaint(
                      painter: showIndicator ? IndicatorPainter() : null,
                    ),
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Transform.rotate(
                  angle: (0.5235987755982988 * pi * rotationPercent),
                  child: CustomPaint(
                    painter: NumberPainter(
                      shouldCalculate: shouldCalculateByFive,
                      numbers: maxNumbers,
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




class IndicatorPainter extends CustomPainter {
  final Paint indicatorPainter;

  IndicatorPainter()
      : indicatorPainter = Paint()
          ..color = Colors.white
          ..strokeWidth = 4.5;

  @override
  void paint(Canvas canvas, Size size) {

    canvas.save();
    canvas.translate(size.width / 2, -65);

    var path = Path();
    path.moveTo(0, -5.0);
    path.lineTo(10, 10);
    path.lineTo(-10, 10);
    path.close();

    //canvas.drawLine(Offset(0, size.height / 2), Offset(0, 70), indicatorPainter);
    canvas.drawPath(path, indicatorPainter);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class NumberPainter extends CustomPainter {
  final bool shouldCalculate;
  final int numbers;
   TextPainter textPaint;
   TextStyle textStyle;
   final List<TextSpan> textSpans = [];

  NumberPainter({this.shouldCalculate = false, this.numbers}){
    textStyle = TextStyle(color: Colors.white, fontSize: 16);
    textPaint = TextPainter()
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr;


    for (int i = 0; i < numbers; i++) {
      TextSpan span = TextSpan(
        text: "$i",
          style: textStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              //TODO: this body is not being called!
              print("onTap called");
            }
      );

      textSpans.add(span);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    final double firstItemAngle = pi;
    final double lastItemAngle = pi;
    final double angleDiff = (firstItemAngle + lastItemAngle) / (numbers);


    for (int i = 0; i < numbers; i++) {
      canvas.save();
      canvas.translate(0, -(size.width / 2) - 29.5);

      textPaint.text = textSpans.elementAt(i);

      textPaint.layout();
      textPaint.paint(
          canvas, Offset(-textPaint.width / 2, -textPaint.height / 2),
      );

      canvas.restore();

      canvas.rotate(angleDiff);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}





class CircleDragGestureDetector extends StatefulWidget {
  final CircleDragStart onCircleDragStart;
  final CircleDragUpdate onCircleDragUpdate;
  final CircleDragEnd onCircleDragEnd;
  final Widget child;

  CircleDragGestureDetector({
    this.onCircleDragStart,
    this.onCircleDragUpdate,
    this.onCircleDragEnd,
    this.child,
  });

  @override
  _CircleDragGestureDetectorState createState() =>
      new _CircleDragGestureDetectorState();
}

class _CircleDragGestureDetectorState extends State<CircleDragGestureDetector> {
  _onPanStart(DragStartDetails details) {
    if (null != widget.onCircleDragStart) {
      final polarCoord = _polarCoordFromGlobalOffset(details.globalPosition);
      widget.onCircleDragStart(polarCoord);
    }
  }

  _onPanUpdate(DragUpdateDetails details) {
    if (null != widget.onCircleDragUpdate) {
      final polarCoord = _polarCoordFromGlobalOffset(details.globalPosition);
      widget.onCircleDragUpdate(polarCoord);
    }
  }

  _onPanEnd(DragEndDetails details) {
    if (null != widget.onCircleDragEnd) {
      widget.onCircleDragEnd();
    }
  }

  _polarCoordFromGlobalOffset(globalOffset) {
    // Convert the user's global touch offset to an offset that is local to
    // this Widget.
    final localTouchOffset =
        (context.findRenderObject() as RenderBox).globalToLocal(globalOffset);

    // Convert the local offset to a Point so that we can do math with it.
    final localTouchPoint = new Point(localTouchOffset.dx, localTouchOffset.dy);

    // Create a Point at the center of this Widget to act as the origin.
    final originPoint =
        new Point(context.size.width / 2, context.size.height / 2);

    return new PolarCoord.fromPoints(originPoint, localTouchPoint);
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: widget.child,
    );
  }
}

class PolarCoord {
  final double angle;
  final double radius;

  factory PolarCoord.fromPoints(Point origin, Point point) {
    // Subtract the origin from the point to get the vector from the origin
    // to the point.
    final vectorPoint = point - origin;
    final vector = new Offset(vectorPoint.x, vectorPoint.y);

    // The polar coordinate is the angle the vector forms with the x-axis, and
    // the distance of the vector.
    return new PolarCoord(
      vector.direction,
      vector.distance,
    );
  }

  PolarCoord(this.angle, this.radius);

  @override
  toString() {
    return 'Polar Coord: ${radius.toStringAsFixed(2)}' +
        ' at ${(angle / (2 * pi) * 360).toStringAsFixed(2)}°';
  }
}

typedef CircleDragStart = Function(PolarCoord startCoord);
typedef CircleDragUpdate = Function(PolarCoord updateCoord);
typedef CircleDragEnd = Function();
