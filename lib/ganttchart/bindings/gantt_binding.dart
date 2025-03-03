import 'package:get/get.dart';

import '../controller/gantt_controller.dart';

class GanttBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GanttController>(
      () => GanttController(),
    );
  }
}