import 'package:dio/dio.dart';
import 'package:uniapp/models/program.dart';
import 'package:uniapp/models/school.dart';
import 'package:uniapp/models/studentType.dart';
import 'package:url_launcher/url_launcher.dart';

// UnAuthenticated Api calls.
class Uapi {
  static Dio dio = Dio();

  static Future<List<Program>?> getProgram() async {
    try {
      Response response = await dio.get(
        "https://uniapp.ng/api/program",
      );
      if (200 == response.statusCode) {
        List<Program> list = parsedProgram(response.data);
        return list;
      } else {
        return [];
      }
    } catch (e) {
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
        "https://uniapp.ng/api/school/$currentProgram",
      );
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
        "https://uniapp.ng/api/faculty/$schoolId",
      );
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
      Response response = await dio.get(
        "$url/studentType",
      );
      if (200 == response.statusCode) {
        List<StudentType> list = parsedFaculty1(response.data);
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

  static void joinTelegramGroupChat(String message, bool isExternal) async {
    if (await canLaunchUrl(Uri.parse(message))) {
      await launchUrl(Uri.parse(message),
          mode: isExternal
              ? LaunchMode.externalNonBrowserApplication
              : LaunchMode.platformDefault);
    } else {
      throw 'Could not launch $message';
    }
  }
}
