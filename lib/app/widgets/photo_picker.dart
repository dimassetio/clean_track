// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'dart:io';

import 'package:clean_track/app/helpers/images.dart';
import 'package:flutter/material.dart';
import 'package:clean_track/app/helpers/themes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

getImage(ImageSource source) async {
  try {
    return await ImagePicker().pickImage(source: source);
  } catch (e) {
    Get.snackbar("Error", e.toString());
  }
}

Future<XFile?> imagePickerBottomSheet(BuildContext context) async {
  XFile? result;

  await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder:
        (context) => Container(
          height: 200,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 16, left: 16),
                child: Text("Image Source"),
              ),
              ListTile(
                title: Text("Camera"),
                leading: Icon(Icons.camera, color: primaryColor(context)),
                onTap: () async {
                  result = await getImage(ImageSource.camera);
                  Get.back();
                },
              ),
              ListTile(
                title: Text("Gallery"),
                leading: Icon(Icons.photo, color: primaryColor(context)),
                onTap: () async {
                  result = await getImage(ImageSource.gallery);
                  Get.back();
                },
              ),
            ],
          ),
        ),
  );
  return result;
}

class PhotoPicker extends StatelessWidget {
  String oldPath = '';
  String defaultPath;
  bool enableButton = true;
  bool showFrame;
  bool forceCamera;
  double? height;
  double? width;
  void Function(String)? onImagePicked;
  PhotoPicker({
    this.oldPath = '',
    this.defaultPath = png_logo,
    this.enableButton = true,
    this.showFrame = false,
    this.forceCamera = false,
    this.height,
    this.width,
    this.onImagePicked,
  });
  // final ImagePicker _picker = ImagePicker();
  var xfoto = ''.obs;
  String get newPath => xfoto.value;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration:
            showFrame
                ? boxDecorationDefault(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[100],
                )
                : null,
        constraints: BoxConstraints(maxHeight: 200),
        child: InkWell(
          onTap:
              !enableButton
                  ? null
                  : () async {
                    var res =
                        forceCamera
                            ? await getImage(ImageSource.camera)
                            : await imagePickerBottomSheet(context);
                    if (res is XFile) {
                      xfoto.value = res.path;
                      if (onImagePicked != null) {
                        onImagePicked!(res.path);
                      }
                    }
                  },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child:
                newPath.isNotEmpty
                    ? Image.file(File(newPath), fit: BoxFit.cover)
                    : oldPath.isNotEmpty
                    ? Image.network(oldPath, fit: BoxFit.cover)
                    : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          size: 40,
                          color: AppColors.textSecondary,
                        ),
                        8.height,
                        if (enableButton)
                          Text(
                            "Tap to upload photo",
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}
