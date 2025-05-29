import 'package:clean_track/app/data/models/report_model.dart';
import 'package:clean_track/app/routes/app_pages.dart';
import 'package:get/get.dart';

class ReportDetailController extends GetxController {
  //TODO: Implement ReportDetailController

  Future delete(ReportModel report) async {
    if (report.id is String) {
      await report.delete(report.id!);
      Get.offAllNamed(Routes.HOME);
      Get.snackbar("Success", "Report deleted successfully");
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
