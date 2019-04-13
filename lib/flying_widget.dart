import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flying Item",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
  with SingleTickerProviderStateMixin{

  List<String> items = List.generate(10, ((i){ return "Item $i"; }));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 1.1,
        backgroundColor: Colors.white,
        leading: Icon(Icons.menu, color: Colors.grey,),
        title: Center(
          child: Text("STORE", style: TextStyle(
            color: Colors.grey[500]
          ),),
        ),
        actions: <Widget>[
          Icon(Icons.search, color: Colors.grey)
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (c, ch){
            return CartItem();
          },
        ),
      ),
    );
  }

}

class CartItem extends StatefulWidget {
  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem>
    with TickerProviderStateMixin {


  Duration _duration = Duration(seconds: 2);

  double _size = 180;
  Animation<double> _delayedAnimation;
  Animation<double> _opacityAnimation;
  AnimationController _animationController;
  AnimationController _opacityController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 2000)
    );

    _opacityController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400)
    );


    _opacityAnimation = Tween<double>(
      begin: 1, //TODO: set this value back to 1
      end: 0
    ).animate(
      CurvedAnimation(
        parent: _opacityController,
        curve: Curves.linear
      )
    )..addStatusListener((status){
      if(status == AnimationStatus.completed){
        _animationController.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _delayedAnimation = Tween<double>(
        begin: 10,
        end: MediaQuery.of(context).size.width
    )
        .animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(
                0.0, 1.0,
                curve: Curves.bounceInOut
            )
        ))
      ..addStatusListener((status){
      if(status == AnimationStatus.completed){
        _size = 0;
        setState(() {});
      }
    });

    return GestureDetector(
      onTap: (){
        _animationController.forward();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 300,
        height: _size,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animationController,
              builder: (c, ch){
                return Positioned(
                  left: _delayedAnimation.value,
                  child: Icon(Icons.shopping_cart, size: 90, color: Colors.redAccent,),
                );
              },
            ),

            AnimatedBuilder(
              animation: _opacityController,
              builder: (c, ch){
                return Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      width: double.maxFinite,
                      height: 200,
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[300],
                                blurRadius: 1
                            )
                          ]
                      ),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _buildImagePlaceHolder(),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _buildRowPlaceHolder(),
                              _buildRowPlaceHolder(width: 150),
                              _buildRowPlaceHolder(width: 180),
                              Spacer(),
                              _buildButtonPlaceHolder()
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonPlaceHolder(){
    return Padding(
      padding: const EdgeInsets.only(left: 100),
      child: MaterialButton(
        elevation: 1,
        color: Colors.redAccent[100],
        onPressed: (){
          _opacityController.forward();
        },
      ),
    );
  }

  Widget _buildImagePlaceHolder(){
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: Container(
        width: 125,
        height: double.maxFinite,
        color: Colors.grey[200],
      ),
    );
  }

  Widget _buildRowPlaceHolder({double width = 120}){
    return Container(
      width: width,
      height: 15,
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(8))
      ),
    );
  }
}

