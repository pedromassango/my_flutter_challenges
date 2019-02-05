import 'package:flutter/material.dart';

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

class _MyHomePageState extends State<MyHomePage> {

  final String url = 'https://static.independent.co.uk/s3fs-public/thumbnails/image/2018/09/04/15/lionel-messi-0.jpg?';
  final Color green = Color(0xFF1E8161);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        backgroundColor: green,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: (){},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){},
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/2,
            decoration: BoxDecoration(
              color: green,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(32),
                bottomLeft: Radius.circular(32)
              ),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        children: <Widget>[
                          Text('Familiar',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                          Text('12',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(url)
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: <Widget>[
                          Text('Following',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                          Text('18',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10
                  ),
                  child: Text("ID: 14552566",
                  style: TextStyle(
                    color: Colors.white70
                  ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 32),
                  child: Text('Herman Jimenez',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(Icons.group_add, color: Colors.white,),
                          Text('Friends',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(Icons.group, color: Colors.white,),
                          Text('Groups',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(Icons.videocam, color: Colors.white,),
                          Text('Videos',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Icon(Icons.favorite, color: Colors.white,),
                          Text('Likes',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height/3,
            padding: EdgeInsets.all(42),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(Icons.table_chart, color: Colors.grey,),
                        Text('Leaders',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold
                        ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(Icons.show_chart, color: Colors.grey,),
                        Text('Level up',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(Icons.card_giftcard, color: Colors.grey,),
                        Text('Leaders',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(Icons.code, color: Colors.grey,),
                        Text('QR code')
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(Icons.blur_circular, color: Colors.grey,),
                        Text('Daily bonus')
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(Icons.visibility, color: Colors.grey,),
                        Text('Visitors')
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
