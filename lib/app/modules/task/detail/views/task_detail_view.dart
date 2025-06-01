import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_track/app/data/models/report_model.dart';
import 'package:clean_track/app/helpers/formatter.dart';
import 'package:clean_track/app/helpers/images.dart';
import 'package:clean_track/app/helpers/themes.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:clean_track/app/routes/app_pages.dart';
import 'package:clean_track/app/widgets/button.dart';
import 'package:clean_track/app/widgets/card_column.dart';
import 'package:clean_track/app/widgets/circle_container.dart';
import 'package:clean_track/app/widgets/photo_picker.dart';
import 'package:clean_track/app/widgets/text_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/task_detail_controller.dart';

class TaskDetailView extends GetView<TaskDetailController> {
  const TaskDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => ListTile(
                leading: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.chevron_left),
                ),
                tileColor: colorScheme(context).surface,
                title: const Text("Task Details", textAlign: TextAlign.center),
                trailing: CircleAvatar(
                  backgroundImage: AssetImage(png_default_profile),
                  foregroundImage:
                      authC.user.foto.isEmptyOrNull
                          ? null
                          : CachedNetworkImageProvider(authC.user.foto!),
                ),
              ),
            ),
            Obx(() {
              if (controller.report == null) {
                return Text("Gagal memuat data report");
              }
              return TaskDetailWidget(controller: controller);
            }),
          ],
        ),
      ),
    );
  }
}

class TaskDetailWidget extends StatelessWidget {
  const TaskDetailWidget({super.key, required this.controller});

  final TaskDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            CardColumn(
              padding: 12,
              children: [
                AspectRatio(
                  aspectRatio: 2 / 1,
                  child: Card(
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Obx(
                        () => GoogleMap(
                          onMapCreated: controller.onMapCreated,
                          initialCameraPosition:
                              controller.cameraPosition.value,
                          markers:
                              controller.marker.value != null
                                  ? {controller.marker.value!}
                                  : {},
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        ),
                      ),
                    ),
                  ),
                ),
                // Report Date
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.report,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        8.width,
                        Text("Reported", style: textTheme(context).labelMedium),
                      ],
                    ),
                    16.width,
                    Expanded(
                      child: Text(
                        dateTimeFormatter(
                          controller.report?.createdAt,
                          format: 'd/M/yy | H:m',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                16.height,
                FutureBuilder(
                  future: getAddress(geo: controller.report?.reporterLocation),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? 'Location',
                      style: textTheme(
                        context,
                      ).titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    );
                  },
                ),
                8.height,
                Text(
                  "Report Description",
                  style: textTheme(context).titleSmall,
                ),
                8.height,
                Text(controller.report?.reporterDescription ?? '-'),
                16.height,
                Text("Reporter's Photo", style: textTheme(context).titleSmall),
                8.height,
                Container(
                  width: Get.width,
                  decoration: boxDecorationDefault(
                    borderRadius: BorderRadius.circular(16),
                    color: colorScheme(context).surface,
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child:
                          controller.report!.reporterPhoto.isEmptyOrNull
                              ? Image.asset(png_logo)
                              : CachedNetworkImage(
                                imageUrl: controller.report!.reporterPhoto!,
                              ),
                    ),
                  ),
                ),
                16.height,
                Row(
                  children: [
                    CircleContainer(
                      color: controller.statusColor()[200],
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Row(
                        children: [
                          controller.statusIcon(),
                          4.width,
                          Text(
                            "${controller.report!.status}",
                            style: textTheme(context).bodyMedium?.copyWith(
                              color: controller.statusColor()[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            16.height,
            if (controller.report?.status == ReportStatus.pending)
              Obx(
                () => CustomButton(
                  title: "Take Task",
                  onPressed:
                      controller.isLoading
                          ? null
                          : () async {
                            await controller.takeTask();
                          },
                ),
              ),
            if (controller.report?.status == ReportStatus.notStarted)
              CardColumn(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.image, size: 20),
                          8.width,
                          Text(
                            "Take 'Before' Photo",
                            style: textTheme(context).titleMedium,
                          ),
                        ],
                      ),
                      CircleContainer(
                        color: Colors.red[100],
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Text(
                          "Required",
                          style: textTheme(
                            context,
                          ).labelMedium?.copyWith(color: Colors.red[800]),
                        ),
                      ),
                    ],
                  ),
                  12.height,
                  controller.beforePhoto,
                  12.height,
                  Obx(
                    () => CustomButton(
                      icon: Icon(
                        Icons.play_arrow,
                        color: colorScheme(context).onSecondary,
                      ),
                      title:
                          controller.isLoading ? "Loading..." : "Start Track",
                      onPressed:
                          controller.beforePhoto.newPath.isEmpty ||
                                  controller.isLoading
                              ? null
                              : () async {
                                await controller.startTrack();
                              },
                    ),
                  ),
                ],
              ),
            if (controller.report?.officerId == authC.user.id &&
                controller.report?.status == ReportStatus.processing) ...[
              // CardColumn(
              //   children: [
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Row(
              //           children: [
              //             Icon(Icons.my_location_rounded),
              //             8.width,
              //             Text(
              //               "Your Location",
              //               style: textTheme(context).titleMedium,
              //             ),
              //           ],
              //         ),
              //         Text(
              //           "Last updated: Just now",
              //           style: textTheme(context).labelSmall,
              //         ),
              //       ],
              //     ),
              //     8.height,
              //     AspectRatio(
              //       aspectRatio: 2 / 1,
              //       child: LiveLocationMapWidget(
              //         onLocationChanged: (position) {},
              //       ),
              //     ),
              //   ],
              // ),
              CardColumn(
                margin: EdgeInsets.only(bottom: 16),
                color: colorScheme(context).surface,
                children: [
                  Row(
                    children: [
                      Icon(Icons.photo_library_rounded),
                      8.width,
                      Text(
                        "Upload Cleaning Photos (1-3)",
                        style: textTheme(context).titleSmall,
                      ),
                    ],
                  ),
                  16.height,
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: boxDecorationDefault(
                              color: Colors.grey[100],
                            ),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: controller.cPhotoPicker1,
                            ),
                          ),
                        ),
                        8.width,
                        Expanded(
                          child: Container(
                            decoration: boxDecorationDefault(
                              color: Colors.grey[100],
                            ),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child:
                                  controller.cPhotoPicker1.newPath.isEmpty
                                      ? null
                                      : controller.cPhotoPicker2,
                            ),
                          ),
                        ),
                        8.width,
                        Expanded(
                          child: Container(
                            decoration: boxDecorationDefault(
                              color: Colors.grey[100],
                            ),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child:
                                  controller.cPhotoPicker2.newPath.isEmpty
                                      ? null
                                      : controller.cPhotoPicker3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children:
                        [
                          Icon(Icons.warning, color: AppColors.warning),
                          Text("At least 1 photo is required"),
                        ].toList(),
                  ),
                ],
              ),
              CardColumn(
                margin: EdgeInsets.only(bottom: 16),
                children: [
                  Row(children: [Icon(Icons.note), 8.width, Text("Add Notes")]),
                  8.height,
                  CTextfield(
                    controller: controller.officerNoteC,
                    isBordered: true,
                    borderRadius: 8,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    hint: "Add any additional notes",
                  ),
                ],
              ),
              Obx(
                () => CustomButton(
                  title:
                      controller.isLoading ? "Loading..." : "Mark as Complete",
                  icon: Icon(
                    Icons.check,
                    color: colorScheme(context).onSecondary,
                  ),
                  onPressed:
                      (controller.isLoading ||
                              controller.cPhotoPicker1.newPath.isEmpty)
                          ? null
                          : () async {
                            showConfirmDialogCustom(
                              context,
                              onAccept: (ctx) async {
                                var res = await controller.markComplete();
                                if (res != null) {
                                  showDialog(
                                    context: ctx,
                                    builder: (context) {
                                      return TaskCompleteDialog();
                                    },
                                  );
                                }
                              },
                              title: "Are you sure?",
                              subTitle:
                                  "Please confirm all information and photos are correct before submitting",
                              positiveText: "Submit",
                            );
                          },
                ),
              ),
            ],
            if (controller.report?.status == ReportStatus.done)
              CardColumn(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green[700]),
                          8.width,
                          Text(
                            "Completed At",
                            style: textTheme(
                              context,
                            ).titleMedium?.copyWith(color: Colors.green[700]),
                          ),
                        ],
                      ),
                      Text(dateTimeFormatter(controller.report!.doneAt)),
                    ],
                  ),
                  16.height,
                  Row(
                    children: [
                      Icon(Icons.image, size: 20),
                      8.width,
                      Text(
                        "Officer 'Before' Photo",
                        style: textTheme(context).titleMedium,
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    decoration: boxDecorationDefault(color: Colors.grey[100]),
                    child: PhotoPicker(
                      enableButton: false,
                      oldPath: controller.report?.officerBeforePhoto ?? '',
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.photo_library_rounded, size: 20),
                      8.width,
                      Text(
                        "Progress Photo",
                        style: textTheme(context).titleMedium,
                      ),
                    ],
                  ),
                  ListView.builder(
                    itemCount:
                        controller.report!.officerProgressPhoto?.length ?? 0,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          16.height,
                          Text("Progress photo ${index + 1}"),
                          Container(
                            margin: EdgeInsets.only(top: 16),
                            decoration: boxDecorationDefault(
                              color: Colors.grey[100],
                            ),
                            child: PhotoPicker(
                              enableButton: false,
                              oldPath:
                                  controller
                                      .report!
                                      .officerProgressPhoto![index],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  16.height,
                  Row(
                    children: [
                      Icon(Icons.photo_library_rounded, size: 20),
                      8.width,
                      Text(
                        "Officer's Note",
                        style: textTheme(context).titleMedium,
                      ),
                    ],
                  ),
                  8.height,
                  Text(controller.report!.officerNote ?? "-"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class TaskCompleteDialog extends StatelessWidget {
  const TaskCompleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.done, color: primaryColor(context), size: 40),
            16.height,
            Text(
              "Task Completed & Report Submitted",
              textAlign: TextAlign.center,
              style: textTheme(context).titleLarge?.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            8.height,
            Text(
              "Thank you for your hard work. The task is marked as completed and your report has been submitted",
              textAlign: TextAlign.center,
            ),
            16.height,
            CustomButton(
              title: "View Report History",
              icon: Icon(Icons.history, color: colorScheme(context).onPrimary),
              onPressed: () {
                Get.offNamed(Routes.TASK_HISTORY);
              },
            ),
            16.height,
            CustomButton(
              title: "Back to Home",
              foregroundColor: AppColors.accentDark,
              backgroundColor: colorScheme(context).surface,
              icon: Icon(Icons.home, color: AppColors.accentDark),

              onPressed: () {
                Get.offNamed(Routes.OFFICER);
              },
            ),
          ],
        ),
      ),
    );
  }
}
