import 'package:clean_track/app/data/models/user_model.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:clean_track/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthLoginController extends GetxController {
  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  final _showPassword = false.obs;
  set showPassword(value) => _showPassword.value = value;
  get showPassword => _showPassword.value;

  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  void togglePasword() {
    showPassword = !showPassword;
  }

  Future signIn() async {
    try {
      isLoading = true;
      String? message = await authC.signIn(emailC.text, passwordC.text);
      if (message == null) {
        if (authC.user.hasRole(Role.user)) {
          Get.snackbar(
            "Sign In Berhasil",
            "Selamat datang di Clean Tracker App",
          );
          Get.offAllNamed(Routes.HOME);
        }
        if (authC.user.hasRole(Role.officer)) {
          Get.snackbar(
            "Sign In Berhasil",
            "Selamat datang di Clean Tracker App",
          );
          Get.offAllNamed(Routes.OFFICER);
        } else {
          Get.snackbar(
            "Sign In Gagal",
            "Role tidak teridentifikasi. Role anda adalah '${authC.user.role}'",
          );
        }
      } else {
        Get.snackbar("Sign In Gagal", message);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      printError(info: e.toString());
    } finally {
      isLoading = false;
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
