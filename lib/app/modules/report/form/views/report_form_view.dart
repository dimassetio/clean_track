import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_track/app/helpers/images.dart';
import 'package:clean_track/app/helpers/themes.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:clean_track/app/widgets/button.dart';
import 'package:clean_track/app/widgets/card_column.dart';
import 'package:clean_track/app/widgets/text_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/report_form_controller.dart';

class ReportFormView extends GetView<ReportFormController> {
  ReportFormView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              subtitle: Text("Waste Report"),
              trailing: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.close),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.isReview) ...[
                            Center(
                              child: Text(
                                "Review Your Report",
                                style: textTheme(context).titleLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            4.height,
                            Center(
                              child: Text(
                                "Double check your waste report before submitting. You can go back to edit if needed",
                                style: textTheme(context).bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            20.height,
                          ],
                          Text(
                            "Upload Photo",
                            style: textTheme(context).titleMedium,
                          ),
                          CardColumn(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            children: [
                              controller.formFoto,
                              Obx(
                                () => Text(
                                  controller.formFotoMessage,
                                  style: textTheme(
                                    context,
                                  ).labelMedium?.copyWith(
                                    color: colorScheme(context).error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Short Description",
                            style: textTheme(context).titleMedium,
                          ),
                          4.height,
                          CTextfield(
                            isReadOnly: controller.isReview,
                            isBordered: true,
                            controller: controller.descC,
                            borderRadius: 8,
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 16,
                            ),
                          ),
                          16.height,
                          Text(
                            "Location",
                            style: textTheme(context).titleMedium,
                          ),
                          Obx(
                            () => Text(
                              controller.locationMessage,
                              style: textTheme(context).labelMedium?.copyWith(
                                color: colorScheme(context).error,
                              ),
                            ),
                          ),
                          8.height,
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            width: double.infinity,
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: controller.locationPicker,
                            ),
                          ),
                          if (!controller.isReview)
                            CustomButton(
                              icon: Icon(
                                Icons.send,
                                color: colorScheme(context).onSecondary,
                              ),
                              title: "Submit Report",
                              onPressed: () {
                                if ((_formKey.currentState?.validate() ??
                                        false) &&
                                    controller.validate()) {
                                  controller.setReview(true);
                                }
                              },
                            ),
                          if (controller.isReview) ...[
                            controller.isLoading
                                ? LinearProgressIndicator()
                                : CustomButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: colorScheme(context).onSecondary,
                                  ),
                                  title: "Confirm Submit",
                                  onPressed: () {
                                    if ((_formKey.currentState?.validate() ??
                                            false) &&
                                        controller.validate()) {
                                      controller.save();
                                    }
                                  },
                                ),
                            16.height,
                            CustomButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: colorScheme(context).secondary,
                              ),
                              backgroundColor: colorScheme(context).onSecondary,
                              foregroundColor: colorScheme(context).secondary,
                              title: "Go Back",
                              onPressed: () {
                                controller.setReview(false);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
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

// class PickLocationWidget extends StatelessWidget {
//   PickLocationWidget({super.key});

//   late GoogleMapController mapController;
//   final Rx<CameraPosition> cameraPosition =
//       CameraPosition(
//         target: LatLng(-6.200000, 106.816666), // Default: Jakarta
//         zoom: 17,
//       ).obs;

//   final Rxn<Marker> _marker = Rxn();

//   void _onTap(LatLng value) {
//     _marker.value = Marker(
//       markerId: MarkerId('pickedLocation'),
//       position: value,
//       draggable: true,
//     );
//   }

//   void setMapController(GoogleMapController controller) {
//     mapController = controller;
//   }

//   Future<void> determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Get.snackbar("Location Error", "Location services are disabled.");
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Get.snackbar("Permission Denied", "Location permission is denied.");
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       Get.snackbar(
//         "Permission Denied",
//         "Location permission is permanently denied.",
//       );
//       return;
//     }

//     Position position = await Geolocator.getCurrentPosition();
//     LatLng userLatLng = LatLng(position.latitude, position.longitude);
//     cameraPosition.value = CameraPosition(target: userLatLng, zoom: 17);

//     mapController.animateCamera(
//       CameraUpdate.newCameraPosition(cameraPosition.value),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(
//             height: Get.height / 2,
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: Const.defaultCoordinate,
//                 zoom: 17,
//               ),
//               onTap: _onTap,
//               markers: _marker.value == null ? {} : {_marker.value!},
//               myLocationButtonEnabled: true,
//               myLocationEnabled: true,
//             ),
//           ),
//           16.height,
//           Text(
//             '${'pickedLocatioin'.tr}: ${_marker.value == null ? '' : ' ${_marker.value!.position.latitude}, ${_marker.value!.position.longitude}'}',
//           ),
//           CustomButton(
//             title: _marker.value == null ? 'cancel'.tr : 'set'.tr,
//             onPressed: () {
//               Get.back(result: _marker.value);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
