import 'package:get/get.dart';

import 'locale_controller.dart';

class MyLocaleHelper {
  static MyLocaleController getLocaleController() {
    return Get.find<MyLocaleController>();
  }
}
