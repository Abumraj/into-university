import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:uniapp/screens/download.dart';
import 'package:uniapp/screens/videoList.dart';
import '../dbHelper/db.dart';
import '../entities.dart';
import '../screens/download.dart';
import '../widgets/courseHeader.dart';

class AspirantVideo extends StatefulWidget {
  AspirantVideo({Key? key}) : super(key: key);

  @override
  State<AspirantVideo> createState() => _AspirantVideoState();
}

class _AspirantVideoState extends State<AspirantVideo> {
  List<RegCourse> couseVideo = [];

  @override
  void initState() {
    loadCourseVideo();
    super.initState();
  }

  loadCourseVideo() async {
    final result = await ObjectBox.getAllRegCourse();

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
            child: HeaderWidget1(
                150, couseVideo.isEmpty ? false : true, "My Video Lessons"),
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
                        RegCourse courseVideo = couseVideo[index];

                        return SingleProd(
                          id: courseVideo.courseId!.toInt(),
                          code: courseVideo.coursecode.toString(),
                          description: courseVideo.courseDescrip.toString(),
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
          Get.to(OfflineDownloads());
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
              CachedNetworkImage(
                imageUrl: imagePath,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                useOldImageOnUrlChange: true,
                placeholder: (context, url) => Center(
                    child: const CircularProgressIndicator(
                  color: Colors.purple,
                )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
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
  }
}
