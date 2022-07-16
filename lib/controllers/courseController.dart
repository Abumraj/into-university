import 'package:get/get.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/models/chapterModel.dart';
import 'package:uniapp/models/questionModel.dart';
import 'package:uniapp/models/regCourseModel.dart';
import 'package:uniapp/repository/apiRepository.dart';
import 'package:uniapp/repository/apiRepositoryimplementation.dart';

class CourseController extends GetxController {
  ApiRepository _apiRepository = Get.find<ApiRepositoryImplementation>();
  DbHelper _dbHelper = DbHelper();
  CourseController() {
    _apiRepository = Get.find<ApiRepositoryImplementation>();
    _dbHelper = Get.find<DbHelper>();
    _loadAndSave();
  }
  int counter = 0;
  RxList<RegCourse> regCourses = RxList();
  RxList<Chapter> chapters = RxList();
  RxList<Question> questions = RxList();
  RxBool isLoading = false.obs;
  RxString currentAction = 'Fetching Question'.obs;

  _loadAndSave() async {
    showLoading();

    await _apiRepository.getRegCourse().then((allRegCourse) {
      regCourses = allRegCourse.obs;
      print(regCourses);
      _dbHelper.truncateTable1().then((value) {
        insert(regCourses[0]);
      });

      _apiRepository.getChapter().then((value) {
        chapters = value.obs;
        _dbHelper.truncateTable2();
        _dbHelper.saveChapter(chapters);
      });
      _apiRepository.getQuestions().then((value) {
        questions = value.obs;
        _dbHelper.truncateTable3();
        _dbHelper.saveQuestion(questions);
      });
    });
    showLoading();
  }

  insert(RegCourse regCourse) {
    _dbHelper.saveRegCourse(regCourse).then((val) {
      counter = counter + 1;
      if (counter >= regCourses.length) {
        return;
      }
      RegCourse a = regCourses[counter];
      insert(a);
      print(a);
    });
  }

  showLoading() {
    isLoading.toggle();
  }
}
