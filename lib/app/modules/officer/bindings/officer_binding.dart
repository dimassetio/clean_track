import 'package:get/get.dart';

import '../controllers/officer_controller.dart';

class OfficerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfficerController>(
      () => OfficerController(),
    );
  }
}
