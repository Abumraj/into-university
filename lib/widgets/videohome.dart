// ignore: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pod_player/pod_player.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/repository/apiRepository.dart';
import 'package:uniapp/widgets/downloadButton.dart';
import 'package:uniapp/widgets/theme.dart';
import 'package:uniapp/widgets/videoplayer.dart';
import '../models/videoListModel.dart';
import '../repository/apiRepositoryimplementation.dart';

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
  // final _videoListController = Get.put(VideoListController());
  ApiRepository _apiRepository = Get.put(ApiRepositoryImplementation());
  DbHelper _dbHelper = Get.put(DbHelper());
  late final List<DownloadController> _downloadControllers;

  late String url;
  late String status;
  List<VideoList> _videoList = [];
  bool isLoading = true;
  bool playArea = false;
  PodPlayerController? controller;

  @override
  void initState() {
    super.initState();
    _loadChapterList();
  }

  _loadChapterList() async {
    setState(() {
      isLoading = true;
    });
    // showLoading();

    final offResult = await _dbHelper.getSavedVideos(widget.chapterId);
    final result = await _apiRepository.getVideoList(widget.chapterId);
    if (offResult.isEmpty && result.isNotEmpty) {
      setState(() {
        _videoList.addAll(result);
      });
    } else if (offResult.isNotEmpty && result.isEmpty) {
      setState(() {
        _videoList.addAll(offResult);
      });
    } else {
      setState(() {
        _videoList.addAll(result);
      });
      for (int i = 0; i < offResult.length; i++) {
        bool contain = _videoList.contains(offResult[i].videoName);
        _videoList.removeWhere((videoList) => contain == true);
      }
      setState(() {
        _videoList.addAll(offResult);
      });
    }
    _downloadControllers = List<DownloadController>.generate(
      _videoList.length,
      (index) => SimulatedDownLoadController(
          description: _videoList[index].videoDescript.toString(),
          thumbUrl: _videoList[index].thumbUrl.toString(),
          videoName: _videoList[index].videoName.toString(),
          videoUrl: _videoList[index].videoUrl.toString(),
          downloadStatus: _videoList[index].status == 'downloaded'
              ? DownloadStatus.downloaded
              : DownloadStatus.notDownloaded),
    );
    setState(() {
      isLoading = false;
    });

    print(_videoList);
    //showLoading();

    // if (result!.isNotEmpty) {
    //   for (int i = 0; i < result.length; i++) {
    //     for (int j = 0; j < offResult.length; j++) {
    //       if (result[i].videoName == offResult[j].videoName) {
    //         result[i].videoUrl = offResult[j].videoUrl;
    //         result[i].thumbUrl = offResult[j].thumbUrl;
    //         result[i].status = offResult[j].status;
    //       }
    //     }

    //     videoList = result.obs;
    //   }
    // } else if (result.isNotEmpty && offResult.isEmpty) {
    //   videoList = result.obs;
    // } else if (result.isEmpty && offResult.isNotEmpty) {
    //   videoList = offResult.obs;
    // } else if (result.isEmpty && offResult.isEmpty) {
    //   hasData();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text(
            widget.chapterName + ":" + "  ${_videoList.length} Videos",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(color: Colors.purple),
              )
            : Container(
                child: _listView(),
              ));
  }

  Widget _controlView(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(seconds: 3),
      opacity: 1,
      child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: Center(
            child: Row(children: [
              TextButton(
                  onPressed: () {},
                  child: Icon(Icons.skip_previous_sharp,
                      size: 36, color: Colors.purple)),
              SizedBox(
                width: 50,
              ),
              TextButton(
                  onPressed: () {},
                  child: Icon(Icons.skip_next_sharp,
                      size: 36, color: Colors.purple)),
            ]),
          )),
    );
  }

  Widget _playView(BuildContext context) {
    final _controller = controller;
    if (_controller != null && _controller.isInitialised) {
      return PodVideoPlayer(
        controller: controller!,
        podProgressBarConfig: PodProgressBarConfig(
          playingBarColor: Colors.purple,
          circleHandlerColor: Colors.purple,
          circleHandlerRadius: 12,
        ),
        onVideoError: () {
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: Center(
              child: Text(
                  controller!.videoPlayerValue!.errorDescription.toString()),
            ),
          );
        },
        overlayBuilder: (overLayOptions) {
          return _controlView(context);
        },
      );
    } else {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(
          child: Text(
            "Loading.......",
            style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }
  }

  // _changeVideoPlaying(index) {
  //   if (controller != null && controller!.isVideoPlaying) {
  //     _videoList[index].status != "download"
  //         ? controller = PodPlayerController(
  //             podPlayerConfig: const PodPlayerConfig(
  //                 autoPlay: true, isLooping: false, initialVideoQuality: 360),
  //             playVideoFrom: PlayVideoFrom.youtube(
  //               _videoList[index].videoUrl.toString(),
  //             ),
  //           )
  //         : controller!.changeVideo(
  //             playVideoFrom: PlayVideoFrom.file(
  //                 File(_videoList[index].videoUrl.toString())),
  //           );
  //     if (controller!.videoPlayerValue!.hasError)
  //       print(controller!.videoPlayerValue!.errorDescription);
  //   }
  // }

  // _onTapVideo(int index) async {
  //   // ignore: non_constant_identifier_names
  //   _changeVideoPlaying(index);
  //   if (_videoList[index].status != "downloaded") {
  //     controller = PodPlayerController(
  //         playVideoFrom:
  //             PlayVideoFrom.youtube(_videoList[index].videoUrl.toString()),
  //         podPlayerConfig: const PodPlayerConfig(
  //             autoPlay: true, isLooping: false, initialVideoQuality: 360))
  //       ..initialise().then((_) {
  //         setState(() {});
  //       });
  //     if (controller!.videoPlayerValue!.hasError)
  //       print(controller!.videoPlayerValue!.errorDescription);
  //   } else {
  //     controller = PodPlayerController(
  //         playVideoFrom:
  //             PlayVideoFrom.file(File(_videoList[index].videoUrl.toString())),
  //         podPlayerConfig: const PodPlayerConfig(
  //             autoPlay: true, isLooping: false, initialVideoQuality: 360))
  //       ..initialise().then((_) {
  //         setState(() {});
  //       });

  //     if (controller!.videoPlayerValue!.hasError)
  //       print(controller!.videoPlayerValue!.errorDescription);
  //   }
  // }

  _listView() {
    //  downloadController = _downloadControllers;
    return _videoList.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              color: purple,
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8),
            itemCount: _videoList.length,
            itemBuilder: (_, int index) {
              return ListTile(
                  onTap: () {
                    Get.to(
                      VideoPlayers(
                        title: _videoList[index].videoName.toString(),
                        description: _videoList[index].videoDescript.toString(),
                        url: _videoList[index].videoUrl.toString(),
                        status: _videoList[index].status.toString(),
                      ),
                    );
                  },
                  isThreeLine: true,
                  dense: true,
                  enabled: true,
                  leading: Container(
                    width: 100,
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                                _videoList[index].thumbUrl.toString()),
                            fit: BoxFit.cover)),
                  ),
                  title: Text(
                    _videoList[index].videoName.toString(),
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text.rich(
                    TextSpan(text: _videoList[index].videoDescript.toString()),
                    softWrap: true,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple[500],
                    ),
                  ),
                  trailing: SizedBox(
                    width: 96,
                    child: AnimatedBuilder(
                      animation: _downloadControllers[index],
                      builder: (context, child) {
                        return DownloadButton(
                          status: _downloadControllers[index].downloadStatus,
                          downloadProgress:
                              _downloadControllers[index].progress,
                          onCancel: _downloadControllers[index].stopDownload,
                          onDownload: _downloadControllers[index].startDownload,
                          onOpen: _downloadControllers[index].deleteDownload,
                        );
                      },
                    ),
                  ));
            });
  }

  // _buildCard(int index) {
  //   Container(
  //     height: 135,
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               width: 80,
  //               height: 80,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10),
  //                   image: DecorationImage(
  //                       image:
  //                           NetworkImage(_videoList[index].thumbUrl.toString()),
  //                       fit: BoxFit.fill)),
  //             ),
  //             SizedBox(
  //               width: 10,
  //             ),
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   _videoList[index].videoName.toString(),
  //                   style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.only(top: 3),
  //                   child: Text(
  //                     _videoList[index].videoDescript.toString(),
  //                     style: TextStyle(color: Colors.grey[500]),
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     Container(
  //                       width: 80,
  //                       height: 20,
  //                       decoration: BoxDecoration(
  //                         color: Color(0xFFeaeefc),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: Center(
  //                         child: Text(
  //                           _videoList[index].duration.toString(),
  //                           style: TextStyle(
  //                             color: Color(0xFF839ed),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     // Row(
  //                     //   children: [
  //                     //     for (int i = 0; i < 70; i++)
  //                     //       i.isEven
  //                     //           ? Container(
  //                     //               width: 3,
  //                     //               height: 1,
  //                     //               decoration: BoxDecoration(
  //                     //                 color: Color(0xFF839ed),
  //                     //                 borderRadius: BorderRadius.circular(2),
  //                     //               ),
  //                     //             )
  //                     //           : Container(
  //                     //               width: 3,
  //                     //               height: 1,
  //                     //               color: Colors.white,
  //                     //             )
  //                     //   ],
  //                     // )
  //                   ],
  //                 )
  //               ],
  //             )
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
