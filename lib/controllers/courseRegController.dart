import 'package:get/get.dart';
import 'package:uniapp/models/departCoursesModel.dart';
import 'package:uniapp/repository/apiRepository.dart';
import 'package:uniapp/repository/apiRepositoryimplementation.dart';
// import 'package:uniapp/screens/coursesRegistration.dart';

class CourseRegController extends GetxController {
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());

  CourseRegController() {
    _apiRepository = Get.put(ApiRepositoryImplementation());
    //_loadDepartCourses();
  }
  // final departmentId = CourseReg().departmentId;
  // final semester = CourseReg(semester,: null,).semester;
  // final level = CourseReg().level;
  RxList<dynamic> shoppingCart = RxList();
  Rx<dynamic> message = "".obs;
  RxList<DepartCourse> departCourse = RxList();
  RxBool isLoading = false.obs;

  // _loadDepartCourses() async {
  //   showLoading();

  //   final result =
  //       await _apiRepository.getDepartCourses(departmentId!, semester!, level!);
  //   print(result);
  //   showLoading();
  //   update();
  //   if (result.isNotEmpty) {
  //     departCourse = result.obs;
  //   } else {
  //     GetSnackBar(
  //       message: 'You have not Registered any course',
  //     );
  //   }
  // }

  addToCartList(courseId, courseCode, coursePrice) async {
    showLoading();

    final result =
        await _apiRepository.addToCart(courseId, courseCode, coursePrice);
    showLoading();
    if (result != null) {
      shoppingCart = result.obs;
    } else {
      GetSnackBar(
        message: 'You have not Registered any course',
      );
    }
  }

  deleteFromCartList(courseCode) async {
    showLoading();
    await _apiRepository.deleteACourse(courseCode).then((value) {
      message = value.obs;
    });
    showLoading();
  }

  emptyCartList() async {
    showLoading();

    await _apiRepository.emptyCourseCart().then((value) {
      message = value.obs;
    });
    showLoading();
  }

  showLoading() {
    isLoading.toggle();
  }
}
