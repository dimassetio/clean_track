import 'package:clean_track/app/helpers/formatter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerController extends GetxController {
  final Rx<CameraPosition> cameraPosition =
      CameraPosition(
        target: LatLng(-6.200000, 106.816666), // Default
        zoom: 17,
      ).obs;

  final Rx<Marker?> marker = Rx<Marker?>(null);
  final Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);

  RxBool _isLoading = false.obs;
  set isLoading(value) => this._isLoading.value = value;
  get isLoading => this._isLoading.value;

  RxBool _isActive = true.obs;
  set isActive(value) => this._isActive.value = value;
  get isActive => this._isActive.value;

  RxString _address = ''.obs;
  String get address => this._address.value;
  set address(value) => this._address.value = value;

  RxString _area = ''.obs;
  String get area => this._area.value;
  set area(value) => this._area.value = value;

  Future<void> initLocation() async {
    try {
      isLoading = true;
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Location Error", "Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Permission Denied", "Location permission is denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Permission Denied",
          "Location permission permanently denied.",
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      LatLng userLatLng = LatLng(position.latitude, position.longitude);
      cameraPosition.value = CameraPosition(target: userLatLng, zoom: 17);
      marker.value = Marker(
        markerId: const MarkerId("selected_location"),
        position: userLatLng,
      );

      mapController.value?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition.value),
      );

      var res = await getAddressAndArea(position: position);
      if (res.length == 2) {
        address = res[0];
        area = res[1];
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.value = controller;
    initLocation();
  }

  void onMapTap(LatLng position) {
    marker.value = Marker(
      markerId: const MarkerId("selected_location"),
      position: position,
    );
    getAddressAndArea(
      position: Position.fromMap({
        'latitude': position.latitude,
        'longitude': position.longitude,
      }),
    ).then((value) {
      if (value.length == 2) {
        address = value[0];
        area = value[1];
      }
    });
  }
}
