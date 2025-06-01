import 'package:clean_track/app/data/models/user_model.dart';
import 'package:clean_track/app/helpers/themes.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:clean_track/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var authController = Get.put(AuthController(), permanent: true);
  UserModel? user = await authController.getActiveUser();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Clean Track",
      // initialRoute: AppPages.INITIAL,
      initialRoute:
          (user?.id?.isEmptyOrNull ?? true)
              ? Routes.AUTH_LOGIN
              : user!.hasRole(Role.officer)
              ? Routes.OFFICER
              : Routes.HOME,
      getPages: AppPages.routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
    ),
  );
}
