import 'package:clean_track/app/data/models/report_model.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class ReportHistoryController extends GetxController {
  RxList<ReportModel> reports = <ReportModel>[].obs;
  Stream<List<ReportModel>> _streamReports() {
    return ReportModel().collectionReference
        .where(ReportModel.REPORTER_ID, isEqualTo: authC.user.id)
        .orderBy(ReportModel.CREATED_AT, descending: true)
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
