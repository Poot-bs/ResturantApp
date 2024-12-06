import 'dart:convert';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

var bannerItems = ["Burger", "Cheese Chilly", "Noodles", "Pizza"];
var bannerImages = [
  "images/burger.jpg",
  "images/cheesechilly.jpg",
  "images/noodles.jpg",
  "images/pizza.jpg"
];

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  Future<List<Widget>> createList() async {
    List<Widget> items = [];
    try {
      String dataString =
          await DefaultAssetBundle.of(context).loadString("assets/data.json");
      List<dynamic> dataJSON = jsonDecode(dataString);
      dataJSON.forEach((object) {
        String finalString = "";
        List<dynamic> dataList = object["placeItems"];
        dataList.forEach((item) {
          finalString = finalString + item + " | ";
        });
        items.add(Padding(
          padding: EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            margin: EdgeInsets.all(5.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  child: Image.asset(
                    object['placeImage'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          object["placeName"],
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                        ),
                        Text(
                          finalString,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Min. Order: ${object["minOrder"]}",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      });
    } catch (e) {
      print("Error: $e");
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Orders'),
              onTap: () {
                Navigator.pop(context);
                print('Orders tapped');
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                print('Favorites tapped');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                print('Settings tapped');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                print('Logout tapped');
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Foodies",
                    style: TextStyle(fontSize: 100, fontFamily: "Samantha"),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BannerWidgetArea(),
                      Container(
                        child: FutureBuilder<List<Widget>>(
                          initialData: <Widget>[Text("")],
                          future: createList(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: ListView(
                                  primary: false,
                                  shrinkWrap: true,
                                  children: snapshot.data!,
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text("Error loading data");
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SpeedDial(
        icon: Icons.fastfood,
        activeIcon: Icons.close,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        buttonSize: const Size(56.0, 56.0),
        elevation: 6.0,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            child: Icon(Icons.shopping_cart, color: Colors.white),
            backgroundColor: Colors.blue,
            label: 'Order',
            labelStyle: TextStyle(fontSize: 14, color: Colors.white),
            labelBackgroundColor: Colors.blue,
            onTap: () => print("Order Tapped"),
          ),
          SpeedDialChild(
            child: Icon(Icons.favorite, color: Colors.white),
            backgroundColor: Colors.red,
            label: 'Favorites',
            labelStyle: TextStyle(fontSize: 14, color: Colors.white),
            labelBackgroundColor: Colors.red,
            onTap: () => print("Favorites Tapped"),
          ),
          SpeedDialChild(
            child: Icon(Icons.contact_support, color: Colors.white),
            backgroundColor: Colors.green,
            label: 'Support',
            labelStyle: TextStyle(fontSize: 14, color: Colors.white),
            labelBackgroundColor: Colors.green,
            onTap: () => print("Support Tapped"),
          ),
        ],
      ),
    );
  }
}

class BannerWidgetArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    PageController controller =
        PageController(viewportFraction: 0.8, initialPage: 1);
    List<Widget> banners = [];

    for (int x = 0; x < bannerItems.length; x++) {
      var bannerView = Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(2.0, 2.0),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    )
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Image.asset(
                  bannerImages[x],
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bannerItems[x],
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                    Text(
                      "More Than 40% Off",
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      banners.add(bannerView);
    }

    return Container(
      height: screenWidth * 9 / 16,
      width: screenWidth,
      child: PageView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        children: banners,
      ),
    );
  }
}
