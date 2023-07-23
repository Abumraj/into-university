import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import '../widgets/videoplayer.dart';

class OfflineDownloads extends StatefulWidget with WidgetsBindingObserver {
  const OfflineDownloads({Key? key}) : super(key: key);

  @override
  _OfflineDownloadsState createState() => _OfflineDownloadsState();
}

class _OfflineDownloadsState extends State<OfflineDownloads> {
  final ReceivePort _port = ReceivePort();
  List<Map> downloadsListMaps = [];

  @override
  void initState() {
    super.initState();
    task();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      var task = downloadsListMaps.where((element) => element['id'] == id);
      for (var element in task) {
        element['progress'] = progress;
        element['status'] = status;
        setState(() {});
      }
    });
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  Future task() async {
    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
    for (var _task in getTasks!) {
      Map _map = {};
      _map['status'] = _task.status;
      _map['progress'] = _task.progress;
      _map['id'] = _task.taskId;
      _map['filename'] = _task.filename;
      _map['savedDirectory'] = _task.savedDir;
      if (_task.filename!.length > 10) {
        downloadsListMaps.add(_map);
      }
    }
    setState(() {});
  }

  Future deleteAllTask() async {
    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
    for (var _task in getTasks!) {
      FlutterDownloader.remove(
        taskId: _task.taskId,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: Text('Downloads'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Icon(Icons.delete_rounded, size: 28, color: Colors.red),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      title: new Text(
                        "Delete all videos Permanetly?",
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
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () async {
                            await deleteAllTask();
                          },
                        ),
                        SizedBox(
                          width: 150,
                        ),
                        TextButton(
                          child: new Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      body: downloadsListMaps.length == 0
          ? Center(child: Text("No Downloads yet"))
          : Container(
              child: ListView.builder(
                itemCount: downloadsListMaps.length,
                itemBuilder: (BuildContext context, int i) {
                  Map _map = downloadsListMaps[i];
                  String _filename = _map['filename'];
                  String _directory = _map['savedDirectory'];
                  int _progress = _map['progress'];
                  DownloadTaskStatus _status = _map['status'];
                  List<FileSystemEntity> _directories =
                      Directory(_directory).listSync(followLinks: true);
                  File? _file = (_directories.isNotEmpty
                      ? _directories.first
                      : null) as File?;
                  String _id = _map['id'];
                  return GestureDetector(
                    onTap: () {
                      if (_status == DownloadTaskStatus.complete) {
                        Get.to(VideoPlayers(
                          title: _filename,
                          file: _file,
                          status: "downloaded",
                          description: "No Description",
                        ));
                      }
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            isThreeLine: false,
                            title: Text(_filename),
                            subtitle: downloadStatus(_status),
                            trailing: SizedBox(
                              child: buttons(_status, _id, i),
                              width: 60,
                            ),
                          ),
                          _status == DownloadTaskStatus.complete
                              ? Container()
                              : SizedBox(height: 5),
                          _status == DownloadTaskStatus.complete
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text('$_progress%'),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value: _progress / 100,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(height: 10)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget downloadStatus(DownloadTaskStatus _status) {
    return _status == DownloadTaskStatus.canceled
        ? Text('Download canceled')
        : _status == DownloadTaskStatus.complete
            ? const Text('Download completed')
            : _status == DownloadTaskStatus.failed
                ? const Text('Download failed')
                : _status == DownloadTaskStatus.paused
                    ? const Text('Download paused')
                    : _status == DownloadTaskStatus.running
                        ? const Text('Downloading..')
                        : const Text('Download waiting');
  }

  Widget buttons(DownloadTaskStatus _status, String taskid, int index) {
    void changeTaskID(String taskid, String newTaskID) {
      Map? task = downloadsListMaps.firstWhere(
        (element) => element['taskId'] == taskid,
      );
      task['taskId'] = newTaskID;
      setState(() {});
    }

    return _status == DownloadTaskStatus.canceled
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                child: Icon(Icons.cached, size: 20, color: Colors.green),
                onTap: () {
                  FlutterDownloader.retry(taskId: taskid).then(
                    (newTaskID) => changeTaskID(taskid, newTaskID!),
                  );
                },
              ),
              GestureDetector(
                child: Icon(Icons.delete, size: 20, color: Colors.red),
                onTap: () {
                  downloadsListMaps.removeAt(index);
                  FlutterDownloader.remove(
                      taskId: taskid, shouldDeleteContent: true);
                  setState(() {});
                },
              )
            ],
          )
        : _status == DownloadTaskStatus.failed
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Icon(Icons.cached, size: 20, color: Colors.green),
                    onTap: () {
                      FlutterDownloader.retry(taskId: taskid).then(
                        (newTaskID) => changeTaskID(taskid, newTaskID!),
                      );
                    },
                  ),
                  GestureDetector(
                    child: Icon(Icons.delete, size: 20, color: Colors.red),
                    onTap: () {
                      downloadsListMaps.removeAt(index);
                      FlutterDownloader.remove(
                          taskId: taskid, shouldDeleteContent: true);
                      setState(() {});
                    },
                  )
                ],
              )
            : _status == DownloadTaskStatus.paused
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(Icons.play_arrow,
                            size: 20, color: Colors.blue),
                        onTap: () {
                          FlutterDownloader.resume(taskId: taskid).then(
                            (newTaskID) => changeTaskID(taskid, newTaskID!),
                          );
                        },
                      ),
                      GestureDetector(
                        child: Icon(Icons.close, size: 20, color: Colors.red),
                        onTap: () {
                          FlutterDownloader.cancel(taskId: taskid);
                        },
                      )
                    ],
                  )
                : _status == DownloadTaskStatus.running
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(Icons.pause,
                                size: 20, color: Colors.green),
                            onTap: () {
                              FlutterDownloader.pause(taskId: taskid);
                            },
                          ),
                          GestureDetector(
                            child:
                                Icon(Icons.close, size: 20, color: Colors.red),
                            onTap: () {
                              FlutterDownloader.cancel(taskId: taskid);
                            },
                          )
                        ],
                      )
                    : _status == DownloadTaskStatus.complete
                        ? GestureDetector(
                            child: Icon(Icons.more_vert,
                                size: 28, color: Colors.red),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text(
                                      "Delete this video Permanetly?",
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
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onTap: () {
                                          downloadsListMaps.removeAt(index);
                                          FlutterDownloader.remove(
                                              taskId: taskid,
                                              shouldDeleteContent: true);
                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                      ),
                                      SizedBox(
                                        width: 100,
                                      ),
                                      TextButton(
                                        child: new Text("Cancel"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          )
                        : Container();
  }

  // showDialogue(File file) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Dialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(8))),
  //           child: Padding(
  //             padding: const EdgeInsets.all(2.0),
  //             child: Container(
  //               child: Image.file(
  //                 file,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

}
