import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_track/app/data/models/report_model.dart';
import 'package:clean_track/app/helpers/formatter.dart';
import 'package:clean_track/app/helpers/images.dart';
import 'package:clean_track/app/helpers/themes.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:clean_track/app/routes/app_pages.dart';
import 'package:clean_track/app/widgets/bottom_nav_officer.dart';
import 'package:clean_track/app/widgets/button.dart';
import 'package:clean_track/app/widgets/card_column.dart';
import 'package:clean_track/app/widgets/circle_container.dart';
import 'package:flutter/material.dart';
import 'package:clean_track/app/widgets/BottomNav.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/officer_controller.dart';

class OfficerView extends GetView<OfficerController> {
  const OfficerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavOfficer(currentIndex: 0),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text("Hello", style: textTheme(context).labelMedium),
              subtitle: Text(
                "Officer ${authC.user.name}",
                style: textTheme(context).titleMedium,
              ),

              trailing: CircleAvatar(
                backgroundImage: AssetImage(png_default_profile),
                foregroundImage:
                    authC.user.foto.isEmptyOrNull
                        ? null
                        : CachedNetworkImageProvider(authC.user.foto!),
              ),
              tileColor: colorScheme(context).surface,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Obx(
                        () => Row(
                          children: [
                            TaskStatusCard(
                              backgroundColor: Colors.red[200],
                              icon: Icons.report,
                              iconColor: Colors.red[800],
                              title: "Not Started",
                              count: "${controller.cNotStarted}",
                              textColor: Colors.red[800],
                            ),
                            TaskStatusCard(
                              backgroundColor: Colors.yellow[200],
                              icon: Icons.hourglass_empty_rounded,
                              iconColor: Colors.yellow[800],
                              title: "In Progress",
                              count: "${controller.cProcessing}",
                              textColor: Colors.yellow[800],
                            ),
                            TaskStatusCard(
                              backgroundColor: Colors.green[200],
                              icon: Icons.check_circle_rounded,
                              iconColor: Colors.green[800],
                              title: "Done",
                              count: "${controller.cDone}",
                              textColor: Colors.green[800],
                            ),
                          ],
                        ),
                      ),
                      20.height,
                      CardColumn(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.list, color: primaryColor(context)),
                              8.width,
                              Expanded(
                                child: Text(
                                  "Active Task",
                                  style: textTheme(context).titleMedium,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.filter_list),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.keyboard_arrow_down),
                              ),
                            ],
                          ),
                          16.height,
                          Obx(
                            () => ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: controller.activeReport.length,
                              itemBuilder: (context, index) {
                                var report = controller.activeReport[index];
                                return OfficerTaskCard(report: report);
                              },
                            ),
                          ),
                        ],
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

class OfficerTaskCard extends StatelessWidget {
  const OfficerTaskCard({super.key, required this.report});

  final ReportModel report;

  Widget statusIcon() {
    switch (report.status) {
      case ReportStatus.processing:
        return Icon(Icons.hourglass_empty, color: statusColor()[800]);
      case ReportStatus.done:
        return Icon(Icons.check, color: statusColor()[800]);
      case ReportStatus.cancelled:
        return Icon(Icons.close, color: statusColor()[800]);
      default:
        return Icon(Icons.report, color: statusColor()[800]);
    }
  }

  MaterialColor statusColor() {
    switch (report.status) {
      case ReportStatus.processing:
        return Colors.yellow;
      case ReportStatus.done:
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardColumn(
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: primaryColor(context)),
            8.width,
            Expanded(
              child: FutureBuilder(
                future: getAddress(geo: report.reporterLocation),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? "Location address",
                    style: textTheme(context).bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
            4.width,
            Column(
              children: [
                Text("Reported", style: textTheme(context).labelSmall),
                2.height,
                Text(
                  dateTimeFormatter(report.createdAt, format: 'd/M/yy\nH:m'),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
        4.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleContainer(
              color: statusColor()[200],
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                children: [
                  statusIcon(),
                  4.width,
                  Text(
                    "${report.status}",
                    style: textTheme(
                      context,
                    ).bodyMedium?.copyWith(color: statusColor()[800]),
                  ),
                ],
              ),
            ),
            8.height,
            CustomButton(
              title: "View Details",
              icon: Icon(
                Icons.arrow_forward_rounded,
                color: colorScheme(context).onPrimary,
              ),
              onPressed: () {
                Get.toNamed(Routes.TASK_DETAIL, arguments: report);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class TaskStatusCard extends StatelessWidget {
  final Color? backgroundColor;
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String count;
  final Color? textColor;

  const TaskStatusCard({
    Key? key,
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.count,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: CardColumn(
        crossAxis: CrossAxisAlignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: backgroundColor,
        children: [
          500.width,
          Icon(icon, color: iconColor),
          8.height,
          Text(title, style: textTheme.titleSmall?.copyWith(color: textColor)),
          8.height,
          Text(
            count,
            style: textTheme.titleLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          8.height,
          Text(
            "Tasks",
            style: textTheme.titleSmall?.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
