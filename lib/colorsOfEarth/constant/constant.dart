import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:logger/logger.dart';

class Constants {
  Constants._internal();
  static final Constants _instance = Constants._internal();

  static Constants get instance => _instance;
  /// Remote Config

  FirebaseRemoteConfig? remoteConfig;

}
