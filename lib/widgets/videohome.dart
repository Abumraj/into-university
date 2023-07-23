// ignore: import_of_legacy_library_into_null_safe

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pod_player/pod_player.dart';
import 'package:uniapp/repository/apiRepository.dart';
import 'package:uniapp/widgets/videoplayer.dart';
import '../models/videoListModel.dart';
import '../repository/apiRepositoryimplementation.dart';
import '../screens/download.dart';

class VideoInfo extends StatefulWidget {
  final int chapterId;
  final String chapterName;
  const VideoInfo(
      {Key? key, required this.chapterId, required this.chapterName})
      : super(key: key);

  @override
  _VideoInfoState createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());

  late String url;
  late String status;
  List<VideoList> videoList = [];
  bool isLoading = true;

  PodPlayerController? controller;
  final ReceivePort _port = ReceivePort();
  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    FlutterDownloader.registerCallback(downloadCallback);
    _loadChapterList();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Future<void> _doSimulateDownload(videoName, videoSize) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      url = videoSize;

      final dir = await getApplicationDocumentsDirectory();
      var _localPath = dir.path + videoName;
      final savedDir = Directory(_localPath);
      await savedDir.create(recursive: true).then((value) async {
        await FlutterDownloader.enqueue(
          url: "https://drive.google.com/uc?export=download&id=$url",
          fileName: videoName,
          savedDir: _localPath,
          showNotification: true,
          openFileFromNotification: false,
        );
      });
    }
  }

  _loadChapterList() async {
    setState(() {
      isLoading = true;
    });

    final result = await _apiRepository.getVideoList(widget.chapterId);
    if (result.isNotEmpty) {
      setState(() {
        videoList.addAll(result);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          centerTitle: true,
          title: Text(
            " ${videoList.length} Videos",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.download),
                onPressed: () {
                  Get.to(OfflineDownloads());
                }),
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(color: Colors.purple),
              )
            : Container(
                child: _listView(),
              ));
  }

  _listView() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
            ),
          )
        : videoList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Kindly Exercise some patience. Our tutors are currently working on the videos for this chapter.",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8),
                itemCount: videoList.length,
                itemBuilder: (_, int index) {
                  VideoList _videoList = videoList[index];
                  return ListTile(
                      onTap: () {
                        Get.to(
                          VideoPlayers(
                            title: _videoList.videoName.toString(),
                            description: _videoList.videoDescript.toString(),
                            url: _videoList.videoUrl.toString(),
                            status: _videoList.status.toString(),
                          ),
                        );
                      },
                      isThreeLine: true,
                      dense: true,
                      enabled: true,
                      leading: Container(
                        width: 100,
                        height: 70,
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://img.youtube.com/vi/${_videoList.videoUrl}/sddefault.jpg",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Center(
                              child: const CircularProgressIndicator(
                            color: Colors.purple,
                          )),
                          errorWidget: (context, url, error) => CircleAvatar(
                            child: Image.asset("images/uniappLogo.png"),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                      title: Text(
                        _videoList.videoName.toString(),
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text.rich(
                        TextSpan(text: _videoList.videoDescript.toString()),
                        softWrap: true,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.purple[500],
                        ),
                      ),
                      trailing: SizedBox(
                          width: 96,
                          child: InkWell(
                            child: Icon(
                              Icons.download,
                              color: Colors.purple,
                            ),
                            onTap: () {
                              _doSimulateDownload(_videoList.videoDescript,
                                  _videoList.thumbUrl);
                            },
                          )));
                });
  }
}
