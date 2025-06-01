import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_track/app/data/models/user_model.dart';
import 'package:clean_track/app/helpers/images.dart';
import 'package:clean_track/app/helpers/themes.dart';
import 'package:clean_track/app/routes/app_pages.dart';
import 'package:clean_track/app/widgets/BottomNav.dart';
import 'package:clean_track/app/widgets/bottom_nav_officer.dart';
import 'package:clean_track/app/widgets/card_column.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () =>
            controller.user?.hasRole(Role.officer) ?? false
                ? BottomNavOfficer(currentIndex: 2)
                : BottomNav(currentIndex: 2),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My Profile",
                              style: textTheme(context).titleMedium,
                            ),
                            Text(
                              "Account Details",
                              style: textTheme(context).labelMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          var isOfficer = controller.user?.hasRole(
                            Role.officer,
                          );
                          if (isOfficer ?? false) {
                            Get.offAllNamed(Routes.OFFICER);
                          } else {
                            Get.offAllNamed(Routes.HOME);
                          }
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => CardColumn(
                  margin: EdgeInsets.all(16),
                  crossAxis: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundColor: colorScheme(context).secondary,
                        radius: 48,
                        foregroundImage:
                            (controller.user?.foto.isEmptyOrNull ?? true)
                                ? null
                                : CachedNetworkImageProvider(
                                  controller.user!.foto!,
                                ),
                        backgroundImage: AssetImage(png_default_profile),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      controller.user?.name ?? "User's Name",
                      style: textTheme(
                        context,
                      ).titleLarge?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      controller.user?.email ?? "user@email.com",
                      style: textTheme(
                        context,
                      ).bodyMedium?.copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 28),
                    Obx(
                      () => Text(
                        controller.reports.length.toString(),
                        style: textTheme(context).headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor(context),
                        ),
                      ),
                    ),
                    Text(
                      controller.isOfficer
                          ? "Task assigned"
                          : "Reports Submitted",
                      style: textTheme(
                        context,
                      ).bodyMedium?.copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 16),
                    // Container(
                    //   width: Get.width,
                    //   child: ElevatedButton.icon(
                    //     onPressed: () {},
                    //     icon: Icon(
                    //       Icons.edit_square,
                    //       color: colorScheme(context).onSecondary,
                    //     ),
                    //     label: Text("Edit Profile"),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              Container(
                margin: EdgeInsets.all(16),
                width: Get.width,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await showConfirmDialogCustom(
                          context,
                          onAccept: (context) => controller.signOut(),
                          title: "Are you sure",
                          subTitle: "Are you sure to log out from CleanTrack",
                          positiveText: "Yes",
                          negativeText: "Cancel",
                        ) ??
                        false;
                  },
                  icon: Icon(
                    Icons.logout,
                    color: colorScheme(context).onSecondary,
                  ),
                  label: Text("Log Out"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.danger,
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
