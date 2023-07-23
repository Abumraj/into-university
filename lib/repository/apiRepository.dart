import 'package:uniapp/models/chapterModel.dart';
import 'package:uniapp/models/chapterVideoModel.dart';
import 'package:uniapp/models/departCoursesModel.dart';
import 'package:uniapp/models/departmentModel.dart';
import 'package:uniapp/models/facultyModel.dart';
import 'package:uniapp/models/level.dart';
import 'package:uniapp/models/questionModel.dart';
import 'package:uniapp/models/regCourseModel.dart';
import 'package:uniapp/models/subModel.dart';
import 'package:uniapp/models/videoCallModel.dart';
import 'package:uniapp/models/videoListModel.dart';

abstract class ApiRepository {
  Future<List<Faculty>> getFaculty();
  Future<List<CourseLevel>> getCourseLevel();
  Future<List<Department>> getDepartment(int facultyId);
  Future<List<DepartCourse>> getDepartCourses(
      int departmentId, int semester, int level);
  Future<List<Chapter>> getChapter();
  Future<List<Question>> getQuestions();
  Future<List<RegCourse>> getRegCourse();
  Future<List<VideoList>> getVideoList(int chapterId);
  Future<List<ChapterList>> getChapterList();
  Future<List<CourseVideo>> getVideo();
  Future<List<CourseVideo>> getEndVideo();
  Future<List<DepartCourse>> getCart();
  Future<dynamic> addToCart(int courseId, String courseCode, int coursePrice);
  Future<dynamic> deleteACourse(String courseCode);
  Future<dynamic> emptyCourseCart();
  Future<dynamic> logOUT();
  Future<List<Subscription>> getSubscription();
  Future<dynamic> getAccessCode(String reference);
  Future<dynamic> getStaAccessCode(int amount, String email);
  Future<dynamic> verifyTransaction(String reference);
  Future<dynamic> saveToken(String reference);
  Future<dynamic> writeAreview(String title, String description);
}
