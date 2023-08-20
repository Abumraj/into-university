import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uniapp/Services/uapi.dart';
import 'package:uniapp/widgets/pdf.dart';
import '../dbHelper/db.dart';
import '../entities.dart';

class NewsReader extends StatefulWidget {
  @override
  _NewsReaderState createState() => _NewsReaderState();
}

class _NewsReaderState extends State<NewsReader> {
  List<RegCourse> selectedCourses = [];
  final ReceivePort _port = ReceivePort();

  bool isPresent = false;
  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    FlutterDownloader.registerCallback(downloadCallback);

    load();
    super.initState();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Future<void> _doSimulateDownload(coursecode, courseMaterialLink) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final dir =
          await getApplicationDocumentsDirectory(); //From path_provider package
      var _localPath = dir.path + coursecode;
      final savedDir = Directory(_localPath);
      await savedDir.create(recursive: true).then((value) async {
        await FlutterDownloader.enqueue(
          url:
              "https://drive.google.com/uc?export=download&id=$courseMaterialLink",
          fileName: coursecode,
          savedDir: _localPath,
          showNotification: true,
          openFileFromNotification: false,
        );
      });
    }
  }

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<Directory> localFile(String coursecode) async {
    final lowKey = await localPath;
    var filePath = lowKey + coursecode;
    Directory _directories = Directory(filePath);
    return _directories;
  }

  load() async {
    final result = await ObjectBox.getAllRegCourse();
    if (result.isNotEmpty) {
      setState(() {
        selectedCourses = result;
      });
    }
  }

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        dataRowColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected))
            return Colors.white.withOpacity(0.3);
          return null; // Use the default value.
        }),
        horizontalMargin: 12,
        dividerThickness: 1.5,
        columnSpacing: 28,
        showCheckboxColumn: true,
        showBottomBorder: true,
        dataTextStyle:
            TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        columns: [
          DataColumn(
            label: Text(
              "COURSECODE",
              style: TextStyle(color: Colors.purple, fontSize: 12),
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text(
              "DOWNLOAD",
              style: TextStyle(color: Colors.purple, fontSize: 11.5),
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text(
              "MANUAL",
              style: TextStyle(color: Colors.purple, fontSize: 11.5),
            ),
            numeric: false,
          ),
          DataColumn(
            label: Text(
              "CHATS",
              style: TextStyle(color: Colors.purple, fontSize: 12),
            ),
            numeric: true,
          ),
        ],
        rows: selectedCourses
            .map(
              (course) =>
                  DataRow(selected: selectedCourses.contains(course), cells: [
                DataCell(Text(course.coursecode!)),
                DataCell(
                  TextButton(
                    onPressed: (() async {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            title: new Text(
                              "Download Solution Manual for ${course.coursecode}?",
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 15.00,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            actions: <Widget>[
                              InkWell(
                                child: Icon(
                                  Icons.download,
                                  color: Colors.purple,
                                ),
                                onTap: () async {
                                  await _doSimulateDownload(course.coursecode,
                                      course.courseMaterialLink);
                                },
                              ),
                              SizedBox(
                                width: 150,
                              ),
                              TextButton(
                                child: new Text("Back"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }),
                    child: Icon(
                      Icons.download,
                      color: Colors.purple,
                    ),
                  ),
                ),
                DataCell(
                  TextButton(
                    onPressed: (() async {
                      course.courseMaterialLink.toString();
                      final paths = await localFile(course.coursecode!);

                      Get.to(PdfReader(
                        file: paths.path,
                        title: course.coursecode.toString(),
                      ));
                    }),
                    child: Text(
                      "Read PDF",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ),
                DataCell(
                  TextButton(
                    onPressed: () async {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            title: new Text(
                              "Join our telegram channel for ${course.coursecode} to seek support from your tutors and interact with your collegues",
                              style: TextStyle(
                                color: Colors.purple,
                                fontSize: 15.00,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: new Text("Join"),
                                onPressed: () {
                                  Uapi.joinTelegramGroupChat(
                                      course.courseChatLink!, true);
                                },
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              TextButton(
                                child: new Text("Back"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      "Group Chat",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ),
              ]),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedCourses.isEmpty
          ? Center(
              child: Container(
              height: 100,
              child: Column(
                children: [
                  Text("Group Chat Links for your courses will Appear here",
                      style: TextStyle(color: Colors.purple, fontSize: 16)),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.call,
                    size: 50,
                    color: Colors.purple,
                  )
                ],
              ),
            ))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: [
                  Expanded(
                    child: dataBody(),
                  ),
                ]),
    );
  }
}
