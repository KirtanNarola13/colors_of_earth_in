import 'package:colors_of_earth/colorsOfEarth/screens/navbar/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorsOfEarth extends StatefulWidget {
  const ColorsOfEarth({super.key});

  @override
  State<ColorsOfEarth> createState() => _ColorsOfEarthState();
}

class _ColorsOfEarthState extends State<ColorsOfEarth> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.urbanist().fontFamily,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: OpenUpwardsPageTransitionsBuilder(),
          },
        ),
      ),
      home: NavigationBarScreen(
        initIndex: 0,
      ),
    );
  }
}
