import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_track/app/helpers/images.dart';
import 'package:clean_track/app/helpers/themes.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:clean_track/app/modules/report/form/views/map_picker_widget.dart';
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () =>
                              (controller.isReview)
                                  ? Column(
                                    children: [
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
                                          style: textTheme(
                                            context,
                                          ).bodyMedium?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      20.height,
                                    ],
                                  )
                                  : SizedBox(),
                        ),
                        Text(
                          "Upload Photo",
                          style: textTheme(context).titleMedium,
                        ),
                        Obx(
                          () => CardColumn(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            children: [
                              Obx(() => controller.formFoto),
                              Obx(
                                () => Text(
                                  controller.formFoto.showButton.toString(),
                                ),
                              ),
                              Text(
                                controller.formFotoMessage,
                                style: textTheme(context).labelMedium?.copyWith(
                                  color: colorScheme(context).error,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Short Description",
                          style: textTheme(context).titleMedium,
                        ),
                        4.height,
                        Obx(
                          () => CTextfield(
                            isReadOnly: controller.isReview,
                            isBordered: true,
                            controller: controller.descC,
                            borderRadius: 8,
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 16,
                            ),
                          ),
                        ),
                        16.height,
                        Text("Location", style: textTheme(context).titleMedium),
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
                            child: MapPickerWidget(),
                            // child: controller.locationPicker,
                          ),
                        ),
                        Obx(
                          () => Column(
                            children: [
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
                                        if ((_formKey.currentState
                                                    ?.validate() ??
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
                                  backgroundColor:
                                      colorScheme(context).onSecondary,
                                  foregroundColor:
                                      colorScheme(context).secondary,
                                  title: "Go Back",
                                  onPressed: () {
                                    controller.setReview(false);
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
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
