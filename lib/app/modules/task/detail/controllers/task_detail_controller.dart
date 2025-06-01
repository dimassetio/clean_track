import 'dart:io';

import 'package:clean_track/app/data/models/report_model.dart';
import 'package:clean_track/app/helpers/formatter.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:clean_track/app/widgets/photo_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaskDetailController extends GetxController {
  Rxn<ReportModel> _report = Rxn(Get.arguments);
  ReportModel? get report => this._report.value;
  set report(ReportModel? value) => this._report.value = value;

  Widget statusIcon() {
    switch (report?.status) {
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
    switch (report?.status) {
      case ReportStatus.processing:
        return Colors.yellow;
      case ReportStatus.done:
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  final Rx<CameraPosition> cameraPosition =
      CameraPosition(target: LatLng(-6.200000, 106.816666), zoom: 17).obs;
  final Rx<Marker?> marker = Rx<Marker?>(null);
  final Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);

  Future<void> initLocation() async {
    try {
      if (report?.reporterLocation is GeoPoint) {
        final LatLng userLatLng = LatLng(
          report!.reporterLocation!.latitude,
          report!.reporterLocation!.longitude,
        );
        cameraPosition.value = CameraPosition(target: userLatLng, zoom: 17);
        marker.value = Marker(
          markerId: const MarkerId("selected_location"),
          position: userLatLng,
        );

        mapController.value?.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition.value),
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.value = controller;
    initLocation();
  }

  void delete(ReportModel report) {
    // Your delete logic (possibly call a service)
  }
  RxBool _isLoading = RxBool(false);
  bool get isLoading => this._isLoading.value;
  set isLoading(bool value) => this._isLoading.value = value;

  Future takeTask() async {
    try {
      isLoading = true;
      if (report is ReportModel) {
        report!.status = ReportStatus.notStarted;
        report!.assignedAt = DateTime.now();
        report!.officerId = authC.user.id;
        report!.officerName = authC.user.name;

        return await report!.save();
      }
    } on Exception catch (e) {
      Get.snackbar("Error", "$e");
    } finally {
      isLoading = false;
    }
  }

  Rx<PhotoPicker> _beforePhoto = Rx(PhotoPicker(showFrame: true));
  PhotoPicker get beforePhoto => this._beforePhoto.value;
  set beforePhoto(value) => this._beforePhoto.value = value;

  Future startTrack() async {
    if (report is ReportModel && beforePhoto.newPath.isNotEmpty) {
      try {
        isLoading = true;
        report!.status = ReportStatus.processing;
        report!.startedAt = DateTime.now();

        File? file;
        file = File(beforePhoto.newPath);
        var photoUrl = await report!.uploadFile(file, 'beforePhoto');
        if (photoUrl == null) {
          throw "Failed to upload before photo file";
        }
        report!.officerBeforePhoto = photoUrl;
        return await report!.save();
      } catch (e) {
        Get.snackbar("Error", "$e");
      } finally {
        isLoading = false;
      }
    } else {
      Get.snackbar("Error", "Failed to get report or before photo data");
    }
  }

  void onLocationChanged(Position position) {
    if (report is ReportModel) {
      report!.officerLastLocation = posToGeo(position);
    }
  }

  var _cPhotoPicker1 = PhotoPicker().obs;
  PhotoPicker get cPhotoPicker1 => this._cPhotoPicker1.value;
  var _cPhotoPicker2 = PhotoPicker().obs;
  PhotoPicker get cPhotoPicker2 => this._cPhotoPicker2.value;
  var _cPhotoPicker3 = PhotoPicker().obs;
  PhotoPicker get cPhotoPicker3 => this._cPhotoPicker3.value;

  TextEditingController officerNoteC = TextEditingController();
  List<PhotoPicker> get cPhotoPickers => [
    cPhotoPicker1,
    cPhotoPicker2,
    cPhotoPicker3,
  ];

  Future<ReportModel?> markComplete() async {
    try {
      isLoading = true;
      if (report is ReportModel) {
        // Upload Progress Photo
        List<String> progressPhotos = [];

        for (int i = 0; i < cPhotoPickers.length; i++) {
          final picker = cPhotoPickers[i];
          if (picker.newPath.isNotEmpty) {
            var res = await report!.uploadFile(
              File(picker.newPath),
              "Progress${i + 1}",
            );
            if (res != null) {
              progressPhotos.add(res);
            }
          }
        }

        report!.officerProgressPhoto = progressPhotos;
        report!.status = ReportStatus.done;
        report!.doneAt = DateTime.now();
        report!.taskDuration =
            DateTime.now()
                .difference(report!.startedAt ?? DateTime.now())
                .inSeconds;
        report!.officerNote = officerNoteC.text;
        await report!.save();
        return report;
      }
      return null;
    } catch (e) {
      Get.snackbar("Error", "$e");
      return null;
    } finally {
      isLoading = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ReportModel) {
      _report.bindStream((Get.arguments as ReportModel).stream());
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
