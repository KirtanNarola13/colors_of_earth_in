import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authantication/sign_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLogin = false;

  checkIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogin = prefs.getBool('isUserLogin') ?? false;
    });
    Logger().i("isLogin profile initState: $isLogin");
  }

  @override
  void initState() {
    // TODO: implement initState
    checkIsLogin();
    super.initState();
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: height * 0.04,
        backgroundColor: Colors.white,
        title: const Text(
          "Account",
          style: TextStyle(fontSize: 16),
        ),
        elevation: 2,
        shadowColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        "https://cdn1.iconfinder.com/data/icons/user-pictures/101/malecostume-512.png"),
                  ),
                  (isLogin)
                      ? Container()
                      : Container(
                          alignment: Alignment.center,
                          height: height * 0.045,
                          color: Colors.black,
                          child: const Text(
                            "CREATE ACCOUNT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                  (isLogin)
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignIn(),
                              ),
                            );
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
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              color: Colors.white,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("📦 Trake Order"),
                  Text("🔁 Return / Exchange Order"),
                  Text("🧑🏻‍🚀 Contact Us"),
                  Text("📄 Privacy Policy"),
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
