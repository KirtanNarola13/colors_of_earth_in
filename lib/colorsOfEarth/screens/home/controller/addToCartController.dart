import 'dart:async';

import 'package:colors_of_earth/colorsOfEarth/utils/constant/constant.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';

class AddToCartController extends GetxController {
  RxBool isExist = false.obs;
  RxInt cartLength = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Start the periodic timer that runs every 2 seconds
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      calculateCartLength(); // Call the method every 2 seconds
    });
  }

  @override
  void onClose() {
    // Cancel the timer when the controller is disposed
    _timer?.cancel();
    super.onClose();
  }

  calculateCartLength() {
    cartLength.value = Constant.cartProducts.length;
    Logger().i("Cart length: $cartLength");
  }

  checkProductExistInCart(int productId) {
    bool isExist = false;
    Constant.cartProducts.forEach((element) {
      Logger().d("${element['variant']['id']} == $productId");

      if (element['variant']['id'] == productId) {
        isExist = true;
      }
    });

    calculateCartLength();
    Logger().i("Cart length: $cartLength");
    this.isExist.value = isExist;
    return isExist;
  }
}
