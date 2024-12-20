import 'dart:async';

import 'package:colors_of_earth/colorsOfEarth/screens/profile/controller/loginController.dart';
import 'package:colors_of_earth/colorsOfEarth/utils/app_pref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'authantication/sign_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LoginController loginController =
      Get.put(LoginController(), tag: 'loginController');
  String name = "Error";
  @override
  void initState() {
    // TODO: implement initState
    loginController.checkIsLogin();

    name = AppPref.name;
    super.initState();
  }

  showColorsOfEarthLoading() {
    return showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: Image(
                image: AssetImage('assets/colorsOfEarthLogo.png'),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    name = AppPref.name;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: height * 0.04,
        backgroundColor: Colors.white,
        title: const Text(
          "Account",
          style: TextStyle(fontSize: 16),
        ),
        shadowColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(
                        "https://cdnl.iconscout.com/lottie/premium/thumb/man-avatar-animation-download-in-lottie-json-gif-static-svg-file-formats--looking-side-boy-person-avatars-pack-people-animations-4639489.gif"),
                  ),
                  Obx(() {
                    if (loginController.isLogin.value) {
                      return Container(
                        alignment: Alignment.center,
                        height: height * 0.045,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      );
                    } else {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            print("signin pressed");
                          },
                          splashColor: Colors.white,
                          child: Container(
                            alignment: Alignment.center,
                            height: height * 0.045,
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                            child: const Text(
                              "CREATE ACCOUNT",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }),
                  Obx(
                    () => loginController.isLogin.value
                        ? Material(
                            color: Colors.black,
                            child: InkWell(
                              onTap: () {
                                showColorsOfEarthLoading();
                                Timer(Duration(seconds: 2), () {
                                  loginController.logout();
                                  Navigator.pop(context);
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: height * 0.045,
                                color: Colors.black,
                                child: const Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignIn(),
                                  ),
                                ).then((val) {
                                  loginController.checkIsLogin();
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: height * 0.045,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: const Text(
                                  "Already have an account? SignIn",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    child: InkWell(
                      onTap: () {
                        setState(() {});
                      },
                      splashColor: Colors.white10,
                      child: Ink(
                        padding: EdgeInsets.all(10),
                        // alignment: Alignment.centerLeft,
                        width: double.infinity,
                        height: height * 0.045,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: Text("📦 View Order"),
                      ),
                    ),
                  ),
                  Material(
                    child: InkWell(
                      onTap: () {
                        setState(() {});
                      },
                      splashColor: Colors.white10,
                      child: Ink(
                        padding: EdgeInsets.all(10),
                        // alignment: Alignment.centerLeft,
                        width: double.infinity,
                        height: height * 0.045,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: Text("🏢 About us"),
                      ),
                    ),
                  ),
                  Material(
                    child: InkWell(
                      onTap: () {
                        setState(() {});
                      },
                      splashColor: Colors.white10,
                      child: Ink(
                        padding: EdgeInsets.all(10),
                        // alignment: Alignment.centerLeft,
                        width: double.infinity,
                        height: height * 0.045,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: Text("🧑🏻‍🚀 Contact Us"),
                      ),
                    ),
                  ),
                  Material(
                    child: InkWell(
                      onTap: () {
                        setState(() {});
                      },
                      splashColor: Colors.white10,
                      child: Ink(
                        padding: EdgeInsets.all(10),
                        // alignment: Alignment.centerLeft,
                        width: double.infinity,
                        height: height * 0.045,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: Text("📄 Privacy Policy"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "⚠️ Hey! COLORS OF EARTH will never request financial details or payments for contest winnings. Protect your information and avoid sharing it through any medium.\n\nKeep rocking the COLORS OF EARTH look, securely and in style.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
