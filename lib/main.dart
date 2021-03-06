import 'package:flutter/material.dart';
import 'ui/home_page.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(
      color: AlwaysStoppedAnimation<Color>(Colors.white),
    ),
  ));
}
