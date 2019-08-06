import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(SearchAppBar());

class SearchAppBar extends StatefulWidget {
  @override
  _SearchAppBarState createState() => new _SearchAppBarState();
}

String url = "https://image.iol.co.za/image/1/process/620x349?source=https://cdn.africannewsagency.com/public/ana/media/media/2019/05/15/1557888547382.jpg&operation=CROP&offset=0x41&resize=2999x1679";

class _SearchAppBarState extends State<SearchAppBar> {
  String appTitle = "AppBar Title";

  bool isSearchEnabled = true;

  _switchSearchBarState(){
    setState(() {
      isSearchEnabled = !isSearchEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new  MaterialApp(
      title: "My App 2019",
      home: Scaffold(
        appBar: AppBar(
            elevation: 1,
            bottomOpacity: 0.5,
            title: Text("About"),
        ),
        body: ClipPath(
          clipper: MyClip(),
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Color(0xFF1D5D51),
                        BlendMode.color,
                    ),
                  fit: BoxFit.fitHeight,
                  image: NetworkImage(url)
                )
              ),
            ),
        ),
      ),
    );
  }
}

class MyClip extends CustomClipper<Path>{

  @override
  Path getClip(Size size) {
    Path p = Path();

    p.lineTo(0, size.height);
    p.lineTo(size.width, size.height/2);

    p.lineTo(size.width, 0);

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}