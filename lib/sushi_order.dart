import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MaterialApp(home: SushiOrderPage()));

enum SushiSize { S, M, L }

final random = Random();

final cardColor = Color(0xFF151f2b);
Color backgroundColor = Colors.blueGrey;

class SushiOrderPage extends StatefulWidget {
  @override
  _SushiOrderPageState createState() => _SushiOrderPageState();
}

class _SushiOrderPageState extends State<SushiOrderPage> {

  List<SushiListItem> sushiList = [];
  SushiListItem selectedItem;

  void populateSushiList() {
    if (sushiList != null && sushiList.isNotEmpty) {
      return;
    }

    for (int i = 0; i < ImageUtils.sushiAssets.keys.length; i++)
      sushiList.add(
        SushiListItem(
          name: ImageUtils.sushiAssets.keys.elementAt(i),
          price: 122.0 * (i + 1),
          size: SushiSize.values[random.nextInt(SushiSize.values.length)],
          startsCount: random.nextInt(5),
          ingredients: ImageUtils.sushiIngredientsAssets,
          image: ImageUtils.sushiAssets.values.elementAt(i),
        ),
      );
  }

  void onItemSelected(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return SushiDetailsPage(item: selectedItem);
    }));
  }

  @override
  void initState() {
    super.initState();
    populateSushiList();
    selectedItem = sushiList[0];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backgroundCardHeight = size.height * .85;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: size.width * .8,
                height: backgroundCardHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.width / 2),
                  gradient: LinearGradient(
                      colors: [
                        backgroundColor,
                        cardColor.withOpacity(.5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [.33, 1]
                  ),
                ),
              ),
            ),
            SushiList(
              items: sushiList,
              onItemChanged: (index) {
                if (index == 5 && backgroundColor != Colors.black) {
                  setState(() {
                    backgroundColor = Colors.black;
                  });
                }
                setState(() => selectedItem = sushiList[index]);
              },
              onItemTap: (_) => onItemSelected(context),
            ),
            Center(
              child: SushiInfoWidget(
                topPadding: size.height * .63,
                item: selectedItem,
              ),
            ),
            Positioned(
              top: backgroundCardHeight,
              left: size.width * .43,
              child: GestureDetector(
                onTap: () => onItemSelected(context),
                child: const FireButton(),
              ),
            ),
            CustomAppBar(
              title: "Order Manually",
              showLocation: true,
            ),
          ],
        ),
      ),
    );
  }
}

class SushiList extends StatefulWidget {
  final List<SushiListItem> items;
  final ValueChanged<int> onItemChanged;
  final ValueChanged<int> onItemTap;

  const SushiList({Key key, this.onItemChanged, this.onItemTap, this.items}) : super(key: key);

  @override
  _SushiListState createState() => _SushiListState();
}

class _SushiListState extends State<SushiList> {
  double scrollOffset = 0;
  PageController _controller;

  List<SushiListItem> get items => widget.items;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: scrollOffset.round(),
      viewportFraction: .635,
    );
    _controller.addListener(() {
      setState(() => scrollOffset = _controller.page);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: items.length,
      controller: _controller,
      onPageChanged: widget.onItemChanged,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final item = items[index];
        double gaussAlignment = math.exp(-math.pow(scrollOffset - index, -4) / items.length);
        bool fromLeft = scrollOffset >= index;

        return Align(
          alignment: Alignment(0, gaussAlignment),
          child: Transform.rotate(
            angle: fromLeft ? gaussAlignment * .9 : -(gaussAlignment * .9),
            child: GestureDetector(
              onTap: () => widget.onItemTap(index),
              child: Hero(
                tag: ObjectKey(item.name),
                child: Container(
                  width: 190 - (gaussAlignment * 5),
                  height: 190 - (gaussAlignment * 5),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          alignment: Alignment(0, gaussAlignment),
                          image: AssetImage(item.image)
                      )
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SushiInfoWidget extends StatelessWidget {
  final SushiListItem item;
  final bool isFoodDetailsPage;
  final double topPadding;

  const SushiInfoWidget({ this.item,
    this.isFoodDetailsPage = false,
    @required this.topPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: topPadding),
        if (!isFoodDetailsPage)
          ...[
            Text(item.name,
              style:  Theme.of(context).textTheme.headline6.copyWith(
                fontSize: 26,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  bool selected = index <= item.startsCount;
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(Icons.star, size: 18,
                      color: selected ? Colors.white70 : Colors.white24,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        TweenAnimationBuilder<double>(
          duration: !isFoodDetailsPage ? Duration(milliseconds: 500) : Duration.zero,
          tween: Tween<double>(begin: 0.0, end: item.price),
          builder: (context, value, child) {
            return Text("\$${value.round()}",
              style:  Theme.of(context).textTheme.headline6.copyWith(
                fontSize: isFoodDetailsPage ? 42 : 36,
                fontWeight: FontWeight.w900,
              ),);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * .4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: SushiSize.values.map((e) {
                return AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 500),
                  style: TextStyle(color: e == item.size ? Colors.white : Colors.white24),
                  child: Text(e.getName()),
                );
              }).toList(),
            ),
          ),
        ),
        if (isFoodDetailsPage)
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: SizedBox(
              height: 80,
              width: MediaQuery.of(context).size.width * .8,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                children: item.ingredients.map((name) {
                  return Container(
                    width: 75,
                    height: 100,
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(name),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showLocation;
  final bool showBackButton;

  const CustomAppBar({Key key, this.title,this.showBackButton = false, this.showLocation = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(showBackButton)
                BackButton(),
              Text(title, style:  Theme.of(context).textTheme.headline6.copyWith(
                  fontSize: 26,
                  color: Colors.white
              ),),
              IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
            ],
          ),
          Visibility(
            visible: showLocation,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(Icons.location_on, size: 18,),
                ),

                Text("Luanda, Angola", style:  Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.white
                ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SushiDetailsPage extends StatelessWidget {
  final SushiListItem item;

  const SushiDetailsPage({this.item});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backgroundCardHeight = size.height * .85;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                width: size.width * .9,
                height: backgroundCardHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                      colors: [
                        backgroundColor,
                        cardColor.withOpacity(.5),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [.33, 1]
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, -.5),
              child: Hero(
                tag: ObjectKey(item.name),
                child: Container(
                  width: 250,
                  height: 250,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(item.image)
                      )
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment(0, -10),
                child: SushiInfoWidget(
                  topPadding: size.height * .48,
                  item: item,
                  isFoodDetailsPage: true,
                )),
            Positioned(
              left: size.width / 2 - 25,
              top: backgroundCardHeight,
              child: const FireButton(),
            ),
            CustomAppBar(
              title: item.name,
              showBackButton: true,
            ),
          ],
        ),
      ),
    );
  }
}

class FireButton extends StatelessWidget {

  const FireButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(4)
      ),
      child: Icon(Icons.whatshot, color: cardColor),
    );
  }
}

extension on SushiSize {

  String getName() {
    switch(this) {
      case SushiSize.M:
        return 'M';
      case SushiSize.S:
        return 'S';
      case SushiSize.L:
        return 'L';
    }
    throw UnimplementedError('Invalid Sushi size');
  }
}

class SushiListItem {
  final double price;
  final List<String> ingredients;
  final int startsCount;
  final String name;
  final String image;
  final SushiSize size;

  SushiListItem({
    @required this.price,
    @required this.ingredients,
    @required this.startsCount,
    @required this.name,
    @required this.image,
    @required this.size,
  });
}

class ImageUtils {
  static const imageUrls = <String> [
    'https://unsplash.com/photos/h_OlVMnlgVo/download?force=true&w=2400',
    //'https://unsplash.com/photos/6WysHvxpQEQ/download?force=true',
    //'https://unsplash.com/photos/_Vm8XWJ9UaQ/download?force=true',
    //'https://unsplash.com/photos/164_6wVEHfI/download?force=true&w=2400',
    //'https://unsplash.com/photos/KbMwBSjsvrs/download?force=true&w=2400',
    'https://unsplash.com/photos/LJD6U920zVo/download?force=true&w=2400',
    'https://unsplash.com/photos/mK8EirNAvag/download?force=true&w=2400',
    'https://unsplash.com/photos/IKJrYtdFku8/download?force=true&w=2400',
    'https://unsplash.com/photos/BlMj6RYy3c0/download?force=true&w=2400',
    'https://unsplash.com/photos/rXJXsecq8YU/download?force=true&w=2400',
    'https://unsplash.com/photos/6LdtPuAVGao/download?force=true&w=2400',
  ];
  static const imageAssets = <String> [
    'assets/images/img.jpg',
    'assets/images/img42.jpg',
    'assets/images/img.jpg',
  ];

  static const sushiAssets = <String, String>{
    'Gunkan Maki2': 'assets/images/sushi1.png',
    'Surf and Turf Roll': 'assets/images/sushi1.png',
    'Tempura Roll': 'assets/images/sushi4.png',
    'Rainbow Roll': 'assets/images/sushi2.png',
    'California Roll': 'assets/images/sushi5.png',
    'Unagi Sushi': 'assets/images/sushi6.png',
    'Gunkam Maki': 'assets/images/sushi1.png',
    'Surf and Sturf Roll': 'assets/images/sushi3.png',
    'Tempural Roll': 'assets/images/sushi4.png',
    'Rainbow Roll Surf': 'assets/images/sushi2.png',
    'California Sushi': 'assets/images/sushi5.png',
    'Unaggi Sushi': 'assets/images/sushi6.png',
  };

  static const sushiIngredientsAssets = <String>[
    'assets/images/ig1.png',
    'assets/images/ig2.png',
    'assets/images/ig3.png',
    'assets/images/ig1.png',
  ];

  static final games = <Game>[
    Game(
        "https://pplware.sapo.pt/wp-content/uploads/2018/05/GoW_1.jpg",
        "https://cosmonerd.com.br//uploads/2018/04/god_of_war_kratos_and_atreus-HD-1.jpg"
    ),
    Game(
        "https://image.api.playstation.com/vulcan/ap/rnd/202008/1318/8XGEPtD1xoasK0FYkYNcCn1z.png",
        "https://olhardigital.com.br/wp-content/uploads/2020/09/20200909050522.jpg"
    ),
    Game(
        "https://upload.wikimedia.org/wikipedia/pt/e/eb/Death-Stranding-poster.jpg",
        "https://miro.medium.com/max/1200/1*bqWi16eKaYYRZsLKxKDy1A.jpeg"
    ),
  ];

  static final sizes = <Size>[
    Size(5472,2334),
    Size(5472,3648),
  ];
}