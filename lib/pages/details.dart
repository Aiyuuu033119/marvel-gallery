// import 'dart:html';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marvel_gallery/pages/webview.dart';
import 'package:marvel_gallery/services/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';

class Details extends StatefulWidget {
  final MarvelInfos marvelInfos;
  final int keyIndex;
  final bool darkMode;
  final Function setFavorites;

  const Details({
    Key key,
    this.keyIndex,
    this.marvelInfos,
    this.darkMode,
    this.setFavorites,
  }) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  SharedPreferences pref;

  List<String> favorites = [];

  @override
  // ignore: must_call_super
  initState() {
    sharedPref();
  }

  void sharedPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      favorites = pref.getStringList('favorites') != null ? pref.getStringList('favorites') : [];
    });
  }

  void star() {
    if (favorites.contains(widget.marvelInfos.id.toString())) {
      setState(() {
        favorites.removeWhere((element) => element == widget.marvelInfos.id.toString());
        pref.setStringList('favorites', favorites);
        widget.setFavorites(favorites);
      });
    } else {
      setState(() {
        favorites.add(widget.marvelInfos.id.toString());
        pref.setStringList('favorites', favorites);
        widget.setFavorites(favorites);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double heightImage = width / 1.2;

    return Scaffold(
      backgroundColor: !widget.darkMode ? Color(0xff850D00) : Color(0xff2F2F2F),
      body: SafeArea(
        bottom: false,
        child: Container(
          color: !widget.darkMode ? Color(0xffFFFFFF) : Color(0xff2F2F2F),
          child: Stack(
            children: <Widget>[
              Positioned(
                right: -30,
                top: -20,
                child: Hero(
                  tag: widget.keyIndex,
                  child: Image.asset(
                    widget.marvelInfos.iconImage,
                    height: heightImage,
                  ),
                ),
              ),
              Container(
                height: height,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 215),
                            Text(
                              widget.marvelInfos.codeName,
                              style: TextStyle(
                                fontFamily: 'avenir',
                                fontSize: 50,
                                color: !widget.darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                                fontWeight: FontWeight.w900,
                                shadows: <Shadow>[
                                  if (!widget.darkMode)
                                    Shadow(
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 8.0,
                                      color: Colors.white,
                                    ),
                                  if (widget.darkMode)
                                    Shadow(
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 8.0,
                                      color: Colors.black,
                                    ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              widget.marvelInfos.name != null ? widget.marvelInfos.name.toUpperCase() : '',
                              style: TextStyle(
                                fontFamily: 'avenir',
                                fontSize: 18,
                                color: !widget.darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            if (widget.marvelInfos.name != null)
                              SizedBox(
                                height: 10,
                              ),
                            if (widget.marvelInfos.description is String)
                              Text(
                                widget.marvelInfos.description ?? '',
                                style: TextStyle(
                                  fontFamily: 'avenir',
                                  fontSize: 16,
                                  color: !widget.darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            if (widget.marvelInfos.description is List)
                              for (var item in widget.marvelInfos.description)
                                Column(
                                  children: <Widget>[
                                    Text(
                                      item ?? '',
                                      style: TextStyle(
                                        fontFamily: 'avenir',
                                        fontSize: 16,
                                        color: !widget.darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                            SizedBox(height: 20),
                            Text(
                              'Gallery',
                              style: TextStyle(
                                fontFamily: 'avenir',
                                fontSize: 20,
                                color: !widget.darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 200.0,
                              width: width,
                              child: ListView.builder(
                                itemCount: widget.marvelInfos.images.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Card(
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    child: AspectRatio(
                                      aspectRatio: 1.5,
                                      child: Image.asset(
                                        widget.marvelInfos.images[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: widget.keyIndex.toString().length == 1 ? 3 : 55,
                left: widget.keyIndex.toString().length == 1 ? 40 : 20,
                child: Text(
                  widget.keyIndex.toString(),
                  style: TextStyle(
                    fontFamily: 'avenir',
                    fontSize: widget.keyIndex.toString().length == 1 ? 200 : 120,
                    color: !widget.darkMode ? Colors.grey.withOpacity(0.2) : Color(0xffFFFFFF).withOpacity(0.2),
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                color: !widget.darkMode ? Colors.black : Color(0xffFFFFFF),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        height: 80.0,
        width: width,
        color: !widget.darkMode ? Color(0xffFFFFFF) : Color(0xff2F2F2F),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _starBuilder(context);
                Timer(Duration(milliseconds: 800), () {
                  star();
                  Navigator.pop(context);
                });
              },
              child: Container(
                height: 60.0,
                width: width - 70.0,
                decoration: BoxDecoration(
                  color: !widget.darkMode ? Color(0xffB81300) : Color(0xff484848),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      favorites.contains(widget.marvelInfos.id.toString()) ? Icons.star_border_outlined : Icons.star,
                      size: 30.0,
                      color: Color(0xffFFFFFF),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      favorites.contains(widget.marvelInfos.id.toString()) ? 'Remove from Favorite' : 'Favorite',
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontSize: 18,
                        color: Color(0xffFFFFFF),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (widget.marvelInfos.url.length >= 2) {
                  _bottomSheetBuilder(context, ['Ant-Man', 'The Wasp'], widget.marvelInfos.url);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewer(
                        darkMode: widget.darkMode,
                        url: widget.marvelInfos.url[0],
                        codeName: widget.marvelInfos.codeName,
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(
                  Icons.language_outlined,
                  color: !widget.darkMode ? Colors.black87 : Color(0xffFFFFFF),
                  size: 35.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _starBuilder(BuildContext context) {
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
                    backgroundImage: favorites.contains(widget.marvelInfos.id.toString())
                        ? AssetImage('assets/star-unfav${!widget.darkMode ? '' : '-dark'}.png')
                        : AssetImage('assets/star-fav${!widget.darkMode ? '' : '-dark'}.png'),
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

  Future<void> _bottomSheetBuilder(BuildContext context, List list, List url) {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 60.0 * list.length,
          decoration: BoxDecoration(
            color: !widget.darkMode ? Color(0xffFFFFFF) : Color(0xff484848),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewer(
                        darkMode: widget.darkMode,
                        url: url[index],
                        codeName: list[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          list[index],
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 15,
                            color: !widget.darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
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
}
