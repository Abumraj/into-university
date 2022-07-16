import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniapp/models/videoCallModel.dart';
// import 'package:uniapp/screens/download.dart';
import 'package:uniapp/screens/videoList.dart';

import '../repository/apiRepository.dart';
import '../repository/apiRepositoryimplementation.dart';
import '../screens/download.dart';
import '../widgets/courseHeader.dart';

class AspirantVideo extends StatefulWidget {
  AspirantVideo({Key? key}) : super(key: key);

  @override
  State<AspirantVideo> createState() => _AspirantVideoState();
}

class _AspirantVideoState extends State<AspirantVideo> {
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());

  List<CourseVideo> couseVideo = [];

  //final CourseVidseoController controller = Get.put(CourseVidseoController());

  @override
  void initState() {
    loadCourseVideo();
    super.initState();
  }

  loadCourseVideo() async {
    //print(isLoading);

    final result = await _apiRepository.getVideo();
    print("result $result");

    print(result.isNotEmpty);
    if (result.isNotEmpty) {
      setState(() {
        couseVideo = result;
      });
    } else {
      GetSnackBar(
        message: 'You have not Registered any course',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 150,
            child: HeaderWidget1(150, true, "My Video Lessons"),
          ),
          Container(
              child: couseVideo.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : Container(
                      child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 0.8),
                      itemBuilder: (BuildContext context, int index) {
                        CourseVideo courseVideo = couseVideo[index];

                        return SingleProd(
                          id: courseVideo.courseId!.toInt(),
                          code: courseVideo.coursecode.toString(),
                          description: courseVideo.courseDescription.toString(),
                          imagePath: courseVideo.courseImage.toString(),
                        );
                      },
                      itemCount: couseVideo.length,
                    ))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        backgroundColor: Colors.purple,
        tooltip: 'Downloads',
        child: Icon(Icons.folder),
        onPressed: () {
          Get.to(Downloads());
        },
      ),
    );
  }
}

class SingleProd extends StatelessWidget {
  final int id;
  final String code;
  final String description;
  final String imagePath;

  SingleProd({
    required this.id,
    required this.code,
    required this.description,
    required this.imagePath,
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
            Get.to(VideoLists(courseId: id, coursecode: code));
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
              Image(
                width: 240,
                height: 120,
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8.0),
              Text(
                code,
                style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
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
}
