import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebCheckout extends StatefulWidget {
  String url;
  WebCheckout({super.key, required this.url});

  @override
  State<WebCheckout> createState() => _WebCheckoutState();
}

class _WebCheckoutState extends State<WebCheckout> {
  String checkOutUrl = "";
  String tempUrl = "";
  late InAppWebViewController inAppWebViewController;
  @override
  void initState() {
    // TODO: implement initState

    checkOutUrl = widget.url;
    tempUrl = widget.url;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    log(checkOutUrl);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.06,
        backgroundColor: Colors.white,
        title: Text(
          "Checkouts",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(checkOutUrl),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              inAppWebViewController = controller;
            },
            onLoadStart: (
              InAppWebViewController contoller,
              WebUri? url,
            ) {
              setState(() {
                checkOutUrl = url.toString();
              });
            },
            onLoadStop: (InAppWebViewController controller, WebUri? url) async {
              setState(() {
                checkOutUrl = url.toString();
              });
            },
            shouldOverrideUrlLoading: (InAppWebViewController controller,
                NavigationAction navigationAction) async {
              var url = navigationAction.request.url.toString();
              if (url.contains("thank_you")) {
                Navigator.pop(context);
                return NavigationActionPolicy.CANCEL;
              } else if (url == "https://colorsofearth.in/") {
                Navigator.pop(context);
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
          ),
        ),
      ),
    );
  }
}
