import 'package:angelo/constants.dart';
import 'package:angelo/screens/add_image_screen.dart';
import 'package:angelo/screens/favorites_screen.dart';
import 'package:angelo/screens/profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home_screen.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final _navs = [
    HomeScreen(),
    FavoritesScreen(),
    AddImageScreen(),
    ProfileScreen()
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().firstColor,
      body: _navs[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Colors.transparent,
        color: Colors.teal,
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          FaIcon(
            FontAwesomeIcons.images,
            color: Colors.white,
          ),
          FaIcon(FontAwesomeIcons.heart, color: Colors.white),
          FaIcon(FontAwesomeIcons.camera, color: Colors.white),
          FaIcon(FontAwesomeIcons.user, color: Colors.white),
        ],
      ),
    );
  }
}
