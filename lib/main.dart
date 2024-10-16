import 'package:colors_of_earth/colorsOfEarth/constant/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopify_flutter/shopify_config.dart';

import 'colorsOfEarth/colors_of_earth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _requestPermissions();

  final fcmToken = await FirebaseMessaging.instance.getToken();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('088cb45d-7d0a-4b81-ba27-b976cca037a7');
  OneSignal.Notifications.requestPermission(true);

  ShopifyConfig.setConfig(
      storefrontAccessToken: 'eef4c0d63aac81b19b0a033fda42e239',
      storeUrl: 'https://colorsofearth.in',
      adminAccessToken: "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",

      /// Optional | Needed only if needed to call admin api
      storefrontApiVersion: '2024-07',

      /// optional | default: 2023-07
      cachePolicy: CachePolicy.cacheAndNetwork,

      /// optional | default: null
      language: 'en'

      /// Store locale | default : en
      );

  Constant.constant.loadFireConfig();
  runApp(
    const ColorsOfEarth(),
  );
}

Future<void> _requestPermissions() async {
  // Request notification permission
  PermissionStatus permission = await Permission.notification.request();
  if (permission != PermissionStatus.granted) {
    // Handle permission denied
    // You may want to show a dialog or message to the user
    // explaining that the app needs notification permissions
  }
}
