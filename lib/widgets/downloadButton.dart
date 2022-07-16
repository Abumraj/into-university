import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uniapp/dbHelper/db.dart';
import 'package:uniapp/models/videoListModel.dart';
import 'package:uniapp/widgets/introvideopopup.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  downloading,
  downloaded,
}

abstract class DownloadController implements ChangeNotifier {
  DownloadStatus get downloadStatus;
  double get progress;
  String get videoName;
  String get description;
  String get videoUrl;
  String get thumbUrl;
  void startDownload();
  void stopDownload();
  void deleteDownload();
}

class SimulatedDownLoadController extends DownloadController
    with ChangeNotifier {
  SimulatedDownLoadController({
    required DownloadStatus downloadStatus,
    required String description,
    required String videoName,
    required String thumbUrl,
    required String videoUrl,
    double progress = 0.0,
  })  : _downloadStatus = downloadStatus,
        _progress = progress,
        _videoName = videoName,
        _thumbUrl = thumbUrl,
        _videoUrl = videoUrl,
        _description = description;
  String _description;
  @override
  String get description => _description;
  String _videoName;
  @override
  String get videoName => _videoName;
  String _videoUrl;
  @override
  String get videoUrl => _videoUrl;
  String _thumbUrl;
  @override
  String get thumbUrl => _thumbUrl;
  DownloadStatus _downloadStatus;
  @override
  DownloadStatus get downloadStatus => _downloadStatus;
  double _progress;
  @override
  double get progress => _progress;
  bool _isDownloading = false;
  int total = 0;
  Dio _dio = Dio();
  File? fileName;
  CancelToken cancelDownload = CancelToken();
  DbHelper _dbHelper = DbHelper();

  String path = '';

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get localFile async {
    final paths = await localPath;
    path = '$paths/$_videoName.mp4';
    fileName = File(path);

    print(fileName);
    return File(path);
  }

  @override
  void startDownload() {
    if (downloadStatus == DownloadStatus.notDownloaded) {
      localFile;
      _doSimulateDownload();
    }
  }

  @override
  void stopDownload() {
    if (_isDownloading) {
      cancelDownload.cancel();
      _isDownloading = false;
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      notifyListeners();
    }
  }

  @override
  void deleteDownload() {
    if (downloadStatus == DownloadStatus.downloaded) {
      _onDeleteDownload();
    }
  }

  Future<void> _onDeleteDownload() async {
    try {
      final targetFile = File(_videoUrl);
      if (targetFile.existsSync()) {
        targetFile.deleteSync(recursive: true);
        _dbHelper.deleteVideo(_videoUrl);
      }
      GetSnackBar(title: 'Video', message: 'Video deleted successfully');
    } catch (e) {}
  }

  Future<void> _doSimulateDownload() async {
    _isDownloading = true;
    String url = '';
    _downloadStatus = DownloadStatus.fetchingDownload;
    notifyListeners();
    final extractor = YoutubeExplode();
    String videoId = _videoUrl;
    final streamManifest =
        await extractor.videos.streamsClient.getManifest(videoId);
    final streamInfo = streamManifest.muxed.bestQuality;
    extractor.close();

    url = streamInfo.url.toString();
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();
    void showDownloadProgress(received, total) {
      if (total != -1) {
        _progress = ((received / total));
        notifyListeners();
        print(_progress * 100);
      }
    }

    if (!_isDownloading) {
      return stopDownload();
    } else {
      await _dio.download(
        url,
        path,
        onReceiveProgress: showDownloadProgress,
        cancelToken: cancelDownload,
      );

      _dbHelper.saveVideo(VideoList(
          videoName: _videoName,
          videoDescript: _description,
          videoUrl: path,
          thumbUrl: _thumbUrl,
          status: "downloaded"));
    }

    // await Future<void>.delayed(Duration(seconds: 1));

    _downloadStatus = DownloadStatus.downloaded;
    _isDownloading = false;
    notifyListeners();
    GetSnackBar(
      title: _videoName,
      message: "downloaded successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    required this.status,
    this.downloadProgress = 0.0,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 500),
  });

  final DownloadStatus status;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;
  final Duration transitionDuration;

  bool get _isDownloading => status == DownloadStatus.downloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
        break;
      case DownloadStatus.fetchingDownload:
        // do nothing.
        break;
      case DownloadStatus.downloading:
        onCancel();
        break;
      case DownloadStatus.downloaded:
        // do nothing
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          ButtonShapeWidget(
            transitionDuration: transitionDuration,
            isDownloaded: _isDownloaded,
            isDownloading: _isDownloading,
            isFetching: _isFetching,
            delete: onOpen,
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: transitionDuration,
              opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
              curve: Curves.ease,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ProgressIndicatorWidget(
                    downloadProgress: downloadProgress,
                    isDownloading: _isDownloading,
                    isFetching: _isFetching,
                  ),
                  if (_isDownloading)
                    const Icon(
                      Icons.cancel_sharp,
                      size: 16,
                      color: CupertinoColors.systemPurple,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget(
      {required this.isDownloading,
      required this.isDownloaded,
      required this.isFetching,
      required this.transitionDuration,
      required this.delete});

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final Duration transitionDuration;
  final VoidCallback delete;

  @override
  Widget build(BuildContext context) {
    var shape = const ShapeDecoration(
      shape: CircleBorder(),
      color: CupertinoColors.lightBackgroundGray,
    );

    if (isDownloading || isFetching) {
      shape = ShapeDecoration(
        shape: const CircleBorder(),
        color: Colors.white.withOpacity(0),
      );
    }

    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: shape,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedOpacity(
          duration: transitionDuration,
          opacity: isDownloading || isFetching ? 0.0 : 1.0,
          curve: Curves.ease,
          child: isDownloaded
              ? IconButton(
                  onPressed: () {
                    final deleteFromStorage = ValueNotifier<bool>(true);
                    showPopoverWB(
                        context: context,
                        title: "Confirm!",
                        builder: (ctx) => ValueListenableBuilder<bool>(
                            valueListenable: deleteFromStorage,
                            builder: (_, value, ___) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Clear item from download list?',
                                      style: context.textTheme.bodyText1),
                                  CheckboxListTile(
                                    value: value,
                                    onChanged: (val) =>
                                        deleteFromStorage.value = val!,
                                    title:
                                        const Text("Also delete from storage"),
                                  ),
                                ],
                              );
                            }),
                        confirmText: "Yes",
                        onConfirm: () {
                          delete();
                        });
                  },
                  icon: Icon(
                    Icons.download_done_sharp,
                    color: CupertinoColors.systemPurple,
                  ),
                )
              : Icon(
                  Icons.download,
                  color: CupertinoColors.systemPurple,
                ),
        ),
      ),
    );
  }
}

@immutable
class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    required this.downloadProgress,
    required this.isDownloading,
    required this.isFetching,
  });

  final double downloadProgress;
  final bool isDownloading;
  final bool isFetching;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: downloadProgress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: isDownloading
                ? CupertinoColors.lightBackgroundGray
                : Colors.white.withOpacity(0),
            valueColor: AlwaysStoppedAnimation(isFetching
                ? CupertinoColors.lightBackgroundGray
                : CupertinoColors.activeBlue),
            strokeWidth: 2,
            value: isFetching ? null : progress,
          );
        },
      ),
    );
  }
}
