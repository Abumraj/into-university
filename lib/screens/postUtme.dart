// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/models/chapterModel.dart';
import 'package:uniapp/screens/demoChapter.dart';

import '../dbHelper/db.dart';
import '../models/questionModel.dart';

//import 'error.dart';

class PostUtme extends StatefulWidget {
  final String? coursecode;
  final int? courseId;
  PostUtme({Key? key, this.coursecode, this.courseId}) : super(key: key);

  @override
  State<PostUtme> createState() => _PostUtmeState();
}

class _PostUtmeState extends State<PostUtme> {
  DbHelper _dbHelper = DbHelper();
  List<Chapter> chapter = [];
  List<Question> questions = [];
  bool isLoading = false;

  @override
  void initState() {
    loadChapter();
    super.initState();
  }

  loadChapter() async {
    setState(() {
      isLoading = true;
    });

    final result = await _dbHelper.getAllChapters(widget.courseId!);
    if (result.isNotEmpty) {
      setState(() {
        chapter = result;
        isLoading = false;
      });
    } else {
      GetSnackBar(
        message: 'No Chapter Allocated For this course',
      );
    }
  }

  loadQuestion(int chapterId, chapterName, quesNum, quesTime) async {
    final result = await _dbHelper.getAllQuestions(chapterId, quesNum);
    if (result.isNotEmpty) {
      setState(() {
        questions = result;
      });
    } else {
      GetSnackBar(
        message: 'You have not Registered any course',
      );
    }
    Get.bottomSheet(
      BottomSheet(
        backgroundColor: Colors.white,
        builder: (_) => QuizOptionsDialog(
          questions: questions,
          regCourse: widget.coursecode,
          chapterName: chapterName,
          quesNum: quesNum,
          quesTime: quesTime,
        ),
        onClosing: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.purple,
          title: Text(widget.coursecode.toString().toUpperCase()),
          elevation: 0,
        ),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: ThemeData.light().primaryColor,
                  ),
                ),
              )
            : Container(
                child: ListView.builder(
                itemCount: chapter.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                      color: Colors.white,
                      elevation: 0.0,
                      shadowColor: Colors.purple,
                      child: ListTile(
                          leading: CircleAvatar(
                            child: Image.asset("images/uniappLogo.png"),
                            backgroundColor: Colors.white,
                          ),
                          title: Text(chapter[index].chapterName.toString(),
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 16.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              chapter[index].chapterDescrip.toString(),
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 12.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold)),
                          trailing: chapter[index].quesTime == 0
                              ? Text("practice Mode",
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: 12.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold))
                              : Text("${chapter[index].quesTime}mins",
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: 16.0,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold)),
                          onTap: () {
                            loadQuestion(
                                chapter[index].chapterId!.toInt(),
                                chapter[index].chapterName.toString(),
                                chapter[index].quesNum!.toInt(),
                                chapter[index].quesTime!.toInt());
                          }));
                },
              )));
  }
}







  // ignore: missing_return
  // loadQuestions(
  //     int chapterId, String chapterName, int quesNum, int quesTime) async {
  //   setState(() {
  //     processing = true;
  //   });
  //   List<Question> questions = await _dbHelper.getAllQuestions(chapterId);
  //   Navigator.pop(context);
  //   setState(() {
  //     processing = false;
  //   });
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (sheetContext) => BottomSheet(
  //       builder: (_) => QuizOptionsDialog(
  //         questions: questions,
  //         regCourse: widget.coursecode,
  //         chapterName: chapterName,
  //         quesNum: quesNum,
  //         quesTime: quesTime,
  //       ),
  //       onClosing: () {},
  //     ),
  //   );
  // }

//on SocketException catch (_) {
//    Navigator.pushReplacement(context, MaterialPageRoute(
//        builder: (_) => ErrorPage(message: "Can't reach the servers, \n Please check your internet connection.",)
//    ));
//  } catch(e){
//    print(e.message);
//    Navigator.pushReplacement(context, MaterialPageRoute(
//        builder: (_) => ErrorPage(message: "Unexpected error trying to connect to the API",)
//    ));
//  }

/*class SinPosCose extends StatelessWidget {
  final singporName;
  final singporCode;
  final singporDescrip;
  final singporTime;
  final singporNum;
  SinPosCose({this.singporName, this.singporCode, this.singporDescrip, this.singporTime, this.singporNum});
  DbHelper _dbHelper = DbHelper();
  int counter = 0;
  List<Question> quest;
  _loadAndSave(){
    DemoQuestionServices.getDemoQuestions().then((allQuestion){
      quest = allQuestion;
      insert(quest[0]);

    });
  }

  insert(Question question){
    _dbHelper.saveQuestions(question).then((val) {
      counter = counter + 1;
      if(counter >= quest.length  ){
        return;
      }
      Question a = quest[counter];
      insert(a);
    });
  }
  @override
  Widget build(BuildContext context){
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () async {

        try {
          List<Question> questions = await _dbHelper.getAllDemoQuestions(singporCode, singporName);
          Navigator.pop(context);
          if(questions.length < 1) {

            _loadAndSave();
            return;
          }
          Navigator.push(context, MaterialPageRoute(
              builder: (_) => QuizPage(questions: questions, chapter: singporName , regCourse: singporCode, quesNum: singporNum, quesTime: singporTime,)
          ));
        }on SocketException catch (_) {
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (_) => ErrorPage(message: "Can't reach the servers, \n Please check your internet connection.",)
          ));
        } catch(e){
          print(e.message);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (_) => ErrorPage(message: "Unexpected error trying to connect to the API",)
          ));
        }

      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.book),
          SizedBox(height: 5.0),
          AutoSizeText(
            singporCode,
            minFontSize: 10.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,),
          AutoSizeText(
            singporName +":"+ singporTime + "Mins",
            minFontSize: 10.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,),
          AutoSizeText(
            singporDescrip,
            minFontSize: 10.0,
            textAlign: TextAlign.center,
            maxLines: 3,
            wrapWords: false,),
        ],
      ),
    );
  }



}
Future  _startQuiz(Chapter chapter ) async {
 setState(() {
   processing = true;
 });
  try {
  List<Question> questions = await _dbHelper.getAllDemoQuestions(chapter.coursecode, chapter.chapterName);
  Navigator.pop(context);
  if(questions.isEmpty) {
  _loadAndSave();
  }
  Navigator.push(context, MaterialPageRoute(
  builder: (_) => QuizPage(questions: questions, chapter: chapter.chapterName , regCourse: chapter.coursecode, quesNum: chapter.quesNum, quesTime: chapter.quesTime,)
  ));
  }on SocketException catch (_) {
  Navigator.pushReplacement(context, MaterialPageRoute(
  builder: (_) => ErrorPage(message: "Can't reach the servers, \n Please check your internet connection.",)
  ));
  } catch(e){
  print(e.message);
  Navigator.pushReplacement(context, MaterialPageRoute(
  builder: (_) => ErrorPage(message: "Unexpected error trying to connect to the API",)
  ));
  }
setState(() {
  processing = false;
});
  }


*/
