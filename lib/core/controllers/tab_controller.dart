import 'package:get/get.dart';

/// Controller for managing tab navigation state across the app
/// Similar to Mobile-Insights-by-Artigan implementation
class TabCountController extends GetxController {
  var tabIndex = 0.obs;

  /// Change the current tab index
  void changeTabIndex(int index) {
    tabIndex.value = index;
    update();
  }
}
