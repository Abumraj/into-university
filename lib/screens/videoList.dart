import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/widgets/videohome.dart';

import '../Services/serviceImplementation.dart';
import '../models/chapterVideoModel.dart';
import '../repository/apiRepository.dart';
import '../repository/apiRepositoryimplementation.dart';

class VideoLists extends StatefulWidget {
  final int? courseId;
  final String? coursecode;
  VideoLists({this.coursecode, this.courseId});
  @override
  _VideoListsState createState() => _VideoListsState();
}

class _VideoListsState extends State<VideoLists> {
  // final controller = Get.put(ChapterVideoListController());
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());

  List<ChapterList> chapterList = [];

  @override
  void initState() {
    _loadChapterList();
    super.initState();
  }

  _loadChapterList() async {
    final result = await _apiRepository.getChapterList(widget.courseId!);
    if (result.isNotEmpty) {
      setState(() {
        chapterList = result;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "${widget.coursecode.toString()} : ${chapterList.length} Modules",
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
              ChapterList courseVideo = chapterList[index];

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

    // ClipRRect(
    //       borderRadius: BorderRadius.all(
    //         Radius.circular(10.0),
    //       ),
    //       child: InkWell(
    //         onTap: () {
    //           Navigator.of(context).push(
    //             MaterialPageRoute(
    //                 builder: (context) =>
    //                     VideoLists(courseId: id, coursecode: code)),
    //           );
    //         },
    //         child: Stack(
    //           children: <Widget>[
    //             Container(
    //               height: 150.0,
    //               width: 300.0,
    //               child: Image(
    //                 image: NetworkImage(imagePath),
    //                 fit: BoxFit.cover,
    //               ),
    //             ),
    //             Positioned(
    //               child: Container(
    //                 decoration: BoxDecoration(
    //                     gradient: LinearGradient(
    //                         begin: Alignment.bottomCenter,
    //                         end: Alignment.topCenter,
    //                         colors: [Colors.black, Colors.black12])),
    //               ),
    //             ),
    //             Positioned(
    //               left: 10.0,
    //               bottom: 10.0,
    //               right: 10.0,
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: <Widget>[
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: <Widget>[
    //                       Text(
    //                         code,
    //                         style: TextStyle(
    //                             fontSize: 18.0,
    //                             fontWeight: FontWeight.bold,
    //                             color: Colors.white),
    //                       ),

    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ));
  }

  // ListTile(
  //                 isThreeLine: true,
  //                 dense: true,
  //                 leading: Container(
  //                   width: 50,
  //                   height: 50,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10),
  //                       image: DecorationImage(
  //                           image: NetworkImage(
  //                               chapterList[index].chapterImage.toString()),
  //                           fit: BoxFit.fill)),
  //                 ),
  //                 title: Text(
  //                   chapterList[index].chapterName.toString(),
  //                   style: TextStyle(
  //                       color: Colors.purple,
  //                       fontSize: 15,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //                 subtitle: Padding(
  //                   padding: const EdgeInsets.only(
  //                       top: 8.0, right: 8.0, bottom: 8.0),
  //                   child: Text.rich(
  //                     TextSpan(
  //                         text: chapterList[index].chapterDescrip.toString()),
  //                     softWrap: true,
  //                     maxLines: 3,
  //                     style: TextStyle(
  //                       fontSize: 12,
  //                       color: Colors.purple[500],
  //                     ),
  //                   ),
  //                 ),
  //                 trailing: Badge(
  //                   toAnimate: true,
  //                   shape: BadgeShape.square,
  //                   badgeColor: Colors.white,
  //                   borderRadius: BorderRadius.circular(10),
  //                   badgeContent: Text(
  //                       "${chapterList[index].chapterVideoNum.toString()}",
  //                       style: TextStyle(
  //                           fontSize: 16,
  //                           color: Colors.purple,
  //                           fontWeight: FontWeight.bold)),
  //                   child: Icon(
  //                     Icons.video_collection_sharp,
  //                     size: 30,
  //                     color: Colors.purple,
  //                   ),
  //                 ),
  //               ),

}
