// import 'dart:io';
// import 'dart:async';
// import 'dart:ui';
// import 'package:flowder/flowder.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// // ignore: import_of_legacy_library_into_null_safe
// import 'package:path_provider/path_provider.dart';
// import 'package:uniapp/dbHelper/db.dart';
// import 'package:uniapp/models/videoListModel.dart';
// import 'package:uniapp/widgets/downloadButton.dart';

// abstract class DownloadController implements ChangeNotifier {
//   DownloadStatus get downloadStatus;
//   double get progress;
//   void startDownload();
//   void stopDownload();
//   void deleteDownload();
// }

// class SimulatedDownLoadController extends DownloadController
//     with ChangeNotifier {
//   // DbHelper _dbHelper = Get.find<DbHelper>();
//   // Dio _dio = Dio();
//   // static VideoList get videoList => VideoList();
//   // late DownloaderUtils options;
//   // late DownloaderCore core;
//   // late final String path;
//   SimulatedDownLoadController({
//     DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
//     double progress = 0.0,
//     required VoidCallback onDeleteDownload,
//   })  : _downloadStatus = downloadStatus,
//         _progress = progress,
//         _onDeleteDownload = onDeleteDownload;
//   DownloadStatus _downloadStatus;
//   @override
//   DownloadStatus get downloadStatus => _downloadStatus;
//   double _progress;
//   @override
//   double get progress => _progress;
//   final VoidCallback _onDeleteDownload;
//   bool _isDownloading = false;

//   @override
//   void startDownload() {
//     if (downloadStatus == DownloadStatus.notDownloaded) {
//       _doSimulateDownload();
//     }
//   }

//   @override
//   void stopDownload() {
//     if (_isDownloading) {
//       _isDownloading = false;
//       _downloadStatus = DownloadStatus.notDownloaded;
//       _progress = 0.0;
//       notifyListeners();
//     }
//   }

//   @override
//   void deleteDownload() {
//     if (downloadStatus == DownloadStatus.downloaded) {
//       _onDeleteDownload();
//     }
//   }

//   Future<void> _doSimulateDownload() async {
//     isDownloading = true;
//     _downloadStatus = DownloadStatus.fetchingDownload;
//     notifyListeners();
//     await Future<void>.delayed(Duration(seconds: 1));
//     if (!_isDownloading) {
//       return;
//     }
//     _downloadStatus = DownloadStatus.downloading;
//     notifyListeners();
//     const downloadProgressStops = [0.0, 0.15, 0.45, 0.8, 1.0];
//     for (final stop in downloadProgressStops) {
//       await Future<void>.delayed(Duration(seconds: 1));
//       if (!_isDownloading) {
//         return;
//       }
//       _progress = stop;
//       notifyListeners();
//     }
//     await Future<void>.delayed(Duration(seconds: 1));
//     if (!_isDownloading) {
//       return;
//     }
//     _downloadStatus = DownloadStatus.downloaded;
//     _isDownloading = false;
//     notifyListeners();
//   }
// }

// @immutable
// class DownloadButton extends StatelessWidget {}

//   // Future<void> initPlatformState() async {
//   //   _setPath();
//   // }

//   // void _setPath() async {
//   //   Directory _path = await getApplicationDocumentsDirectory();
//   //   String _localPath = _path.path + Platform.pathSeparator + 'Download';
//   //   final savedDir = Directory(_localPath);
//   //   bool hasExisted = await savedDir.exists();
//   //   if (!hasExisted) {
//   //     savedDir.create();
//   //   }
//   // }

//   // downLoad() async {
//   //   String tpath = path + '/' + videoThumb;
//   //   VideoList videoList = VideoList(
//   //       videoName: videoName,
//   //       videoDescript: videoDescription,
//   //       videoSize: videoSize,
//   //       videoUrl: path,
//   //       thumbUrl: tpath);

//   //   options = DownloaderUtils(
//   //     progressCallback: (current, total) {
//   //       progress = (current / total) * 100;
//   //       print('Downloading: $progress');
//   //     },
//   //     file: File('$path/'),
//   //     progress: ProgressImplementation(),
//   //     onDone: () => _dbHelper.saveVideo(videoList),
//   //     deleteOnCancel: true,
//   //   );
//   //   core = await Flowder.download(url, options);
//   //   downLoadedVideo = core.obs as RxList<Flowder>;
//   //   //core.download(url, options)
//   //   _dio.download(videoThumb, tpath);
//   // }

//   // cancel() {
//   //   core.cancel();


