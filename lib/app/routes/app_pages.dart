import 'package:get/get.dart';

import '../modules/auth/login/bindings/auth_login_binding.dart';
import '../modules/auth/login/views/auth_login_view.dart';
import '../modules/auth/register/bindings/auth_register_binding.dart';
import '../modules/auth/register/views/auth_register_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/report/detail/bindings/report_detail_binding.dart';
import '../modules/report/detail/views/report_detail_view.dart';
import '../modules/report/form/bindings/report_form_binding.dart';
import '../modules/report/form/views/report_form_view.dart';
import '../modules/report/history/bindings/report_history_binding.dart';
import '../modules/report/history/views/report_history_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.AUTH_LOGIN,
      page: () => AuthLoginView(),
      binding: AuthLoginBinding(),
    ),
    GetPage(
      name: _Paths.AUTH_REGISTER,
      page: () => AuthRegisterView(),
      binding: AuthRegisterBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_HISTORY,
      page: () => const ReportHistoryView(),
      binding: ReportHistoryBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_DETAIL,
      page: () => ReportDetailView(),
      binding: ReportDetailBinding(),
    ),
    GetPage(
      name: _Paths.REPORT_FORM,
      page: () => ReportFormView(),
      binding: ReportFormBinding(),
    ),
  ];
}
