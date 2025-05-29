import 'package:clean_track/app/helpers/themes.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPicker extends StatelessWidget {
  final Function(LatLng)? onMarkerChanged;

  GoogleMapPicker({super.key, this.onMarkerChanged});

  final Rx<CameraPosition> _cameraPosition =
      CameraPosition(
        target: LatLng(-6.200000, 106.816666), // Default
        zoom: 17,
      ).obs;

  final Rx<Marker?> _marker = Rx<Marker?>(null);
  final Rx<GoogleMapController?> _mapController = Rx<GoogleMapController?>(
    null,
  );

  RxBool _isLoading = false.obs;
  set isLoading(value) => this._isLoading.value = value;
  get isLoading => this._isLoading.value;

  RxBool _isActive = true.obs;
  set isActive(value) => this._isActive.value = value;
  get isActive => this._isActive.value;

  Future<void> _initLocation() async {
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
      _cameraPosition.value = CameraPosition(target: userLatLng, zoom: 17);
      _marker.value = Marker(
        markerId: const MarkerId("selected_location"),
        position: userLatLng,
      );
      onMarkerChanged!(userLatLng);

      _mapController.value?.animateCamera(
        CameraUpdate.newCameraPosition(_cameraPosition.value),
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController.value = controller;
    _initLocation();
  }

  void _onMapTap(LatLng position) {
    _marker.value = Marker(
      markerId: const MarkerId("selected_location"),
      position: position,
    );
    if (onMarkerChanged != null) {
      onMarkerChanged!(position);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          if (isActive)
            ListTile(
              leading:
                  isLoading
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      )
                      : Icon(
                        Icons.my_location_rounded,
                        color: primaryColor(context),
                      ),
              title: Text("My Location"),
              onTap: () async {
                await _initLocation();
              },
            ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _cameraPosition.value,
              onTap: isActive ? _onMapTap : null,
              markers: _marker.value != null ? {_marker.value!} : {},
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
