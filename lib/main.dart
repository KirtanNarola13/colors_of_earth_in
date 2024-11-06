import 'package:colors_of_earth/colorsOfEarth/constant/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopify_flutter/shopify_config.dart';

import 'colorsOfEarth/colors_of_earth.dart';
import 'colorsOfEarth/utils/app_pref.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _requestPermissions();

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

  await loadFireConfig();
  AppPref.init();

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

Future loadFireConfig() async {
  Constants.instance.remoteConfig = FirebaseRemoteConfig.instance;

  await Constants.instance.remoteConfig?.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 0),
      minimumFetchInterval: const Duration(seconds: 0),
    ),
  );

  try {
    await Constants.instance.remoteConfig
        ?.fetchAndActivate()
        .timeout(const Duration(seconds: 10));
  } catch (err) {
    print("ERROR REMOTE CONFIG : $err");
    true;
  }
}
