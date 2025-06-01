import 'package:clean_track/app/data/models/report_model.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class TaskHistoryController extends GetxController {
  //TODO: Implement TaskHistoryController
  RxList<ReportModel> userReports = <ReportModel>[].obs;

  Stream<List<ReportModel>> _streamUserReports() {
    return ReportModel().collectionReference
        .where(ReportModel.OFFICER_ID, isEqualTo: authC.user.id)
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
    userReports.bindStream(_streamUserReports());
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
