import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_track/app/data/models/report_model.dart';
import 'package:clean_track/app/helpers/formatter.dart';
import 'package:clean_track/app/helpers/images.dart';
import 'package:clean_track/app/helpers/themes.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:clean_track/app/routes/app_pages.dart';
import 'package:clean_track/app/widgets/BottomNav.dart';
import 'package:clean_track/app/widgets/circle_container.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav(currentIndex: 0),
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
              subtitle: Text("Welcome Back!"),
              trailing: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "My Report Status",
                        style: textTheme(context).titleLarge,
                      ),
                      4.height,
                      Text(
                        "Track the progress of your current and past waste reports in real time",
                        style: textTheme(
                          context,
                        ).bodyMedium?.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "Current Report",
                          style: textTheme(context).titleMedium,
                        ),
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child:
                              controller.activeReports.isEmpty
                                  ? Text(
                                    "You don't have active Report",
                                    style: textTheme(context).bodyMedium,
                                  )
                                  : ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: controller.activeReports.length,
                                    itemBuilder: (context, index) {
                                      var report =
                                          controller.activeReports[index];
                                      return ReportCard(report);
                                    },
                                  ),
                        ),
                      ),
                      Container(
                        width: Get.width,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.toNamed(Routes.REPORT_FORM);
                          },
                          label: Text(
                            "Report Waste",
                            style: textTheme(context).titleLarge?.copyWith(
                              color: colorScheme(context).onSecondary,
                            ),
                          ),
                          icon: Icon(
                            Icons.add,
                            size: 32,
                            color: colorScheme(context).onSecondary,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme(context).secondary,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Past Report",
                              style: textTheme(context).titleMedium,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text("View All"),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () =>
                            controller.pastReports.isEmpty
                                ? Text(
                                  "You don't have past Report",
                                  style: textTheme(context).bodyMedium,
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: controller.pastReports.length,
                                  itemBuilder: (context, index) {
                                    var report = controller.pastReports[index];
                                    return ReportCard(report);
                                  },
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

class ReportCard extends StatelessWidget {
  ReportCard(this.report, {super.key});
  final ReportModel report;

  Widget statusIcon() {
    switch (report.status) {
      case "Processing":
        return Icon(Icons.hourglass_empty, size: 18);
      case "Done":
        return Icon(Icons.check, size: 18);
      default:
        return Icon(Icons.close, size: 18);
    }
  }

  Color statusColor() {
    switch (report.status) {
      case "Processing":
        return AppColors.warning;
      case "Done":
        return AppColors.primary;
      default:
        return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.REPORT_DETAIL, arguments: report);
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    report.reporterPhoto.isEmptyOrNull
                        ? Image.asset(png_logo, height: 40, width: 40)
                        : CachedNetworkImage(
                          imageUrl: report.reporterPhoto!,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleContainer(
                      color: statusColor(),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          statusIcon(),
                          8.width,
                          Text(report.status ?? "Status"),
                        ],
                      ),
                    ),
                    8.height,
                    Text(
                      report.reporterDescription ?? "Nama Laporan",
                      style: textTheme(context).titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      dateTimeFormatter(report.createdAt, def: '-'),
                      style: textTheme(
                        context,
                      ).labelMedium?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.remove_red_eye_sharp,
                color: colorScheme(context).secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
