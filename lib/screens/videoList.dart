import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/widgets/videohome.dart';
import '../dbHelper/db.dart';
import '../entities.dart';

class VideoLists extends StatefulWidget {
  final int? courseId;
  final String? coursecode;
  VideoLists({this.coursecode, this.courseId});
  @override
  _VideoListsState createState() => _VideoListsState();
}

class _VideoListsState extends State<VideoLists> {
  List<Chapter> chapterList = [];

  @override
  void initState() {
    _loadChapterList();
    super.initState();
  }

  _loadChapterList() async {
    final result = await ObjectBox.getAllChapters(widget.courseId!);
    if (result.isNotEmpty) {
      setState(() {
        chapterList = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "${chapterList.length} Modules",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(child: _listView()),
    );
  }

  _listView() {
    return chapterList.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          )
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.8),
            itemBuilder: (BuildContext context, int index) {
              Chapter courseVideo = chapterList[index];

              return SingleProd(
                id: courseVideo.chapterId!.toInt(),
                code: courseVideo.chapterName.toString(),
                description: courseVideo.chapterDescrip.toString(),
              );
            },
            itemCount: chapterList.length,
          );
  }
}

class SingleProd extends StatelessWidget {
  final int id;
  final String code;
  final String description;

  SingleProd({
    required this.id,
    required this.code,
    required this.description,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          padding: EdgeInsets.zero,
          height: 60,
          elevation: 1.0,
          onPressed: () {
            Get.to(VideoInfo(chapterId: id, chapterName: code));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.white60,
          textColor: Colors.white70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(
                Icons.video_collection,
                size: 30,
                color: Colors.purple,
              ),
              SizedBox(height: 8.0),
              Text(
                code,
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 7,
              ),
              SizedBox(height: 8.0),
              Text(
                description.toString(),
                style: TextStyle(
                    color: Colors.purple[500],
                    fontWeight: FontWeight.w400,
                    fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 7,
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 42.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                      size: 16.0,
                    ),
                    Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                      size: 16.0,
                    ),
                    Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                      size: 16.0,
                    ),
                    Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                      size: 16.0,
                    ),
                    Icon(
                      Icons.star,
                      color: Theme.of(context).primaryColor,
                      size: 16.0,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
