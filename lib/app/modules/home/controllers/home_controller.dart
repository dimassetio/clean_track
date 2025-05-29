import 'package:clean_track/app/data/models/report_model.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxList<ReportModel> reports = <ReportModel>[].obs;
  List<ReportModel> get activeReports =>
      reports
          .where((report) => ["Pending", "Processing"].contains(report.status))
          .toList();

  List<ReportModel> get pastReports =>
      reports
          .where((report) => !["Pending", "Processing"].contains(report.status))
          .toList();

  Stream<List<ReportModel>> _streamReports() {
    return ReportModel().collectionReference
        .where(ReportModel.REPORTER_ID, isEqualTo: authC.user.id)
        .snapshots()
        .map(
          (stream) =>
              stream.docs.map((doc) => ReportModel.fromSnapshot(doc)).toList(),
        );
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    reports.bindStream(_streamReports());
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
