import 'package:dio/dio.dart';
import 'package:uniapp/models/facultyModel.dart';
import 'package:uniapp/models/program.dart';
import 'package:uniapp/models/school.dart';
import 'package:uniapp/models/studentType.dart';

// UnAuthenticated Api calls.
class Uapi {
  static Dio dio = Dio();
  static Future<List<Program>?> getProgram() async {
    try {
      Response response = await dio.get(
        "http://192.168.43.144:8000/api/program",
      );
      print('getProgram Response: $response');
      if (200 == response.statusCode) {
        print(response.data);
        List<Program> list = parsedProgram(response.data);
        return list;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return []; // return an empty list on exception/error
    }
  }

  static List<Program> parsedProgram(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<Program>((json) => Program.fromJson(json)).toList();
  }

  static Future<List<School>> getSchool(String currentProgram) async {
    try {
      Response response = await dio.get(
        "http://192.168.43.144:8000/api/school/$currentProgram",
      );
      print('getSchool Response: response');
      if (200 == response.statusCode) {
        List<School> list = parsedSchool(response.data);
        return list;
      } else {
        return [];
      }
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<School> parsedSchool(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed.map<School>((json) => School.fromJson(json)).toList();
  }

  static Future<Object> getChannel(String schoolId) async {
    try {
      Response response = await dio.get(
        "http://192.168.43.144:8000/api/faculty/$schoolId",
      );
      print('getSchool Response: response');
      if (200 == response.statusCode) {
        List<School> list = parsedSchool(response.data);
        return list;
      } else {
        return List;
      }
    } catch (e) {
      return e; // return an empty list on exception/error
    }
  }

  static Future<List<StudentType>> getStudentType(String url) async {
    try {
      // print("$baseUrl = roy");
      Response response = await dio.get(
        "$url/studentType",
      );
      print(response);
      if (200 == response.statusCode) {
        List<StudentType> list = parsedFaculty1(response.data);
        print(list);
        return list;
      } else {
        return [];
      }
    } catch (e) {
      return []; // return an empty list on exception/error
    }
  }

  static List<StudentType> parsedFaculty1(dynamic responseBody) {
    final parsed = responseBody.cast<Map<String, dynamic>>();
    return parsed
        .map<StudentType>((json) => StudentType.fromJson(json))
        .toList();
  }
  // static List<StudentType> parsedFaculty1(dynamic responseBody) {
  //   final parsed = responseBody.cast<Map<String, dynamic>>();
  //   return parsed.map<Faculty>((json) => StudentType.fromJson(json)).toList();
  // }
}
