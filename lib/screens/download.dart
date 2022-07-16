import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/models/videoListModel.dart';
import 'package:uniapp/widgets/videoplayer.dart';

import '../widgets/courseHeader.dart';

class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  DbHelper _dbHelper = DbHelper();
  List<VideoList> _videoList = [];
  bool isLoading = false;
  @override
  void initState() {
    getOfflineVideos();
    super.initState();
  }

  getOfflineVideos() async {
    await _dbHelper.getAllSaveVideo().then((value) {
      setState(() {
        _videoList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          elevation: 0.0,
          title: Text(
            "Downloads",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget1(150, true, "My Downloads"),
            ),
            Container(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : _videoList.isEmpty
                      ? Center(
                          child: Text(
                            'You are yet to download any Video',
                            style: TextStyle(color: Colors.purple),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          padding: EdgeInsets.all(10.0),
                          height: 140.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 1),
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: ListView.builder(
                              itemCount: _videoList.length,
                              itemBuilder: (BuildContext context, int index) {
                                VideoList videoList = _videoList[index];
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  padding: EdgeInsets.all(10.0),
                                  height: 140.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 1),
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    leading: Image.asset(
                                      "images/${videoList.videoName}.jpg",
                                      width: 150.0,
                                    ),
                                    title: Text(
                                      videoList.videoName.toString(),
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    subtitle: Text(
                                        videoList.videoDescript.toString()),
                                    trailing: GestureDetector(
                                        child: Icon(Icons.delete_forever),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: new Text(
                                                    "Delete from phone"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: new Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Colors.purple),
                                                    ),
                                                    onPressed: deleteVideo(
                                                        videoList.videoUrl
                                                            .toString()),
                                                  ),
                                                  TextButton(
                                                    child: new Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Colors.purple),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VideoPlayers(
                                          title: videoList.videoName.toString(),
                                          url: videoList.videoUrl.toString(),
                                          description: videoList.videoDescript
                                              .toString(),
                                          status: videoList.status.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })),
            ),
          ],
        ));
  }

  deleteVideo(String urlPath) async {
    try {
      //Directory dir = await getApplicationDocumentsDirectory();
      final targetFile = Directory(urlPath);
      if (targetFile.existsSync()) {
        targetFile.deleteSync(recursive: true);
      }
    } catch (e) {}

    GetSnackBar(message: 'Video deleted successfully');
  }
}
