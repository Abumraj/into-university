import 'package:get/get.dart';
import 'package:uniapp/Services/abstractService.dart';
import 'package:uniapp/Services/serviceImplementation.dart';
import 'package:uniapp/models/chapterModel.dart';
import 'package:uniapp/models/chapterVideoModel.dart';
import 'package:uniapp/models/level.dart';
import 'package:uniapp/models/questionModel.dart';
import 'package:uniapp/models/regCourseModel.dart';
import 'package:uniapp/models/videoListModel.dart';
import 'package:uniapp/models/videoCallModel.dart';
import 'package:uniapp/models/subModel.dart';
import 'package:uniapp/models/facultyModel.dart';
import 'package:uniapp/models/departmentModel.dart';
import 'package:uniapp/models/departCoursesModel.dart';
import 'package:uniapp/repository/apiRepository.dart';

class ApiRepositoryImplementation implements ApiRepository {
  HttpService _httpService = Get.put(ServiceImplementation());

  ApiRepositoryImplementation() {
    _httpService = Get.put(ServiceImplementation());
    _httpService.init();
  }

  @override
  Future addToCart(int courseId, String courseCode, int coursePrice) async {
    try {
      final response = await _httpService.postRequest(
        "/addToCart",
        {
          "courseId": courseId,
          "courseCode": courseCode,
          "coursePrice": coursePrice
        },
      );
      return response.data;
    } catch (e) {
      return e;
    }
  }

  @override
  Future deleteACourse(String courseCode) async {
    try {
      final response = await _httpService.getRequest("/cartdelete/$courseCode");

      return response;
    } catch (e) {
      return e;
    }
  }

  @override
  Future emptyCourseCart() async {
    try {
      final response = await _httpService.getRequest("/emptyCart");

      return response;
    } catch (e) {
      return e;
    }
  }

  @override
  Future getAccessCode(String reference) async {
    try {
      final response = await _httpService.postRequest(
        "/transactionInit",
        {"reference": reference},
      );

      return response;
    } catch (e) {
      return e; // return an empty list on exception/error
    }
  }

  @override
  Future<List<Chapter>> getChapter() async {
    try {
      final response = await _httpService.getRequest("/chapters");
      List<Chapter> list = parseChapter(response.data);
      return list;
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<Chapter> parseChapter(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Chapter>((json) => Chapter.fromJson(json)).toList();
  }

  @override
  Future<List<DepartCourse>> getCart() async {
    try {
      final response = await _httpService.getRequest("/getCart");
      List<DepartCourse> list = parsedDepartmentCourse(response.data);
      return list;
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  @override
  Future<List<DepartCourse>> getDepartCourses(
      int courseId, int semester, int level) async {
    try {
      final response = await _httpService
          .getRequest("/departmentalCourse/$courseId,$semester,$level");
      List<DepartCourse> list = parsedDepartmentCourse(response.data);
      return list;
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<DepartCourse> parsedDepartmentCourse(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    final y = parsed
        .map<DepartCourse>((json) => DepartCourse.fromJson(json))
        .toList();
    return y;
  }

  @override
  Future<List<Department>> getDepartment(facultyId) async {
    try {
      final response = await _httpService.getRequest("/department/$facultyId");
      List<Department> list = parsedDepartment(response.data);
      return list;
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<Department> parsedDepartment(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Department>((json) => Department.fromJson(json)).toList();
  }

  @override
  Future<List<Faculty>> getFaculty() async {
    try {
      final response = await _httpService.getRequest("/faculty");

      List<Faculty> list = parsedFaculty(response.data);
      return list;
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<Faculty> parsedFaculty(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Faculty>((json) => Faculty.fromJson(json)).toList();
  }

  @override
  Future<List<Question>> getQuestions() async {
    try {
      final response = await _httpService.getRequest("/courseQuestion");

      List<Question> list = parsedQuestion(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  static List<Question> parsedQuestion(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Question>((json) => Question.fromJson(json)).toList();
  }

  @override
  Future<List<CourseLevel>> getCourseLevel() async {
    try {
      final response = await _httpService.getRequest("/level");

      List<CourseLevel> list = parsedCourseLevel(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  static List<CourseLevel> parsedCourseLevel(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed
        .map<CourseLevel>((json) => CourseLevel.fromJson(json))
        .toList();
  }

  @override
  Future<List<RegCourse>> getRegCourse() async {
    try {
      final response = await _httpService.getRequest("/registeredCourse");

      List<RegCourse> list = parseRegCourse(response.data);
      return list;
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<RegCourse> parseRegCourse(dynamic response) {
    final parsed = response.cast<Map<String, dynamic>>();
    return parsed.map<RegCourse>((json) => RegCourse.fromJson(json)).toList();
  }

  @override
  Future getStaAccessCode(int amount, String email) async {
    try {
      final response = await _httpService
          .postRequest("/transactionInit", {"amount": amount, "email": email});
      return response.data;
    } catch (e) {
      return e; // return an empty list on exception/error
    }
  }

  @override
  Future<List<Subscription>> getSubscription() async {
    try {
      final response = await _httpService.getRequest("/subscriptionPlan");

      List<Subscription> list = parseSubResponse(response.data);
      return list;
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<Subscription> parseSubResponse(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed
        .map<Subscription>((json) => Subscription.fromJson(json))
        .toList();
  }

  @override
  Future<List<CourseVideo>> getVideo() async {
    try {
      late List<CourseVideo> list;
      late final response;

      response = await _httpService.getRequest("/registeredCourseVideo");
      if (response.statusCode == 200) {
        list = parseResponse(response.data);
      }
      return list;
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  @override
  Future<List<CourseVideo>> getEndVideo() async {
    try {
      late List<CourseVideo> list;
      late final response;

      response = await _httpService.getRequest("/liveEvents");
      if (response.statusCode == 200) {
        list = parseResponse(response.data);
      }
      return list;
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<CourseVideo> parseResponse(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed
        .map<CourseVideo>((json) => CourseVideo.fromJson(json))
        .toList();
  }

  @override
  Future<List<VideoList>> getVideoList(chapterId) async {
    try {
      final response = await _httpService.getRequest("/courseVideo/$chapterId");
      List<VideoList> list = parsedVideoList(response.data);
      return list;
    } catch (e) {
      return [];
    }
  }

  static List<VideoList> parsedVideoList(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<VideoList>((json) => VideoList.fromJson(json)).toList();
  }

  @override
  Future<List<ChapterList>> getChapterList() async {
    try {
      late List<ChapterList> list;
      late final response;

      response = await _httpService.getRequest("/courseVideoChapter");
      if (response.statusCode == 200) {
        list = parsedChapterList(response.data);
      }

      return list;
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<ChapterList> parsedChapterList(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed
        .map<ChapterList>((json) => ChapterList.fromJson(json))
        .toList();
  }

  @override
  Future logOUT() async {
    try {
      final response = await _httpService.getRequest("/logout");

      return response.data;
    } catch (e) {
      return e;
    }
  }

  @override
  Future verifyTransaction(String reference) async {
    try {
      final response = await _httpService.postRequest(
        "/transactionVerify",
        {
          "reference": reference,
        },
      );
      return response.data;
    } catch (e) {
      return e; // return an empty list on exception/error
    }
  }

  @override
  Future saveToken(String token) async {
    try {
      final response = await _httpService.postRequest(
        "/saveToken",
        {
          "token": token,
        },
      );
      return response;
    } catch (e) {
      return e; // return an empty list on exception/error
    }
  }

  @override
  Future writeAreview(String title, String description) async {
    try {
      final response = await _httpService.postRequest(
        "/review",
        {
          "title": title,
          "description": description,
        },
      );

      return response;
    } catch (e) {
      return e;
    }
  }
}
