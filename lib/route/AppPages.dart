import 'package:get/get.dart';

import '../page/HomePage.dart';
import '../page/VideoDetailController.dart';
import 'Routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HomePage,
      page: () => HomePage(),
    ),
    GetPage(
      name: Routes.SearchResultPage,
      page: () => SearchResultPage(),
    )
  ];
}
