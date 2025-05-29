import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_track/app/data/models/report_model.dart';
import 'package:clean_track/app/helpers/formatter.dart';
import 'package:clean_track/app/helpers/images.dart';
import 'package:clean_track/app/helpers/themes.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:clean_track/app/widgets/circle_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/report_detail_controller.dart';

class ReportDetailView extends GetView<ReportDetailController> {
  ReportDetailView({super.key});

  final ReportModel report = Get.arguments;

  Widget statusIcon() {
    switch (report.status) {
      case "Processing":
        return Icon(Icons.hourglass_empty);
      case "Done":
        return Icon(Icons.check);
      default:
        return Icon(Icons.close);
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

  final Rx<CameraPosition> _cameraPosition =
      CameraPosition(
        target: LatLng(-6.200000, 106.816666), // Default
        zoom: 17,
      ).obs;

  final Rx<Marker?> _marker = Rx<Marker?>(null);
  final Rx<GoogleMapController?> _mapController = Rx<GoogleMapController?>(
    null,
  );
  Future<void> _initLocation() async {
    try {
      if (report.reporterLocation is GeoPoint) {
        LatLng userLatLng = LatLng(
          report.reporterLocation!.latitude,
          report.reporterLocation!.longitude,
        );
        _cameraPosition.value = CameraPosition(target: userLatLng, zoom: 17);
        _marker.value = Marker(
          markerId: const MarkerId("selected_location"),
          position: userLatLng,
        );

        _mapController.value?.animateCamera(
          CameraUpdate.newCameraPosition(_cameraPosition.value),
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController.value = controller;
    _initLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back),
              ),
              tileColor: colorScheme(context).surface,
              title: Text("Report Detail"),
              subtitle: Text("${report.status}"),
              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text("Delete"),
                      onTap: () {
                        showConfirmDialog(
                          context,
                          "Are you sure to delete this report?",
                          onAccept: () {
                            controller.delete(report);
                          },
                        );
                      },
                    ),
                  ];
                },
              ),
              //  IconButton(
              //   onPressed: () {
              //     Get.back();
              //   },
              //   icon: Icon(Icons.close),
              // ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: colorScheme(context).surface,
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child:
                                report.reporterPhoto.isEmptyOrNull
                                    ? Image.asset(png_logo)
                                    : CachedNetworkImage(
                                      imageUrl: report.reporterPhoto!,
                                    ),
                          ),
                        ),
                      ),
                      16.height,
                      Row(
                        children: [
                          CircleContainer(
                            color: statusColor(),
                            padding: EdgeInsets.symmetric(horizontal: 8),
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
                          16.width,
                          Expanded(
                            child: Text(
                              "Submitted: " +
                                  dateTimeFormatter(report.createdAt),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      Row(
                        children: [
                          Icon(Icons.note, color: primaryColor(context)),
                          12.width,
                          Expanded(child: Text("Description")),
                        ],
                      ),
                      8.height,
                      Text(
                        report.reporterDescription ?? "",
                        textAlign: TextAlign.start,
                      ),
                      16.height,
                      Row(
                        children: [
                          Icon(Icons.location_on, color: primaryColor(context)),
                          12.width,
                          Expanded(
                            child: FutureBuilder(
                              future: getAddress(geo: report.reporterLocation),
                              builder: (context, future) {
                                return Text(future.data ?? 'Location');
                              },
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      AspectRatio(
                        aspectRatio: 2 / 1,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Obx(
                              () => GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: _cameraPosition.value,
                                markers:
                                    _marker.value != null
                                        ? {_marker.value!}
                                        : {},
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      16.height,
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: primaryColor(context),
                          ),
                          12.width,
                          Expanded(
                            child: Text(
                              "Submitted: " +
                                  dateTimeFormatter(report.createdAt),
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      if (report.status == "Pending")
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          color: Colors.red[100],
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red[200],
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.report, color: Colors.red[800]),
                                    12.width,
                                    Text(
                                      "Not Validated",
                                      style: textTheme(context).titleMedium
                                          ?.copyWith(color: Colors.red[800]),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Your report is currently being reviewed. Please wait until it's validated by our team.",
                                  textAlign: TextAlign.center,
                                  style: textTheme(context).bodyMedium
                                      ?.copyWith(color: Colors.red[800]),
                                ),
                              ),
                            ],
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
