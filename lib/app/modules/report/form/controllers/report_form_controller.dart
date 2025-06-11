import 'dart:io';

import 'package:clean_track/app/data/models/report_model.dart';
import 'package:clean_track/app/helpers/formatter.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:clean_track/app/modules/report/form/controllers/map_picker_controller.dart';
import 'package:clean_track/app/routes/app_pages.dart';
import 'package:clean_track/app/widgets/form_foto.dart';
// import 'package:clean_track/app/widgets/google_map_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:nb_utils/nb_utils.dart';

class ReportFormController extends GetxController {
  //TODO: Implement ReportFormController

  MapPickerController mapPickerController = Get.find<MapPickerController>();

  Rxn<Marker> _marker = Rxn();
  Marker? get marker => this._marker.value;
  set marker(Marker? value) => this._marker.value = value;

  RxString _formFotoMessage = RxString("");
  String get formFotoMessage => this._formFotoMessage.value;
  set formFotoMessage(String value) => this._formFotoMessage.value = value;

  RxString _locationMessage = RxString("");
  String get locationMessage => this._locationMessage.value;
  set locationMessage(String value) => this._locationMessage.value = value;

  RxBool _isLoading = false.obs;
  get isLoading => this._isLoading.value;
  set isLoading(value) => this._isLoading.value = value;

  RxBool _isReview = false.obs;
  get isReview => this._isReview.value;
  set isReview(value) => this._isReview.value = value;

  Rxn<ReportModel> _report = Rxn();
  ReportModel? get report => this._report.value;
  set report(ReportModel? value) => this._report.value = value;

  Rx<FormFoto> _formFoto = FormFoto().obs;
  FormFoto get formFoto => this._formFoto.value;
  set formFoto(value) => this._formFoto.value = value;
  // late GoogleMapPicker locationPicker;
  TextEditingController descC = TextEditingController();
  // TextEditingController latC = TextEditingController();
  // TextEditingController longC = TextEditingController();

  // void onMarkerChanged(LatLng coordinate) {
  //   latC.text = coordinate.latitude.toString();
  //   longC.text = coordinate.longitude.toString();
  // }

  bool validate() {
    var res = true;
    if (formFoto.newPath.isEmpty) {
      formFotoMessage = "Please upload photo";
      res = false;
    } else {
      formFotoMessage = "";
    }
    if (mapPickerController.marker.value == null) {
      locationMessage =
          "Please pick location by click button below or tap on map";
      res = false;
    } else {
      locationMessage = "";
    }
    return res;
  }

  void setReview(bool value) {
    isReview = value;
    formFoto.showButton = !value;
    mapPickerController.isActive = !value;
  }

  Future save() async {
    try {
      isLoading = true;
      report = ReportModel(
        id: report?.id ?? '',
        status: 'Pending',
        reporterId: authC.user.id ?? report?.reporterId ?? '',
        reporterName: authC.user.name ?? report?.reporterName ?? '',
        // reporterLocation: GeoPoint(latC.text.toDouble(), longC.text.toDouble()),
        reporterLocation: geoFromLatLng(
          mapPickerController.marker.value!.position,
        ),
        reporterDescription: descC.text,
        reporterPhoto: report?.reporterPhoto ?? '',
        address: mapPickerController.address,
        area: mapPickerController.area,
        createdAt: report?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      File? file;
      if (formFoto.newPath.isNotEmpty) {
        file = File(formFoto.newPath);
      }
      var res = await report!.save(file: file);
      Get.offAllNamed(Routes.HOME);
      Get.snackbar("Success", "Report created successfully");
      return res;
    } on Exception catch (e) {
      Get.snackbar('error'.tr, e.toString());
      return null;
    } finally {
      isLoading = false;
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
