// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:uniapp/dbHelper/db.dart';
// import 'package:uniapp/models/chapterModel.dart';
// import 'package:uniapp/models/questionModel.dart';
// import 'package:uniapp/screens/demoChapter.dart';
// import 'package:uniapp/screens/postUtme.dart';

// class ChapterController extends GetxController {
//   DbHelper _dbHelper = Get.find<DbHelper>();

//   ChapterController() {
//     _dbHelper = Get.find<DbHelper>();
//     loadChapter();
//   }
//   final int? courseId = PostUtme().courseId;
//   final String? coursecode = PostUtme().coursecode;
//   RxList<Chapter> chapter = RxList();
//   RxList<Question> questions = RxList();
//   RxBool isLoading = false.obs;
//   loadChapter() async {
//     showLoading();
//     final result = await _dbHelper.getAllChapters(courseId!);
//     showLoading();
//     if (result.isNotEmpty) {
//       chapter = result.obs;
//     } else {
//       GetSnackBar(
//         message: 'No Chapter Allocated For this course',
//       );
//     }
//   }

//   loadQuestion(int chapterId, chapterName, quesNum, quesTime) async {
//     showLoading();
//     final result = await _dbHelper.getAllQuestions(chapterId);
//     showLoading();
//     if (result.isNotEmpty) {
//       questions = result.obs;
//     } else {
//       GetSnackBar(
//         message: 'You have not Registered any course',
//       );
//     }
//     Get.bottomSheet(
//       BottomSheet(
//         backgroundColor: Colors.white,
//         builder: (_) => QuizOptionsDialog(
//           questions: questions,
//           regCourse: coursecode,
//           chapterName: chapterName,
//           quesNum: quesNum,
//           quesTime: quesTime,
//         ),
//         onClosing: () {},
//       ),
//     );
//   }

//   showLoading() {
//     isLoading.toggle();
//   }
// }
