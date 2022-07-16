import 'package:get/get.dart';
import 'package:uniapp/models/departmentModel.dart';
import 'package:uniapp/models/facultyModel.dart';
import 'package:uniapp/repository/apiRepository.dart';
import 'package:uniapp/repository/apiRepositoryimplementation.dart';

class FacultyController extends GetxController {
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());

  FacultyController() {
    _apiRepository = Get.put(ApiRepositoryImplementation());
    // _facultyList();
  }

  RxList<Faculty> faculty = RxList();
  RxList<Department> department = RxList();
  RxBool isLoading = false.obs;

  _facultyList() async {
    showLoading();

    final result = await _apiRepository.getFaculty();
    showLoading();
    print(result);
    update();
    if (result.isNotEmpty) {
      faculty = result.obs;
    } else {
      GetSnackBar(
        message: 'You have not Registered any course',
      );
    }
  }

  departmentList(facultyId) async {
    showLoading();

    final result = await _apiRepository.getDepartment(facultyId);
    showLoading();
    if (result.isNotEmpty) {
      department = result.obs;
    } else {
      GetSnackBar(
        message: 'You have not Registered any course',
      );
    }
  }

  showLoading() {
    isLoading.toggle();
  }
}
