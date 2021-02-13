// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:marvel_gallery/services/data.dart';

class Details extends StatelessWidget {
  final MarvelInfos marvelInfos;

  const Details({Key key, this.marvelInfos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Positioned(
                right: -30,
                top: -20,
                child: Hero(
                  tag: marvelInfos.position,
                  child: Image.asset(
                    marvelInfos.iconImage,
                    height: 300,
                  ),
                )),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 200),
                        Text(
                          marvelInfos.name,
                          style: TextStyle(
                            fontFamily: 'avenir',
                            fontSize: 50,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          'Avengers',
                          style: TextStyle(
                            fontFamily: 'avenir',
                            fontSize: 25,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Divider(color: Colors.grey[500]),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          marvelInfos.description ?? '',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'avenir',
                              fontSize: 16,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(color: Colors.grey[500]),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Gallery',
                      style: TextStyle(
                          fontFamily: 'avenir',
                          fontSize: 20,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                      height: 150,
                      child: ListView.builder(
                          itemCount: marvelInfos.images.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                child: AspectRatio(
                                    aspectRatio: 0.9,
                                    child: Image.asset(
                                      marvelInfos.images[index],
                                      fit: BoxFit.cover,
                                    )));
                          }))
                ],
              ),
            ),
            Positioned(
              top: marvelInfos.position.toString().length == 1 ? 3 : 55,
              left: marvelInfos.position.toString().length == 1 ? 40 : 20,
              child: Text(
                marvelInfos.position.toString(),
                style: TextStyle(
                    fontFamily: 'avenir',
                    fontSize:
                        marvelInfos.position.toString().length == 1 ? 200 : 120,
                    color: Colors.grey.withOpacity(0.4),
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
