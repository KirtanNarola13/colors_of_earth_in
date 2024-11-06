import 'package:colors_of_earth/colorsOfEarth/utils/app_pref.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // Observables to manage the login state
  RxBool isLogin = false.obs;

  Future<void> login(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUserLogin', true);
    AppPref.loginName = name;
    isLogin.value = true; // Update isLogin to true

    Logger()
        .i("Parameter name: $name Controller Name: ${prefs.getString('name')}");
    Logger().i("User logged in. isUserLogin: ${prefs.getBool('isUserLogin')}");
  }

  // Method to check if the user is logged in
  Future<void> checkIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    isLogin.value = prefs.getBool('isUserLogin') ?? false;
    Logger().i("isLogin from controller: ${isLogin.value}");
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isUserLogin'); // Remove user login state
    isLogin.value = false; // Update isLogin to false

    Logger().i("User logged out. isUserLogin: ${prefs.getBool('isUserLogin')}");
  }
}
