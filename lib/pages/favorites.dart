import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:marvel_gallery/pages/details.dart';
import 'package:marvel_gallery/services/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorites extends StatefulWidget {
  final bool darkMode;
  const Favorites({Key key, this.darkMode}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  SharedPreferences pref;
  bool isOpen = true;

  List<String> favorites = [];
  List<MarvelInfos> filter = [];

  List<Color> bodyLight = [Color(0xff850D00), Color(0xffB81300), Color(0xffB81300), Color(0xff850D00)];
  List<Color> bodyDark = [Color(0xff2F2F2F), Color(0xff484848), Color(0xff484848), Color(0xff2F2F2F)];

  @override
  // ignore: must_call_super
  initState() {
    sharedPref();
    if (mounted) {
      Timer(Duration(milliseconds: 2000), () {
        setState(() {
          isOpen = !isOpen;
        });
      });
    }
  }

  void sharedPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      favorites = pref.getStringList('favorites') != null ? pref.getStringList('favorites') : [];
      filter = marvels.where((element) {
        return favorites.contains(element.id.toString());
      }).toList();
    });
  }

  Future<Function> setFavorites(list) async {
    setState(() {
      favorites = list;
      filter = marvels.where((element) {
        return favorites.contains(element.id.toString());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double heightCards = height - 160;
    double heightImage = height - 380;

    return !isOpen
        ? Scaffold(
            backgroundColor: !widget.darkMode ? Color(0xff850D00) : Color(0xff2F2F2F),
            body: SafeArea(
              child: ListView(
                children: <Widget>[
                  Container(
                    height: height - 49,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: !widget.darkMode ? bodyLight : bodyDark,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.2, 0.8, 1.8],
                      ),
                    ),
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
                                    'Favorites',
                                    style: TextStyle(
                                      fontFamily: 'Avenir',
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20.0,
                                      child: Icon(
                                        Icons.close,
                                        color: !widget.darkMode ? Color(0xff850D00) : Color(0xff2F2F2F),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (filter.length == 0)
                          Container(
                            height: heightCards,
                            child: Text(
                              'No Favorites Found',
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                fontSize: 20,
                                color: !widget.darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        if (filter.length != 0)
                          Container(
                            height: heightCards,
                            child: new Swiper(
                              controller: new SwiperController(),
                              itemCount: filter.length,
                              viewportFraction: 0.9,
                              scale: 0.8,
                              autoplay: false,
                              curve: Curves.easeInOut,
                              pagination: new SwiperPagination(
                                alignment: Alignment.bottomCenter,
                                builder: SwiperPagination(
                                  margin: EdgeInsets.only(top: 0.0),
                                  builder: DotSwiperPaginationBuilder(
                                      color: Colors.grey[500], activeColor: Colors.white, size: 10.0, activeSize: 15.0, space: 5.0),
                                ),
                              ),
                              itemBuilder: (context, index) {
                                int key = filter[index].id + 1;
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: Duration(milliseconds: 300),
                                        pageBuilder: (context, a, b) => Details(
                                          marvelInfos: filter[index],
                                          keyIndex: key,
                                          darkMode: widget.darkMode,
                                          setFavorites: setFavorites,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 40.0),
                                    child: Card(
                                      color: !widget.darkMode ? Color(0xffFFFFFF) : Color(0xff2F2F2F),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      child: Stack(
                                        children: <Widget>[
                                          Positioned(
                                            top: heightCards / 1.63,
                                            left: key.toString().length == 1 ? width / 2 : width / 6,
                                            child: Text(
                                              key.toString(),
                                              style: TextStyle(
                                                fontSize: key.toString().length == 1 ? heightCards / 2.5 : heightCards / 2.5,
                                                fontFamily: 'avenir',
                                                fontWeight: FontWeight.w900,
                                                color: !widget.darkMode ? Colors.grey.withOpacity(0.2) : Color(0xffFFFFFF).withOpacity(0.2),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                height: heightCards - 48,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Hero(
                                                        tag: key,
                                                        child: Center(
                                                          child: Image.asset(
                                                            filter[index].iconImage,
                                                            height: heightImage,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: width,
                                                        padding: const EdgeInsets.all(15.0),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Text(
                                                              filter[index].codeName,
                                                              style: TextStyle(
                                                                  fontFamily: 'Avenir',
                                                                  fontSize: 35,
                                                                  color: !widget.darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                                                                  fontWeight: FontWeight.w900),
                                                              textAlign: TextAlign.left,
                                                            ),
                                                            if (filter[index].name != null) SizedBox(height: 5),
                                                            if (filter[index].name != null)
                                                              Text(
                                                                '${filter[index].name.toUpperCase()}',
                                                                style: TextStyle(
                                                                  fontFamily: 'Avenir',
                                                                  fontSize: 15,
                                                                  color: !widget.darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                            SizedBox(height: 15),
                                                            if (filter[index].icon == 1)
                                                              CircleAvatar(
                                                                backgroundColor: Colors.transparent,
                                                                backgroundImage: AssetImage('assets/avengers.png'),
                                                                radius: 30.0,
                                                              ),
                                                            if (filter[index].icon == 2)
                                                              CircleAvatar(
                                                                backgroundColor: Colors.transparent,
                                                                backgroundImage: AssetImage('assets/xmen.png'),
                                                                radius: 30.0,
                                                              ),
                                                            if (filter[index].icon == 3)
                                                              CircleAvatar(
                                                                backgroundColor: Colors.transparent,
                                                                backgroundImage: AssetImage('assets/gotg.png'),
                                                                radius: 30.0,
                                                              ),
                                                            if (filter[index].icon == 4)
                                                              CircleAvatar(
                                                                backgroundColor: Colors.transparent,
                                                                backgroundImage: AssetImage('assets/avengers-villain.png'),
                                                                radius: 30.0,
                                                              ),
                                                            if (filter[index].icon == 5)
                                                              CircleAvatar(
                                                                backgroundColor: Colors.transparent,
                                                                backgroundImage: AssetImage('assets/xmen-villain.png'),
                                                                radius: 30.0,
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Positioned(
                                            top: 10,
                                            left: width - 100,
                                            child: Icon(
                                              (favorites.contains(filter[index].id.toString()) ? Icons.star : Icons.star_border_outlined),
                                              size: 40.0,
                                              color: favorites.contains(filter[index].id.toString())
                                                  ? (!widget.darkMode ? Color(0xffB81300) : Color(0xffFFFFFF))
                                                  : (!widget.darkMode ? Colors.grey.withOpacity(0.2) : Color(0xffFFFFFF).withOpacity(0.2)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: !widget.darkMode ? bodyLight : bodyDark,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.2, 0.8, 1.8]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width / 2.5,
                    child: Image.asset('assets/marvel-logo.png'),
                  ),
                ],
              ),
            ),
          );
    ;
  }
}
