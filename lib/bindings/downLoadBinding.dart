import 'package:get/get.dart';
import 'package:uniapp/dbHelper/db.dart';

class DownLoadBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DbHelper());
  }
}
