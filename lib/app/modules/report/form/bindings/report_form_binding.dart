import 'package:clean_track/app/modules/report/form/controllers/map_picker_controller.dart';
import 'package:get/get.dart';

import '../controllers/report_form_controller.dart';

class ReportFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportFormController>(() => ReportFormController());
    Get.lazyPut<MapPickerController>(() => MapPickerController());
  }
}
