import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '/../main.dart';

class MyLocaleController extends GetxController {
  void changeLang(String codeLang) {
    Locale locale = Locale(codeLang);
    sharedpref.setString("curruntLang", codeLang);
    Get.updateLocale(locale);
  }
}
