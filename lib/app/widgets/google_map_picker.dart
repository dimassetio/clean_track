import 'package:clean_track/app/helpers/formatter.dart';
import 'package:clean_track/app/helpers/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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

  RxString _address = ''.obs;
  String get address => this._address.value;
  set address(value) => this._address.value = value;

  RxString _area = ''.obs;
  String get area => this._area.value;
  set area(value) => this._area.value = value;

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
      getAddressAndArea(
        geo: GeoPoint(position.latitude, position.longitude),
      ).then((value) {
        if (value.length == 2) {
          address = value[0];
          area = value[1];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
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
            title: Obx(() => Text(address.isEmpty ? "My Location" : address)),
            onTap:
                !isActive
                    ? null
                    : () async {
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
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                if (isActive)
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
