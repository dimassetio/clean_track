// ignore_for_file: must_be_immutable

import 'package:clean_track/app/helpers/images.dart';
import 'package:clean_track/app/helpers/themes.dart';
import 'package:clean_track/app/helpers/validator.dart';
import 'package:clean_track/app/routes/app_pages.dart';
import 'package:clean_track/app/widgets/button.dart';
import 'package:clean_track/app/widgets/text_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/auth_register_controller.dart';

class AuthRegisterView extends GetView<AuthRegisterController> {
  AuthRegisterView({super.key});
  GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              40.height,
              Form(
                key: _formKey,
                child: Card(
                  margin: EdgeInsets.all(16),
                  color: colorScheme(context).surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(20),
                          child: Image.asset(png_logo, width: 120, height: 120),
                        ),
                        Text(
                          "Register".tr,
                          style: textTheme(context).headlineSmall,
                        ),
                        4.height,
                        Text(
                          "Create your CleanTrack account".tr,
                          style: textTheme(context).bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        16.height,
                        CTextfield(
                          controller: controller.nameC,
                          label: 'Full Name'.tr,
                          icon: Icon(Icons.person),
                          textFieldType: TextFieldType.NAME,
                        ),
                        16.height,
                        CTextfield(
                          controller: controller.emailC,
                          label: 'Email'.tr,
                          icon: Icon(Icons.email_outlined),
                          textFieldType: TextFieldType.EMAIL,
                          validator: emailValidator,
                        ),
                        16.height,
                        CTextfield(
                          controller: controller.passwordC,
                          label: 'Password'.tr,
                          icon: Icon(Icons.lock_outline_rounded),
                          textFieldType: TextFieldType.PASSWORD,
                        ),
                        16.height,
                        CTextfield(
                          controller: controller.confirmPasswordC,
                          label: 'Confirm Password'.tr,
                          icon: Icon(Icons.lock_outline_rounded),
                          textFieldType: TextFieldType.PASSWORD,
                        ),
                        16.height,
                        Obx(
                          () => CustomButton(
                            onPressed:
                                controller.isLoading
                                    ? null
                                    : () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        controller.signUp();
                                      }
                                    },
                            title: 'Register'.tr,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.AUTH_LOGIN);
                            },
                            child: Text(
                              "Already have an account? Login".tr,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        8.height,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
