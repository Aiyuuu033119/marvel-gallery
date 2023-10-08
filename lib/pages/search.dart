import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marvel_gallery/pages/details.dart';
import 'package:marvel_gallery/services/data.dart';

class Search extends StatefulWidget {
  final bool darkMode;

  const Search({Key key, this.darkMode}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Timer _debounce;

  int _debouncetime = 500;

  List<MarvelInfos> filter = [];

  bool isSearch = false;

  final TextEditingController search = TextEditingController();
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: !widget.darkMode ? Color(0xff850D00) : Color(0xff2F2F2F),
      body: SafeArea(
        child: Container(
          color: !widget.darkMode ? Colors.grey.shade200 : Color(0xff484848).withOpacity(0.4),
          child: Column(
            children: <Widget>[
              Container(
                color: !widget.darkMode ? Color(0xffB81300) : Color(0xff2F2F2F),
                height: 70.0,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Color(0xffFFFFFF),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                      width: width - 65,
                      height: 48,
                      decoration: BoxDecoration(
                        color: !widget.darkMode ? Color(0xffFFFFFF) : Color(0xff484848),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: width - 100,
                            padding: const EdgeInsets.only(top: 15.0),
                            child: TextField(
                              controller: search,
                              focusNode: focusNode,
                              style: TextStyle(
                                fontFamily: 'Avenir',
                                fontSize: 18,
                                color: !widget.darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                                fontWeight: FontWeight.w400,
                              ),
                              cursorColor: !widget.darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.white, width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  fontFamily: 'Avenir',
                                  fontSize: 18,
                                  color: !widget.darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                                  fontWeight: FontWeight.w400,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: !widget.darkMode ? Color(0xffFFFFFF) : Color(0xff484848), width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: !widget.darkMode ? Color(0xffFFFFFF) : Color(0xff484848), width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              onChanged: (value) {
                                if (_debounce?.isActive ?? false) _debounce.cancel();
                                _debounce = Timer(Duration(milliseconds: _debouncetime), () {
                                  if (value != "") {
                                    setState(() {
                                      filter = marvels.where((element) {
                                        return element.codeName.toLowerCase().contains(value);
                                      }).toList();
                                      isSearch = true;
                                    });
                                  } else {
                                    setState(() {
                                      filter = [];
                                      isSearch = false;
                                    });
                                  }
                                });
                              },
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage('assets/nav-hawk${(widget.darkMode ? '-dark' : '')}.png'),
                            radius: 12.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (filter.isEmpty && isSearch)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          'No Result Found',
                          style: TextStyle(
                            fontFamily: 'Avenir',
                            fontSize: 20,
                            color: !widget.darkMode ? Colors.grey[800] : Color(0xffFFFFFF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (filter.isNotEmpty)
                Builder(
                  builder: (context) {
                    double itemHeight = (height - kToolbarHeight) / 3;
                    final double itemWidth = width / 2;
                    return Expanded(
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        color: !widget.darkMode ? Colors.grey.shade200 : Color(0xff484848).withOpacity(0.4),
                        child: GridView.count(
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 2,
                          childAspectRatio: (itemWidth / itemHeight),
                          shrinkWrap: true,
                          children: List.generate(filter.length, (value) {
                            int key = filter[value].id + 1;
                            return InkWell(
                              onTap: () {
                                focusNode.unfocus();
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration: Duration(milliseconds: 300),
                                    pageBuilder: (context, a, b) => Details(marvelInfos: filter[value], keyIndex: key, darkMode: widget.darkMode),
                                  ),
                                );
                              },
                              child: new Container(
                                decoration: BoxDecoration(
                                  color: !widget.darkMode ? Color(0xffFFFFFF) : Color(0xff2F2F2F),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: new EdgeInsets.all(5.0),
                                child: new Center(
                                  child: Hero(
                                    tag: key,
                                    child: new Image.asset(
                                      filter[value].iconImage.toString(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode.dispose();
    search.dispose();

    super.dispose();
  }
}
