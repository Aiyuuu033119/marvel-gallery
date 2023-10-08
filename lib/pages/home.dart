import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:marvel_gallery/pages/details.dart';
import 'package:marvel_gallery/pages/favorites.dart';
import 'package:marvel_gallery/pages/search.dart';
import 'package:marvel_gallery/services/data.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';

class Home extends StatefulWidget {
  // Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences pref;

  bool darkMode = false;
  bool isLoading = false;
  bool isOpen = true;

  int currentNav = 1;

  List<String> favorites = [];

  List<MarvelInfos> marvelInfos = [];

  SwiperController swiper = new SwiperController();

  @override
  // ignore: must_call_super
  initState() {
    sharedPref();
    if (mounted) {
      setState(() {
        marvelInfos = marvels;
      });
      Timer(Duration(milliseconds: 2000), () {
        _dialogBuilder(context);
      });

      Timer(Duration(milliseconds: 3000), () {
        setState(() {
          darkMode = !darkMode;
          isOpen = !isOpen;
        });
        Navigator.pop(context);
      });
    }
  }

  void sharedPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      favorites = pref.getStringList('favorites') != null ? pref.getStringList('favorites') : [];
      darkMode = pref.getBool('darkMode') != null ? !(pref.getBool('darkMode')) : true;
    });
  }

  void star(index) {
    if (favorites.contains(marvels[index].id.toString())) {
      setState(() {
        favorites.removeWhere((element) => element == marvels[index].id.toString());
        pref.setStringList('favorites', favorites);
      });
    } else {
      setState(() {
        favorites.add(marvels[index].id.toString());
        pref.setStringList('favorites', favorites);
      });
    }
  }

  Future<Function> setFavorites(list) async {
    setState(() {
      favorites = list;
    });
  }

  List<Color> bodyLight = [Color(0xff850D00), Color(0xffB81300), Color(0xffB81300), Color(0xff850D00)];
  List<Color> bodyDark = [Color(0xff2F2F2F), Color(0xff484848), Color(0xff484848), Color(0xff2F2F2F)];

  List<String> option = ['Heroes/Villains', 'Heroes', 'Villains', 'Avengers', 'Defenders', 'X-Men', 'Guardians of the Galaxy'];
  int optionActive = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double heightCards = height - 280;
    double heightImage = height - 500;

    return !isOpen
        ? Scaffold(
            backgroundColor: !darkMode ? Color(0xff850D00) : Color(0xff2F2F2F),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: GestureDetector(
              onTap: () {
                swiper.next();
              },
              child: Container(
                color: Colors.transparent,
                height: 70.0,
                width: 56.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20.0,
                    ),
                  ],
                ),
              ),
            ),
            body: SafeArea(
              child: ListView(
                children: <Widget>[
                  Container(
                    height: height - 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: !darkMode ? bodyLight : bodyDark,
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
                                    'Marvel',
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
                                      _dialogBuilder(context);

                                      Timer(Duration(milliseconds: 300), () {
                                        setState(() {
                                          darkMode = !darkMode;
                                          pref.setBool('darkMode', darkMode);
                                          currentNav = 0;
                                          isLoading = true;
                                        });
                                      });

                                      Timer(Duration(milliseconds: 400), () {
                                        setState(() {
                                          currentNav = 1;
                                          isLoading = false;
                                        });
                                      });

                                      Timer(Duration(milliseconds: 1500), () {
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: AssetImage(darkMode == true ? 'assets/icon-sun.png' : 'assets/icon-moon.png'),
                                      radius: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      _bottomSheetBuilder(context);
                                    },
                                    child: Text(option[optionActive],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'Avenir',
                                        )),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: heightCards,
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Builder(
                            builder: (context) {
                              return marvelInfos.length == 0
                                  ? Center(
                                    child: Container(
                                      width: width / 3,
                                        child: Image.asset('assets/marvel-logo.png'),
                                      ),
                                  )
                                  : new Swiper(
                                      controller: swiper,
                                      itemCount: marvelInfos.length,
                                      viewportFraction: 0.85,
                                      scale: 0.9,
                                      autoplay: false,
                                      itemBuilder: (context, index) {
                                        int key = marvelInfos[index].id + 1;
                                        return InkWell(
                                          onDoubleTap: () {
                                            _starBuilder(context, index);
                                            Timer(Duration(milliseconds: 800), () {
                                              star(index);
                                              Navigator.pop(context);
                                            });
                                          },
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                transitionDuration: Duration(milliseconds: 300),
                                                pageBuilder: (context, a, b) => Details(
                                                  marvelInfos: marvelInfos[index],
                                                  keyIndex: key,
                                                  darkMode: darkMode,
                                                  setFavorites: setFavorites,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            color: !darkMode ? Color(0xffFFFFFF) : Color(0xff2F2F2F),
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
                                                      color: !darkMode ? Colors.grey.withOpacity(0.2) : Color(0xffFFFFFF).withOpacity(0.2),
                                                    ),
                                                  ),
                                                ),
                                                Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height: heightCards - 29,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Hero(
                                                              tag: key,
                                                              child: Center(
                                                                  child: Image.asset(
                                                                marvelInfos[index].iconImage,
                                                                height: heightImage,
                                                              )),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              width: width,
                                                              padding: const EdgeInsets.all(20.0),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    marvelInfos[index].codeName,
                                                                    style: TextStyle(
                                                                        fontFamily: 'Avenir',
                                                                        fontSize: key == 10 ? 32 : 35,
                                                                        color: !darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                                                                        fontWeight: FontWeight.w900),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                  if (marvelInfos[index].name != null) SizedBox(height: 5),
                                                                  if (marvelInfos[index].name != null)
                                                                    Text(
                                                                      '${marvelInfos[index].name.toUpperCase()}',
                                                                      style: TextStyle(
                                                                        fontFamily: 'Avenir',
                                                                        fontSize: 15,
                                                                        color: !darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                                                                        fontWeight: FontWeight.w500,
                                                                      ),
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  SizedBox(height: 15),
                                                                  if (marvelInfos[index].icon == 1)
                                                                    CircleAvatar(
                                                                      backgroundColor: Colors.transparent,
                                                                      backgroundImage: AssetImage('assets/avengers.png'),
                                                                      radius: 25.0,
                                                                    ),
                                                                  if (marvelInfos[index].icon == 2)
                                                                    CircleAvatar(
                                                                      backgroundColor: Colors.transparent,
                                                                      backgroundImage: AssetImage('assets/xmen.png'),
                                                                      radius: 25.0,
                                                                    ),
                                                                  if (marvelInfos[index].icon == 3)
                                                                    CircleAvatar(
                                                                      backgroundColor: Colors.transparent,
                                                                      backgroundImage: AssetImage('assets/gotg.png'),
                                                                      radius: 25.0,
                                                                    ),
                                                                  if (marvelInfos[index].icon == 4)
                                                                    CircleAvatar(
                                                                      backgroundColor: Colors.transparent,
                                                                      backgroundImage: AssetImage('assets/avengers-villain.png'),
                                                                      radius: 25.0,
                                                                    ),
                                                                  if (marvelInfos[index].icon == 5)
                                                                    CircleAvatar(
                                                                      backgroundColor: Colors.transparent,
                                                                      backgroundImage: AssetImage('assets/xmen-villain.png'),
                                                                      radius: 25.0,
                                                                    ),
                                                                  if (marvelInfos[index].icon == 6)
                                                                    Container(
                                                                      height: 50.0,
                                                                      child: Image.asset('assets/dependers.png'),
                                                                    )
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
                                                  left: width - 120,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _starBuilder(context, index);
                                                      Timer(Duration(milliseconds: 800), () {
                                                        star(index);
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: Icon(
                                                      (favorites.contains(marvelInfos[index].id.toString())
                                                          ? Icons.star
                                                          : Icons.star_border_outlined),
                                                      size: 40.0,
                                                      color: favorites.contains(marvelInfos[index].id.toString())
                                                          ? (!darkMode ? Color(0xffB81300) : Color(0xffFFFFFF))
                                                          : (!darkMode ? Colors.grey.withOpacity(0.2) : Color(0xffFFFFFF).withOpacity(0.2)),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
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
            bottomNavigationBar: bottomNav(darkMode),
          )
        : Scaffold(
            body: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: darkMode ? bodyLight : bodyDark, begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.0, 0.2, 0.8, 1.8]),
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
  }

  Future<void> _dialogBuilder(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Scaffold(
          body: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: darkMode ? bodyLight : bodyDark, begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.0, 0.2, 0.8, 1.8]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width / 2.5,
                  child: Image.asset('assets/marvel-logo.png'),
                ),
                SizedBox(
                  height: 48.0,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _bottomSheetBuilder(BuildContext context) {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 60.0 * option.length,
          decoration: BoxDecoration(
            color: !darkMode ? Color(0xffFFFFFF) : Color(0xff484848),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: ListView.builder(
            itemCount: option.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    marvelInfos = [];
                    optionActive = index;
                    Navigator.pop(context);
                  });

                  Timer(Duration(milliseconds: 800), () {
                    setState(() {
                      if (optionActive == 0) {
                        marvelInfos = marvels;
                      } else if (optionActive == 1) {
                        marvelInfos = marvels.where((element) {
                          return !element.type.toLowerCase().contains('villains');
                        }).toList();
                      } else {
                        marvelInfos = marvels.where((element) {
                          return element.type.toLowerCase().contains(option[optionActive].toLowerCase());
                        }).toList();
                      }
                    });
                  });
                },
                child: Container(
                  height: 60,
                  child: ListTile(
                    title: Row(
                      children: [
                        if (optionActive == index)
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/active-hulk${!darkMode ? '' : '-dark'}.png'),
                            radius: 15.0,
                          ),
                        if (optionActive != index)
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/inactive-hulk${!darkMode ? '' : '-dark'}.png'),
                            radius: 15.0,
                          ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          option[index],
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 15,
                            color: !darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _starBuilder(BuildContext context, int index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: height,
            width: width,
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElasticIn(
                  duration: Duration(milliseconds: 800),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: favorites.contains(marvels[index].id.toString())
                        ? AssetImage('assets/star-unfav${!darkMode ? '' : '-dark'}.png')
                        : AssetImage('assets/star-fav${!darkMode ? '' : '-dark'}.png'),
                    radius: width / 4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget bottomNav(darkMode) {
    return !isLoading
        ? (!darkMode
            ? CurvedNavigationBar(
                index: currentNav,
                letIndexChange: (value) {
                  print(value);
                  if (value != 1) {
                    if (value == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Search(darkMode: darkMode)),
                      );
                    }
                    if (value == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Favorites(darkMode: darkMode)),
                      );
                    }
                  }
                  return false;
                },
                height: 70.0,
                color: !darkMode ? Color(0xffFFFFFF) : Color(0xff3C3C3C),
                backgroundColor: Colors.transparent,
                items: <Widget>[
                  Container(
                    height: 70.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (currentNav != 0)
                          SizedBox(
                            height: 19.0,
                          ),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/nav-hawk.png'),
                          radius: 20.0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 70.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/nav-iron.png'),
                          radius: 20.0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 70.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (currentNav != 2)
                          SizedBox(
                            height: 19.0,
                          ),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/nav-captain.png'),
                          radius: 20.0,
                        ),
                      ],
                    ),
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    currentNav = index;
                  });
                },
              )
            : CurvedNavigationBar(
                index: currentNav,
                letIndexChange: (value) {
                  print(value);
                  if (value != 1) {
                    if (value == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Search(darkMode: darkMode)),
                      );
                    }
                    if (value == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Favorites(darkMode: darkMode)),
                      );
                    }
                  }
                  return false;
                },
                height: 70.0,
                color: !darkMode ? Color(0xffFFFFFF) : Color(0xff3C3C3C),
                backgroundColor: Colors.transparent,
                items: <Widget>[
                  Container(
                    height: 70.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (currentNav != 0)
                          SizedBox(
                            height: 19.0,
                          ),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/nav-hawk-dark.png'),
                          radius: 20.0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 70.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/nav-iron-dark.png'),
                          radius: 20.0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 70.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (currentNav != 2)
                          SizedBox(
                            height: 19.0,
                          ),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('assets/nav-captain-dark.png'),
                          radius: 20.0,
                        ),
                      ],
                    ),
                  ),
                ],
                onTap: (index) {
                  setState(() {
                    currentNav = index;
                  });
                },
              ))
        : SizedBox(
            height: 70.0,
          );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    swiper.dispose();

    super.dispose();
  }
}
