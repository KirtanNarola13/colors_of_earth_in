import 'package:shared_preferences/shared_preferences.dart';

class AppPref {
  // region Pref Constants
  static const _isLogin = "isLogin";
  static const _token = "token";
  static const _userData = "userData";
  static const _isSubscribed = "isSubscribe";
  static const _portraitReactionList = "portraitReactionList";
  static const _adEnable = "adEnable";
  static const _fcmToken = "fcmToken";
  static const _isFirstOpen = "isFirstOpen";
  static const _isIntroSeen = "isIntroSeen2";

  // endregion

  AppPref._();

  static late final SharedPreferences _preference;

  static Future<void> init() async {
    _preference = await SharedPreferences.getInstance();
  }

  static Future<bool> clear() async {
    return await _preference.clear();
  }

  static SharedPreferences get pref => _preference;

  // static set isLogin(bool value) => _preference.setBool(_isLogin, value);
  //
  // static bool get isLogin => _preference.getBool(_isLogin) ?? false;
  static set loginName(String value) => _preference.setString('name', value);
  static String get name => _preference.getString('name') ?? "";
}
