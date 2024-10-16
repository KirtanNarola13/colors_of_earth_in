import 'package:get/get.dart';

class BannerIndexController extends GetxController {
  RxInt bannerIndex = 0.obs;

  void changeBannerIndex(int index) {
    bannerIndex.value = index;
  }
}
