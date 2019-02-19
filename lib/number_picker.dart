import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Number Picker",
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Picker"),
      ),
      body: Container(
        child: Center(
          child: MaterialButton(
            child: Text("Open Picker"),
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (c) => PickerPage()),
                ),
          ),
        ),
      ),
    );
  }
}

class PickerPage extends StatefulWidget {
  @override
  _PickerPageState createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  final FixedExtentScrollController scrollController =
      new FixedExtentScrollController(initialItem: 1);

  @override
  void initState(){
    super.initState();

  }

  Widget _buildSampleOne(double width, double height){
    return Row(
      children: <Widget>[
        Container(
          height: height,
          width: width/2,
          child: CupertinoPicker.builder(
            key: ObjectKey("tt1"),
            scrollController: scrollController,
            itemExtent: 100,
            childCount: 30,
            onSelectedItemChanged: (i){},
            itemBuilder: (c, index){
              return Text('${(index+1).toString().padLeft(2, "0")}', style: TextStyle(color: Colors.deepPurple, fontSize: 100),);
            },
          ),
        ),
        Container(
          key: ObjectKey("t3"),
          height: height,
          width: width/2,
          child: CupertinoPicker.builder(
            scrollController: scrollController,
            itemExtent: 100,
            childCount: 30,
            useMagnifier: true,
            magnification: 1,
            offAxisFraction: 1,
            backgroundColor: Colors.white,
            diameterRatio: 50,
            onSelectedItemChanged: (i){},
            itemBuilder: (c, index){
              return Text(':${(index+1).toString().padLeft(2, "0")}', style: TextStyle(color: Colors.deepPurple, fontSize: 100),);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _buildSampleOne(width, height),
    );
  }
}
