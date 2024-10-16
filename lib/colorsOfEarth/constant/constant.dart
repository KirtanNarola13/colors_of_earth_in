import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:logger/logger.dart';

class Constant {
  Constant._();

  static final Constant constant = Constant._();

  /// Remote Config

  FirebaseRemoteConfig? remoteConfig;

  loadFireConfig() async {
    remoteConfig = FirebaseRemoteConfig.instance;
    remoteConfig?.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(seconds: 10),
    ));

    try {
      await Constant.constant.remoteConfig
          ?.fetchAndActivate()
          .timeout(Duration(seconds: 10));
    } catch (e) {
      Logger().e(e);
    }
  }
}
