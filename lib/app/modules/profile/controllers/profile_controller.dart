import 'package:clean_track/app/data/models/report_model.dart';
import 'package:clean_track/app/data/models/user_model.dart';
import 'package:clean_track/app/modules/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  Rxn<UserModel> _user = Rxn();
  UserModel? get user => _user.value;

  void signOut() {
    authC.signOut();
  }

  RxList<ReportModel> reports = <ReportModel>[].obs;

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
    _user.value = authC.user;
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
