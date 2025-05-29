import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_track/app/helpers/images.dart';
import 'package:clean_track/app/helpers/themes.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:clean_track/app/modules/home/views/home_view.dart';
import 'package:clean_track/app/widgets/BottomNav.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/report_history_controller.dart';

class ReportHistoryView extends GetView<ReportHistoryController> {
  const ReportHistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(currentIndex: 1),
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
              subtitle: Text("Report history"),
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
                        "Report History",
                        style: textTheme(context).titleLarge,
                      ),
                      4.height,
                      Text(
                        "Browse all your past waste reports and their statuses at a glance",
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
                              controller.reports.isEmpty
                                  ? Text(
                                    "You don't have Report history",
                                    style: textTheme(context).bodyMedium,
                                  )
                                  : ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: controller.reports.length,
                                    itemBuilder: (context, index) {
                                      var report = controller.reports[index];
                                      return ReportCard(report);
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
