import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Coffee App",
      home: AuthEntryPage(),
    );
  }
}

enum AuthType { facebook, twitter, google, email }

class AuthEntryPage extends StatelessWidget {

  final imageLinks = <String> [
    'https://www.adamgault.co.uk/wp-content/uploads/2015/11/TradeIndustry038.jpg',
    'https://img.etimg.com/thumb/msid-66650613,width-643,imgsize-801611,resizemode-4/coffee.jpg',
    'https://img.etimg.com/thumb/msid-66650613,width-643,imgsize-801611,resizemode-4/coffee.jpg',
  ];

  final authTypes = <AuthType>[
    AuthType.facebook,
    AuthType.twitter,
    AuthType.google,
    AuthType.email
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height /1.2,
              child: PageView(
                children: imageLinks.map((link) {
                  return PageViewItem(
                    imageUrl: link,
                  );
                }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text("Sign in to continue".toUpperCase()),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: authTypes.map((authType){
                return _SocialButton(
                  authType: authType,
                  onPressed: () {
                    if(authType == AuthType.email) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AuthPage()
                        )
                      );
                    }
                  },
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}

class AuthPage extends StatefulWidget {

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
  with SingleTickerProviderStateMixin {
  TabController _tabController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height/2.1,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16)
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage('https://www.adamgault.co.uk/wp-content/uploads/2015/11/TradeIndustry038.jpg')
                )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                      child: Icon(
                        currentIndex == 0 ? Icons.person : Icons.group_add,
                        color: Colors.white,),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: <Widget>[
                        Text('Sign in'.toUpperCase()),
                        Text('Sign up'.toUpperCase())
                      ],
                    ),
                  )
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height/1.9,
              width: MediaQuery.of(context).size.width,
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  LoginContent(),
                  RegistrationContent()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 490,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          const Spacer(),
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Email Address',
              icon: Icon(Icons.email, color: Colors.brown,)
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Password',
                  icon: Icon(Icons.lock, color: Colors.brown,),
                  suffixIcon: Text('Forgot?', style: TextStyle(color: Colors.grey),)
              ),
            ),
          ),

          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.arrow_back),
                      Text('Social Login')
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {/*TODO: perform login operation*/},
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.brown,
                      shape: BoxShape.circle
                    ),
                    child: Center(child:
                    Icon(Icons.arrow_forward, color: Colors.white,),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RegistrationContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 490,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          const Spacer(),
          TextField(
            decoration: InputDecoration(
              hintText: 'Name',
              icon: Icon(Icons.person, color: Colors.brown,)
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Email Address',
                  icon: Icon(Icons.email, color: Colors.brown,)
              ),
            ),
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'Password',
                icon: Icon(Icons.lock, color: Colors.brown,),
                suffixIcon: Text('Forgot?', style: TextStyle(color: Colors.grey),)
            ),
          ),

          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.arrow_back),
                      Text('Social Login')
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {/*TODO: perform login operation*/},
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.brown,
                        shape: BoxShape.circle
                    ),
                    child: Center(child:
                    Icon(Icons.arrow_forward, color: Colors.white,),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}




class _SocialButton extends StatelessWidget {
  final AuthType authType;
  final VoidCallback onPressed;

  const _SocialButton({Key key,
    @required this.authType,
    @required this.onPressed
  }) : assert(authType != null),
      assert(onPressed != null);

  Widget _getChild() {
    switch(authType) {
      case AuthType.facebook:
        return Icon(Icons.camera);
      case AuthType.twitter:
        return Icon(Icons.wb_cloudy);
      case AuthType.google:
        return Icon(Icons.wb_sunny);
      case AuthType.email:
        return Text("Email".toUpperCase());
    }
    throw Exception('Invalid Auth Type');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(right: 16, left: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(32)
        ),
        child: _getChild(),
      ),
    );
  }
}


class PageViewItem extends StatelessWidget {
  final String imageUrl;

  const PageViewItem({Key key,
    @required this.imageUrl
  }) : assert(imageUrl != null),
      assert(imageUrl != '');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        color:  Colors.black54,
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imageUrl)
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Coffee Beans".toUpperCase(),
            style: TextStyle(color: Colors.white, fontSize: 42),),
          Text('Monthly Subscriptions'.toUpperCase(),
          style: TextStyle(color: Colors.white, fontSize: 18),),
          const Spacer(),
          Text('I am a coffee fanatic. Once you go to proper coffee you can\'t go back. You cannot go back.',
            style: TextStyle(color: Colors.white),),
        ],
      ),
    );
  }
}

