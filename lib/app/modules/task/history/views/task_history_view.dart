import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_track/app/helpers/images.dart';
import 'package:clean_track/app/helpers/themes.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:clean_track/app/modules/officer/views/officer_view.dart';
import 'package:clean_track/app/widgets/bottom_nav_officer.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/task_history_controller.dart';

class TaskHistoryView extends GetView<TaskHistoryController> {
  const TaskHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavOfficer(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(png_default_profile),
                foregroundImage:
                    authC.user.foto.isEmptyOrNull
                        ? null
                        : CachedNetworkImageProvider(authC.user.foto!),
              ),
              tileColor: colorScheme(context).surface,
              title: Text(authC.user.name ?? "-"),
              subtitle: Text("Task history"),
              trailing: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.close),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Task History",
                        style: textTheme(context).titleLarge,
                      ),
                      4.height,
                      Text(
                        "Browse all your past waste task and their statuses at a glance",
                        style: textTheme(
                          context,
                        ).bodyMedium?.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      16.height,
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child:
                              controller.userReports.isEmpty
                                  ? Text(
                                    "You don't have Task history",
                                    style: textTheme(context).bodyMedium,
                                  )
                                  : ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: controller.userReports.length,
                                    itemBuilder: (context, index) {
                                      var report =
                                          controller.userReports[index];
                                      return OfficerTaskCard(report: report);
                                    },
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
