import 'package:colors_of_earth/colorsOfEarth/screens/profile/controller/loginController.dart';
import 'package:colors_of_earth/colorsOfEarth/utils/helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

import 'forgot_password.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    bool isObscure = true;

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

    LoginController loginController = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.05,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const LineIcon.arrowLeft(),
        ),
        title: const Text(
          "Sign In",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Center(
                child: Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              const Center(
                child: Text(
                  "Don't have an account? SIGN UP",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Email address*"),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                    height: height * 0.05,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Center(
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.always,
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          hintText: "Enter your email address",
                          hintStyle: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.025,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Password*"),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    height: height * 0.05,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Center(
                      child: TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        autovalidateMode: AutovalidateMode.always,
                        obscureText: isObscure,
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.all(10),
                          border: InputBorder.none,
                          hintText: "Enter your password",
                          hintStyle: const TextStyle(
                            fontSize: 12,
                          ),
                          suffix: IconButton(
                              onPressed: () {}, icon: const LineIcon.eye()),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.035,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassword()));
                },
                child: const Text(
                  "FORGOT PASSWORD",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.035,
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();

                  showColorsOfEarthLoading();
                  ApiHelper.apiHelper
                      .createCustomerAccessToken(
                          emailController.text, passwordController.text)
                      .then((value) async {
                    if (value != null) {
                      Logger().i("Login Success $value");
                      loginController.Name = emailController.text.obs;
                      loginController.login();
                      Navigator.pop(context);
                      Navigator.pop(context);

                      // Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => NavigationBarScreen(
                      //         initIndex: 3,
                      //       ),
                      //     ),
                      //     (route) => false);
                    } else {
                      Logger().e("Login failed $value");
                      Navigator.pop(context);
                    }
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: height * 0.045,
                  color: Colors.black,
                  child: const Text(
                    "SIGN IN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
