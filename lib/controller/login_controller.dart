import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../database/services/login_service.dart';
import '../database/storages/user_secure_storage.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginkey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() async {
    try {
      if (loginkey.currentState!.validate()) {
        isLoading.value = true;
        var response = await LoginService().login(
            username: usernameController.text,
            password: passwordController.text);
        if (response != null) {
          Get.offAll(() => HomePage());
        }
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void logOut() async {
    try {
      var token = await UserSecureStorage.getToken();

      var response = await LoginService().logout(token: token);
      if (response == true) {
        await UserSecureStorage.deletetoken();
        Get.offAll(() => const LoginPage());
      }
    } catch (_) {
    } finally {}
  }
}
