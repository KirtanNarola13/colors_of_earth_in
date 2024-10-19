import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  // Observables to manage the login state
  RxBool isLogin = false.obs;
  RxString Name = "".obs;

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUserLogin', true); // Set isUserLogin to true
    isLogin.value = true; // Update isLogin to true

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
