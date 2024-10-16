import 'dart:developer';

import 'package:colors_of_earth/colorsOfEarth/screens/home/home_screen.dart';
import 'package:colors_of_earth/colorsOfEarth/screens/new/new_collection_screen.dart';
import 'package:colors_of_earth/colorsOfEarth/screens/profile/profile_screen.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../order/order.dart';

class NavigationBarScreen extends StatefulWidget {
  int initIndex = 0;
  NavigationBarScreen({super.key, required this.initIndex});

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen>
    with TickerProviderStateMixin {
  var _selectedTab = _SelectedTab.home;
  late PageController pageController;
  @override
  void initState() {
    _selectedTab = _SelectedTab.values[widget.initIndex];
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
      log(_selectedTab.index.toString());
      pageController.animateToPage(
        _SelectedTab.values[i].index,
        duration: const Duration(milliseconds: 100),
        curve: Curves.linear,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var anim = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 500),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        reverse: false,
        children: const [
          HomeScreen(),
          Order(),
          NewCollectionScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10),
        child: CustomNavigationBar(
          iconSize: 20.0,
          elevation: 0,
          selectedColor: Color(0xff040307),
          strokeColor: Color(0x30040307),
          unSelectedColor: Color(0xffacacac),
          backgroundColor: Colors.white,
          items: [
            CustomNavigationBarItem(
              icon: Icon(LineIcons.home),
              title: Text("Home"),
            ),
            CustomNavigationBarItem(
              icon: Icon(LineIcons.box),
              title: Text("Orders"),
            ),
            CustomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline),
              title: Text("Explore"),
            ),
            CustomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              title: Text("Profile"),
            ),
          ],
          currentIndex: _selectedTab.index,
          onTap: (index) {
            _handleIndexChanged(index);
          },
        ),
      ),
    );
  }
}

enum _SelectedTab { home, order, collection, person }
