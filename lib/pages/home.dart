import 'package:flutter/material.dart';
import 'package:marvel_gallery/pages/details.dart';
import 'package:marvel_gallery/services/data.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Home extends StatefulWidget {
  // Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[400],
      body: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.red[400], Colors.orange[400]],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.3, 0.7]),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Marvel',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage('assets/pic.jpg'),
                              radius: 20.0,
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('Heroes/Villains',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Avenir',
                                )),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 450,
                    child: new Swiper(
                      controller: new SwiperController(),
                      itemCount: marvels.length,
                      viewportFraction: 0.7,
                      scale: 0.6,
                      autoplay: false,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, a, b) =>
                                      Details(marvelInfos: marvels[index]),
                                ));
                          },
                          child: Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Colors.white.withOpacity(0.3),
                                          blurRadius: 20.0,
                                          offset: Offset(0, 15))
                                    ]),
                                    child: Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(25.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Hero(
                                              tag: marvels[index].position,
                                              child: Center(
                                                  child: Image.asset(
                                                marvels[index].iconImage,
                                                height: 250,
                                              )),
                                            ),
                                            Text(
                                              marvels[index].name,
                                              style: TextStyle(
                                                  fontFamily: 'Avenir',
                                                  fontSize: 20,
                                                  color: Colors.grey[800],
                                                  fontWeight: FontWeight.w900),
                                              textAlign: TextAlign.left,
                                            ),
                                            SizedBox(height: 5),
                                            Text(marvels[index].type,
                                                style: TextStyle(
                                                  fontFamily: 'Avenir',
                                                  fontSize: 15,
                                                  color: Colors.grey[800],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.left),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                                child: Container(
                                              width: 45,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: Colors.red[400],
                                              ),
                                              child: Icon(Icons.arrow_forward,
                                                  color: Colors.white),
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Positioned(
                                top:
                                    marvels[index].position.toString().length ==
                                            1
                                        ? 280
                                        : 310,
                                left:
                                    marvels[index].position.toString().length ==
                                            1
                                        ? 170
                                        : 148,
                                child: Text(
                                  marvels[index].position.toString(),
                                  style: TextStyle(
                                      fontSize: marvels[index]
                                                  .position
                                                  .toString()
                                                  .length ==
                                              1
                                          ? 100
                                          : 75,
                                      fontFamily: 'avenir',
                                      fontWeight: FontWeight.w900,
                                      color: Colors.grey.withOpacity(0.4)),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              iconSize: 28,
              color: Colors.grey[850],
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search),
              iconSize: 28,
              color: Colors.grey[850],
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.supervised_user_circle_outlined),
              iconSize: 28,
              color: Colors.grey[850],
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
