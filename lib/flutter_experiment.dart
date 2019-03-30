import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = ThemeData(
      primaryColor: Color(0xFF285DD4),
      accentColor: Colors.pinkAccent,
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.copyWith(
        sliderTheme: theme.sliderTheme.copyWith(
          thumbColor: const Color(0xFFD1DFFF),
        ),
      ),
      home: ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final min = 0.0;
  final max = 20000.0;
  final lower = ValueNotifier(4680.0);
  final upper = ValueNotifier(14780.0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Price',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: ' Range'),
                ],
              ),
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 42.0,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 32.0),
            AnimatedBuilder(
              animation: Listenable.merge([lower, upper]),
              builder: (BuildContext context, Widget child) {
                final localizations = MaterialLocalizations.of(context);
                final lowerAmount = '\$${localizations.formatDecimal(lower.value.toInt())}';
                final upperAmount = '\$${localizations.formatDecimal(upper.value.toInt())}';
                return Text(
                  '$lowerAmount - $upperAmount',
                  style: TextStyle(
                    fontSize: 21.0,
                    color: theme.primaryColor,
                  ),
                );
              },
            ),
            const SizedBox(height: 8.0),
            Text(
              'Average price: \$1200',
              style: TextStyle(
                fontSize: 21.0,
                color: theme.disabledColor.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 32.0),
            RubberRangePicker(
              minValue: min,
              lowerValue: lower.value,
              upperValue: upper.value,
              maxValue: max,
              onRangeChanged: (double lowerValue, double upperValue) {
                lower.value = lowerValue;
                upper.value = upperValue;
              },
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}

typedef RubberRangeChanged = void Function(double lowerValue, double upperValue);

class RubberRangePicker extends LeafRenderObjectWidget {
  const RubberRangePicker({
    Key key,
    @required this.lowerValue,
    @required this.upperValue,
    this.minValue = 0.0,
    this.maxValue = 1.0,
    this.onRangeChanged,
  })  : assert(minValue != null && maxValue != null && minValue < maxValue),
        super(key: key);

  final double lowerValue;
  final double upperValue;
  final double minValue;
  final double maxValue;
  final RubberRangeChanged onRangeChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    final theme = Theme.of(context);
    final slider = SliderTheme.of(context);
    return RenderRubberRangePicker(
      minValue: minValue,
      maxValue: maxValue,
      lowerValue: lowerValue,
      upperValue: upperValue,
      inactiveTrackColor: slider.inactiveTrackColor,
      activeTrackColor: slider.activeTrackColor,
      inactiveThumbColor: theme.canvasColor,
      activeThumbColor: slider.thumbColor,
      onRangeChanged: onRangeChanged,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderRubberRangePicker renderObject) {
    final theme = Theme.of(context);
    final slider = SliderTheme.of(context);
    renderObject
      ..minValue = minValue
      ..maxValue = maxValue
      ..lowerValue = lowerValue
      ..upperValue = upperValue
      ..inactiveTrackColor = slider.inactiveTrackColor
      ..activeTrackColor = slider.activeTrackColor
      ..inactiveThumbColor = theme.canvasColor
      ..activeThumbColor = slider.thumbColor
      ..onRangeChanged = onRangeChanged;
  }
}

class RenderRubberRangePicker extends RenderBox {
  RenderRubberRangePicker({
    @required double minValue,
    @required double maxValue,
    @required double lowerValue,
    @required double upperValue,
    Color inactiveTrackColor,
    Color activeTrackColor,
    Color inactiveThumbColor,
    Color activeThumbColor,
    RubberRangeChanged onRangeChanged,
  })  : _minValue = minValue,
        _maxValue = maxValue,
        _lowerValue = lowerValue,
        _upperValue = upperValue,
        _onRangeChanged = onRangeChanged {
    _inactiveTrackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = inactiveTrackColor
      ..strokeWidth = 1.0;
    _activeTrackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = activeTrackColor
      ..strokeWidth = 1.5;
    _inactiveThumbPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = inactiveThumbColor;
    _activeThumbPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = activeThumbColor;
  }

  static const double thumbSize = 28.0;
  static const double damping = 0.5;
  static const double elasticity = 0.5;
  static const bool constraintStretch = true;
  static const double stretchRange = 60;
  static const double animationSpeed = 0.8;

  final firstSegment = Path();
  final secondSegment = Path();
  final thirdSegment = Path();

  Paint _inactiveTrackPaint;
  Paint _activeTrackPaint;
  Paint _inactiveThumbPaint;
  Paint _activeThumbPaint;

  double _minValue = 0.0;
  double _maxValue = 1.0;
  double _lowerValue = 0.0;
  double _upperValue = 1.0;
  RubberRangeChanged _onRangeChanged;

  Ticker _ticker;
  double _currentTime = 0.0;
  Rect _lowerThumb = Rect.zero;
  Rect _upperThumb = Rect.zero;
  Offset _previousLocation = Offset.zero;
  bool _movingLower = false;
  bool _movingUpper = false;

  double _lowerAnimationStart = 0.0;
  double _lowerStartOffset = 0.0;
  double _upperAnimationStart = 0.0;
  double _upperStartOffset = 0.0;
  double _vertOffset = 0.0;

  set minValue(double value) {
    _minValue = value;
    markNeedsPaint();
  }

  double get minValue {
    if (_minValue > _maxValue) {
      _maxValue = _minValue;
      markNeedsPaint();
    }
    return _minValue;
  }

  set maxValue(double value) {
    _maxValue = value;
    markNeedsPaint();
  }

  double get maxValue {
    if (_maxValue < _minValue) {
      _minValue = _maxValue;
      markNeedsPaint();
    }
    return _maxValue;
  }

  double get lowerValue => _lowerValue;

  set lowerValue(double value) {
    _lowerValue = value.clamp(minValue, maxValue);
    if (_lowerValue > upperValue) {
      upperValue = _lowerValue;
    }
    markNeedsPaint();
  }

  double get upperValue => _upperValue;

  set upperValue(double value) {
    _upperValue = value.clamp(minValue, maxValue);
    if (_upperValue < lowerValue) {
      lowerValue = _upperValue;
    }
    markNeedsPaint();
  }

  RubberRangeChanged get onRangeChanged => _onRangeChanged;

  set onRangeChanged(RubberRangeChanged value) {
    _onRangeChanged = value;
    notifyRangeChanged();
  }

  void notifyRangeChanged() {
    _onRangeChanged.call(lowerValue, upperValue);
  }

  Color get inactiveTrackColor => _inactiveTrackPaint.color;

  set inactiveTrackColor(Color value) {
    _inactiveTrackPaint.color = value;
    markNeedsPaint();
  }

  Color get activeTrackColor => _activeTrackPaint.color;

  set activeTrackColor(Color value) {
    _activeTrackPaint.color = value;
    markNeedsPaint();
  }

  Color get inactiveThumbColor => _inactiveThumbPaint.color;

  set inactiveThumbColor(Color value) {
    _inactiveThumbPaint.color = value;
    markNeedsPaint();
  }

  Color get activeThumbColor => _activeThumbPaint.color;

  set activeThumbColor(Color value) {
    _activeThumbPaint.color = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    assert(constraints.hasBoundedWidth);
    size = Size(constraints.maxWidth, thumbSize);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _ticker = Ticker((Duration time) {
      _currentTime = time.inMicroseconds / Duration.microsecondsPerSecond;
      markNeedsPaint();
    });
    _ticker.start();
  }

  @override
  void detach() {
    _ticker.dispose();
    super.detach();
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _beginTracking(globalToLocal(event.position));
    } else if (event is PointerMoveEvent) {
      _continueTracking(globalToLocal(event.position));
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      _endTracking();
    }
  }

  bool _beginTracking(Offset location) {
    _previousLocation = location;
    _vertOffset = 0;
    if (_lowerThumb.contains(location)) {
      _movingLower = true;
      _lowerAnimationStart = 0.0;
      _lowerStartOffset = 0.0;
    } else if (_upperThumb.contains(location)) {
      _movingUpper = true;
      _upperAnimationStart = 0.0;
      _upperStartOffset = 0.0;
    }
    return _movingLower || _movingUpper;
  }

  bool _continueTracking(Offset location) {
    final deltaLocation = (location.dx - _previousLocation.dx);
    final deltaValue = (maxValue - minValue) * deltaLocation / (size.width - thumbSize * 2);
    _previousLocation = location;
    if (_movingLower) {
      lowerValue = (lowerValue + deltaValue).clamp(minValue, maxValue);
      upperValue = math.max(upperValue, lowerValue);
    } else if (_movingUpper) {
      upperValue = (upperValue + deltaValue).clamp(minValue, maxValue);
      lowerValue = math.min(upperValue, lowerValue);
    }
    notifyRangeChanged();
    final touchOffset = (location.dy - size.height / 2.0);
    final touchOffsetVal = touchOffset.abs();
    final double sign = touchOffset.sign;
    double maxVal = stretchRange;
    if (constraintStretch) {
      maxVal = math.min(maxVal, (upperOffset - lowerOffset) / 2.0);
      if (_movingLower) {
        maxVal = math.min(maxVal, lowerOffset / 2.0);
      }
      if (_movingUpper) {
        maxVal = math.min(maxVal, (size.width - upperOffset) / 2.0);
      }
    }
    double offsetVal = (maxVal - 1 / (touchOffsetVal * math.pow(48, -(1.9 + 0.6 * elasticity)) + 1 / maxVal));
    _vertOffset = sign * math.min(offsetVal, touchOffsetVal);
    return true;
  }

  void _endTracking() {
    if (_movingLower) {
      _lowerAnimationStart = _currentTime;
      _lowerStartOffset = _vertOffset;
      notifyRangeChanged();
    }
    if (_movingUpper) {
      _upperAnimationStart = _currentTime;
      _upperStartOffset = _vertOffset;
      notifyRangeChanged();
    }
    _movingLower = false;
    _movingUpper = false;
  }

  void paint(PaintingContext context, Offset offset) {
    _updateThumbPositions();

    final canvas = context.canvas;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    final margin = 2.0; //thumbSize / 2;
    final midY = size.height / 2;
    final pt1 = Offset(margin, midY);
    final pt2 = Offset(margin + lowerOffset, midY + _lowerThumb.center.dy - size.height / 2.0);
    final pt3 = Offset(margin + upperOffset, midY + _upperThumb.center.dy - size.height / 2.0);
    final pt4 = Offset(size.width - margin, midY);

    firstSegment.reset();
    firstSegment.moveTo(pt1.dx, pt1.dy);
    firstSegment.cubicTo(pt1.dx + lowerOffset / 2.0, pt1.dy, pt2.dx + -lowerOffset / 2.0, pt2.dy, pt2.dx, pt2.dy);
    canvas.drawPath(firstSegment, _inactiveTrackPaint);

    final diff = _upperThumb.center.dx - _lowerThumb.center.dx;
    secondSegment.reset();
    secondSegment.moveTo(pt2.dx, pt2.dy);
    secondSegment.cubicTo(pt2.dx + diff / 2.0, pt2.dy, pt3.dx + -diff / 2.0, pt3.dy, pt3.dx, pt3.dy);
    canvas.drawPath(secondSegment, _activeTrackPaint);

    final controlOffset = (size.width - margin * 2 - upperOffset) / 2.0;
    thirdSegment.reset();
    thirdSegment.moveTo(pt3.dx, pt3.dy);
    thirdSegment.cubicTo(pt3.dx + controlOffset, pt3.dy, pt4.dx + -controlOffset, pt4.dy, pt4.dx, pt4.dy);
    canvas.drawPath(thirdSegment, _inactiveTrackPaint);

    canvas.drawCircle(
      _lowerThumb.center,
      _lowerThumb.shortestSide / 2,
      _movingLower ? _activeThumbPaint : _inactiveThumbPaint,
    );
    canvas.drawCircle(_lowerThumb.center, _lowerThumb.shortestSide / 2, _activeTrackPaint);

    canvas.drawCircle(
      _upperThumb.center,
      _upperThumb.shortestSide / 2,
      _movingUpper ? _activeThumbPaint : _inactiveThumbPaint,
    );
    canvas.drawCircle(_upperThumb.center, _upperThumb.shortestSide / 2, _activeTrackPaint);

    canvas.restore();
  }

  void _updateThumbPositions() {
    final timeMultiplier = 2.5 * animationSpeed;

    double lowerVertOffset = (_movingLower ? _vertOffset : 0);
    if (!_movingLower) {
      final elapsedTime = (_currentTime - _lowerAnimationStart) * timeMultiplier;
      lowerVertOffset = _springCoordinate(elapsedTime, _lowerStartOffset);
    }
    lowerVertOffset = _strokeClamp(lowerVertOffset);

    double upperVertOffset = (_movingUpper ? _vertOffset : 0);
    if (!_movingUpper) {
      final elapsedTime = (_currentTime - _upperAnimationStart) * timeMultiplier;
      upperVertOffset = _springCoordinate(elapsedTime, _upperStartOffset);
    }
    upperVertOffset = _strokeClamp(upperVertOffset);

    _lowerThumb = Rect.fromLTWH(lowerOffset, (size.height - thumbSize) / 2.0 + lowerVertOffset, thumbSize, thumbSize);
    _upperThumb = Rect.fromLTWH(upperOffset, (size.height - thumbSize) / 2.0 + upperVertOffset, thumbSize, thumbSize);
  }

  double get lowerOffset => (size.width - thumbSize * 2) * ((lowerValue - minValue) / (maxValue - minValue));

  double get upperOffset =>
      (size.width - thumbSize * 2) * ((upperValue - minValue) / (maxValue - minValue)) + thumbSize;

  static double _springCoordinate(double time, double offset) {
    final m = 6.0;
    final beta = 40.0 / (2 * m);
    final omega0 = (20 + 100 * damping) / m;
    final omega = math.pow(-math.pow(beta, 2) + math.pow(omega0, 2), 0.5);
    return offset * math.exp(-beta * time) * math.cos(omega * time);
  }

  static double _strokeClamp(double value, [double strokeWidth = 2.0]) {
    return (value < -strokeWidth || value > strokeWidth) ? value : 0.0;
  }
}

/*
import 'package:flutter/material.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Create',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<SlidingContainer> pages =[
    SlidingContainer(color: Colors.black, child: Container(), show: true,),
    SlidingContainer(color: Colors.deepOrange, child: Container(),),
    SlidingContainer(color: Colors.blue, child: Container(),),
    SlidingContainer(color: Colors.deepPurple, child: Container(),),
  ];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: pages.map((page){
          return SlidingContainer(
            color: page.color,
            child: page.child,
            pages: pages,
          );
        }).toList(),
      )
    );
  }
}

class SlidingContainer extends StatefulWidget {
  final Widget child;
  final Color color;
  final bool show;
  final List<SlidingContainer> pages;

  SlidingContainer({
    Key key,
    this.color,
    this.child,
    this.pages,
    this.show
  }) : super(key: key);

  @override
  _SlidingContainerState createState() => _SlidingContainerState(
    show: show
  );
}

class _SlidingContainerState
    extends State<SlidingContainer>
    with SingleTickerProviderStateMixin{

  double radialPercent = 20;
  Animation<Offset> radiusAnimation;
  AnimationController controller;
  bool _show;
  final bool show;

  _SlidingContainerState({this.show});

  @override
  void initState() {
    super.initState();
    if(show == true){
      _show = true;
    }else{
      _show = false;
    }

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2)
    );

  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    radiusAnimation = Tween<Offset>(
        begin: Offset(80, 80),
        end: Offset(width, height)
    ).animate(CurvedAnimation(parent: controller, curve: Curves.linear)
    );

    return Visibility(
      visible: true,
      child: GestureDetector(
        onTap: (){
          setState(() {
            controller.forward();
          });
        },
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child){
            return ClipPath(
              clipper: MyClipper(radiusAnimation.value, Position.BOTTOM_RIGHT),
              child: Container(
                child: widget.child,
                color: widget.color,
              ),
            );
          },
        ),
      ),
    );
  }

}

enum Position{
  TOP_CENTER, BOTTOM_CENTER, BOTTOM_RIGHT
}

class MyClipper extends CustomClipper<Path>{

  final double defaultMargin = 0;
  final Offset radialPercent;
  final Position position;
  MyClipper(this.radialPercent, this.position);

  @override
  Path getClip(Size size) {
    final p = Path();

    var radius = (size.height / size.width) + radialPercent.dx *
        radialPercent.dy / 100;


    if(position == Position.BOTTOM_CENTER) {
      var bottomCenter = Offset(size.width /2, size.height - defaultMargin);
      p.addOval(Rect.fromCircle(center: bottomCenter, radius: radius));
    }else if(position == Position.TOP_CENTER){
      var topCenter = Offset(size.width /2, 0);
      p.addOval(Rect.fromCircle(center: topCenter, radius: radius));
    }else if(position == Position.BOTTOM_RIGHT){
      var bottomRight = Offset(size.width, size.height);
      p.addOval(Rect.fromCircle(center: bottomRight, radius: radius));
    }

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

*/
