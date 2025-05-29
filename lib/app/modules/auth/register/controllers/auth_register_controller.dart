import 'package:clean_track/app/data/models/user_model.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:clean_track/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthRegisterController extends GetxController {
  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  final _showPassword = false.obs;
  set showPassword(value) => _showPassword.value = value;
  get showPassword => _showPassword.value;

  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();

  void togglePasword() {
    showPassword = !showPassword;
  }

  Future signUp() async {
    try {
      isLoading = true;
      String? message = await authC.signUp(
        name: nameC.text,
        email: emailC.text,
        password: passwordC.text,
        role: Role.user,
      );

      if (message == null) {
        var user = await authC.getActiveUser();
        if (user?.hasRole(Role.user) ?? false) {
          Get.snackbar(
            "Sign In Berhasil",
            "Selamat datang di Clean Tracker App",
          );
          Get.offAllNamed(Routes.HOME);
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
