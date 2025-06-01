import 'package:clean_track/app/data/models/report_model.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class OfficerController extends GetxController {
  RxList<ReportModel> openReports = <ReportModel>[].obs;
  RxList<ReportModel> userReports = <ReportModel>[].obs;
  List<ReportModel> get activeReport => [
    ...openReports,
    ...userReports.where(
      (report) => [
        ReportStatus.notStarted,
        ReportStatus.processing,
      ].contains(report.status),
    ),
  ];
  int get cNotStarted =>
      userReports
          .where((report) => report.status == ReportStatus.notStarted)
          .length;
  int get cProcessing =>
      userReports
          .where((report) => report.status == ReportStatus.processing)
          .length;
  int get cDone =>
      userReports.where((report) => report.status == ReportStatus.done).length;

  Stream<List<ReportModel>> _streamOpenReports() {
    return ReportModel().collectionReference
        .where(ReportModel.STATUS, isEqualTo: ReportStatus.pending)
        .snapshots()
        .map(
          (stream) =>
              stream.docs.map((doc) => ReportModel.fromSnapshot(doc)).toList(),
        );
  }

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
    openReports.bindStream(_streamOpenReports());
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
