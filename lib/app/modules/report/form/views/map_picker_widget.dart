import 'package:clean_track/app/helpers/themes.dart';
import 'package:clean_track/app/modules/report/form/controllers/map_picker_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerWidget extends StatelessWidget {
  MapPickerWidget({super.key});

  final MapPickerController controller = Get.put(MapPickerController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            leading:
                controller.isLoading
                    ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                    : Icon(
                      Icons.my_location_rounded,
                      color: primaryColor(context),
                    ),
            title: Obx(
              () => Text(
                controller.address.isEmpty ? "My Location" : controller.address,
              ),
            ),
            onTap:
                !controller.isActive
                    ? null
                    : () async {
                      await controller.initLocation();
                    },
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: controller.onMapCreated,
              initialCameraPosition: controller.cameraPosition.value,
              onTap: controller.isActive ? controller.onMapTap : null,
              markers:
                  controller.marker.value != null
                      ? {controller.marker.value!}
                      : {},
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                if (controller.isActive)
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
