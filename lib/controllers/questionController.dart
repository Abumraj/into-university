import 'package:get/get.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/models/questionModel.dart';

class QuestionController extends GetxController {
  DbHelper _dbHelper = DbHelper();

  QuestionController() {
    _dbHelper = Get.find<DbHelper>();
  }

  RxList<Question> questions = RxList();
  RxBool isLoading = false.obs;

  loadChapter(int chapterId, int chapterNumber) async {
    showLoading();
    final result = await _dbHelper.getAllQuestions(chapterId, chapterNumber);
    showLoading();
    if (result != null) {
      questions = result.obs;
    } else {
      GetSnackBar(
        message: 'You have not Registered y course',
      );
    }
  }

  showLoading() {
    isLoading.toggle();
  }
}
