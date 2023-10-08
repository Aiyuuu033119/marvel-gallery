import 'package:flutter/material.dart';
import 'package:marvel_gallery/pages/home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
    },
  ));
}
