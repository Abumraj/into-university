import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uniapp/Services/serviceImplementation.dart';
import 'package:uniapp/dbHelper/constant.dart';
import 'package:uniapp/models/chapterModel.dart';
import 'package:uniapp/models/departCoursesModel.dart';
import 'package:uniapp/models/departmentModel.dart';
import 'package:uniapp/models/facultyModel.dart';
import 'package:uniapp/models/questionModel.dart';
import 'package:uniapp/models/regCourseModel.dart';
import 'package:uniapp/models/subModel.dart';
import 'package:uniapp/models/videoCallModel.dart';
import 'package:uniapp/models/videoListModel.dart';

class Api {
  // initializeInterceptors() {
  //   dio.interceptors.add(InterceptorsWrapper(
  //       onError: (DioError err, ErrorInterceptorHandler handler) {
  //     print(
  //         'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
  //     //return super.onError(err, handler);
  //   }, onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
  //     print('REQUEST[${options.method}] => PATH: ${options.path}');
  //     //return super.onRequest(options, handler);
  //   }, onResponse: (Response response, ResponseInterceptorHandler handler) {
  //     print(
  //         'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
  //     //return (response, handler);
  //   }));
  // }
  static Dio dio = Dio();
  static Future<List<Faculty>> getFaculty1() async {
    try {
      print("$baseUrl = roy");
      Response response = await dio.get("$baseUrl/faculty",
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      if (200 == response.statusCode) {
        List<Faculty> list = parsedFaculty1(response.data);
        return list;
      } else {
        return [];
      }
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<Faculty> parsedFaculty1(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Faculty>((json) => Faculty.fromJson(json)).toList();
  }

  static Future<List<Department>> getDepartment(int facultyId) async {
    try {
      final response = await dio.get(
        "/department/$facultyId",
      );
      print('getDepartment Response: response');
      if (200 == response.statusCode) {
        List<Department> list = parsedDepartment(response.data);
        return list;
      } else {
        return [];
      }
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<Department> parsedDepartment(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Department>((json) => Department.fromJson(json)).toList();
  }

  static Future<List<DepartCourse>> getDepartCourses(
      int courseId, int semester, String userType, String token) async {
    try {
      Response response = await dio.get(
        "/departmentalCourse/$courseId,$semester",
      );
      print('getDepartCourses Response: response');
      if (200 == response.statusCode) {
        List<DepartCourse> list = parsedDepartmentCourse(response.data);
        return list;
      } else {
        return [];
      }
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<DepartCourse> parsedDepartmentCourse(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed
        .map<DepartCourse>((json) => DepartCourse.fromJson(json))
        .toList();
  }

  static Future<List<Chapter>> getChapter(String userType, String token) async {
    try {
      Response response = await dio.get(
        "/chapters",
      );

      print('getChapter Response: $response');
      if (200 == response.statusCode) {
        List<Chapter> list = parseChapter(response.data);
        return list;
      } else {
        return [];
      }
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<Chapter> parseChapter(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Chapter>((json) => Chapter.fromJson(json)).toList();
  }

  // static Future<List<Question>> getQuestions(
  //     String userType, String token) async {
  //   try {
  //     Response response = await dio.get("/$userType/courseQuestion",
  //         options: Options(headers: {
  //           'Accept': 'application/json',
  //           'Authorization': 'Bearer $token'
  //         }));
  //     print('getQuestions Response: $response');
  //     if (200 == response.statusCode) {
  //       List<Map<dynamic, dynamic>> questions =
  //           List<Map<dynamic, dynamic>>.from(json.decode(response.data));
  //       return Question.fromData(questions);
  //     } else {
  //       return List<Question>();
  //     }
  //   } catch (e) {
  //     return List<Question>();
  //   }
  // }

//   static Future<List<RegCourse>> getRegCourse(
//       String userType, String token) async {
//     try {
//       Response response = await dio.get("/$userType/registeredCourse",
//           options: Options(responseType: ResponseType.json, headers: {
//             "Content-Type": "application/json",
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token'
//           }));
//       print('getRegCourse Response: $response');
//       if (200 == response.statusCode) {
//         List<RegCourse> list = parseRegCourse(response.data);

// //     var   result = response.data;
// //     result.forEach((list) => lists.add(RegCourse.fromJson(list)));
//         return list;
//       } else {
//         return List<RegCourse>();
//       }
//     } catch (e) {
//       return e; // return an empty list on exception/error
//     }
//   }

  static List<RegCourse> parseRegCourse(dynamic response) {
    final parsed = response.cast<Map<String, dynamic>>();
    return parsed.map<RegCourse>((json) => RegCourse.fromJson(json)).toList();
  }

  // static Future<List<VideoList>> getVideoList(
  //     int courseId, String userType, String token) async {
  //   try {
  //     Response response = await dio.get("/$userType/courseVideo/$courseId",
  //         options: Options(responseType: ResponseType.json, headers: {
  //           "Content-Type": "application/json",
  //           'Accept': 'application/json',
  //           'Authorization': 'Bearer $token'
  //         }));
  //     print('getVideoList Response: response');
  //     if (200 == response.statusCode) {
  //       List<VideoList> list = parsedVideoList(response.data);
  //       return list;
  //     } else {
  //       return List<VideoList>();
  //     }
  //   } catch (e) {
  //     return List<VideoList>();
  //   }
  // }

  static List<VideoList> parsedVideoList(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<VideoList>((json) => VideoList.fromJson(json)).toList();
  }

  // static Future<List<CourseVideo>> getVideo(
  //     String userType, String token) async {
  //   try {
  //     Response response = await dio.get("/$userType/registeredCourseVideo",
  //         options: Options(responseType: ResponseType.json, headers: {
  //           "Content-Type": "application/json",
  //           'Accept': 'application/json',
  //           'Authorization': 'Bearer $token'
  //         }));
  //     print('getCourseVideo Response: response');
  //     if (200 == response.statusCode) {
  //       List<CourseVideo> list = parseResponse(response.data);
  //       return list;
  //     } else {
  //       return List<CourseVideo>();
  //     }
  //   } catch (e) {
  //     return List<CourseVideo>();
  //   }
  // }

  static List<CourseVideo> parseResponse(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed
        .map<CourseVideo>((json) => CourseVideo.fromJson(json))
        .toList();
  }

  static Future<dynamic> addToCart(int courseId, String courseCode,
      int coursePrice, String userType, String token) async {
    try {
      Response response = await dio.post("/$userType/cart",
          data: {
            "courseId": courseId,
            "coursecode": courseCode,
            "coursePrice": coursePrice
          },
          options: Options(headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      print('addCart Response: response');
      if (200 == response.statusCode) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      return "$courseCode not added to cart";
    }
  }

  static Future<dynamic> deleteACourse(String courseCode) async {
    try {
      Response response = await dio.get("/cartdelete/$courseCode",
          options: Options(headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      print('addCart Response: response');
      if (200 == response.statusCode) {
        return response;
      } else {
        return "error";
      }
    } catch (e) {
      return "$courseCode not deleted from cart";
    }
  }

  static Future<dynamic> emptyCourseCart(String userType, String token) async {
    try {
      Response response = await dio.get(
        "emptyCart",
      );
      print('addCart Response: response');
      if (200 == response.statusCode) {
        return response.data;
      } else {
        return "error";
      }
    } catch (e) {
      return "cart not emptied";
    }
  }

  static Future<dynamic> logOUT(String userType, String token) async {
    try {
      Response response = await dio.get("/$userType/logOut",
          options: Options(headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }));
      print('addCart Response: response');
      if (200 == response.statusCode) {
        return response.data;
      } else {
        return "error";
      }
    } catch (e) {
      return e;
    }
  }

  static Future<List<Subscription>> getSubscription(
      String userType, String token) async {
    try {
      Response response = await dio.get(
        "/$userType/subscriptionPlan",
      );
      print('getSubscription Response: response');
      if (200 == response.statusCode) {
        List<Subscription> list = parseSubResponse(response.data);
        return list;
      } else {
        return [];
      }
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

  static Future<dynamic> getAccessCode(String planCode, int amount,
      String email, String userType, String token) async {
    try {
      Response response = await dio.post(
        "/transactionInit",
        data: {"email": email, "amount": amount, "planCode": planCode},
      );
      return response;
    } catch (e) {
      return e; // return an empty list on exception/error
    }
  }

  static Future<dynamic> getStaAccessCode(
      int amount, String email, String userType, String token) async {
    try {
      Response response = await dio
          .post("/transactionInit", data: {"amount": amount, "email": email});
      return response;
    } catch (e) {
      return e; // return an empty list on exception/error
    }
  }

  static Future<dynamic> verifyTransaction(
      String reference, String userType, String token) async {
    try {
      Response response = await dio.post(
        "/transactionVerify",
        data: {
          "reference": reference,
        },
      );
      return response;
    } catch (e) {
      return e; // return an empty list on exception/error
    }
  }

  static Future<dynamic> writeAreview(String title, String description) async {
    try {
      Response response = await dio.post(
        "/review",
        data: {
          "title": title,
          "description": description,
        },
      );
      print('addCart Response: response');
      if (200 == response.statusCode) {
        return response;
      }
    } catch (e) {
      return e;
    }
  }
}
