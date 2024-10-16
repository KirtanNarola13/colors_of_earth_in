import 'dart:developer';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';

import '../../../utils/shopify/shopify.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextEditingController emailController = TextEditingController();
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
          "Forgot Password",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                "Forgot password?",
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
                "We have got you covered.",
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
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        controller: emailController,
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          hintText: "Enter your email address",
                          hintStyle: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        onChanged: (e) {
                          log("${emailController.text}");
                        },
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
                if (formKey.currentState!.validate()) {
                  Shopify.shopify.passWordResetEmail(emailController.text);
                  setState(() {
                    DelightToastBar(
                      snackbarDuration: Duration(seconds: 1),
                      autoDismiss: true,
                      builder: (context) => ToastCard(
                        leading: Icon(
                          Icons.send,
                          size: 28,
                          color: Colors.white,
                        ),
                        color: Colors.green.withOpacity(0.5),
                        title: Text(
                          "Email sent successfully",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ).show(context);
                    Navigator.pop(context);
                  });
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: height * 0.045,
                color: Colors.black,
                child: const Text(
                  "EMAIL RESET LINK TO ME",
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
    );
    return Scaffold();
  }
}
