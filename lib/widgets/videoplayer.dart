import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:pod_player/pod_player.dart';

class VideoPlayers extends StatefulWidget {
  final String title;
  final String? url;
  final String? description;
  final String? status;
  final File? file;

  const VideoPlayers(
      {Key? key,
      required this.title,
      this.url,
      required this.description,
      this.file,
      required this.status})
      : super(key: key);

  @override
  State<VideoPlayers> createState() => _VideoPlayersState();
}

class _VideoPlayersState extends State<VideoPlayers> {
  bool isInitialized = false;
  late final PodPlayerController controller;

  @override
  void initState() {
    super.initState();
    secureScreen();
    isInitialized = false;
    controller = PodPlayerController(
        playVideoFrom: widget.status == 'downloaded'
            ? PlayVideoFrom.file(widget.file)
            : PlayVideoFrom.youtube(widget.url!),
        podPlayerConfig: const PodPlayerConfig(
            autoPlay: true, isLooping: false, initialVideoQuality: 360))
      ..initialise();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(widget.title),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: PodVideoPlayer(
            controller: controller,
            backgroundColor: Colors.white,
            podProgressBarConfig: PodProgressBarConfig(
              playingBarColor: Colors.purple,
              circleHandlerColor: Colors.purple,
              circleHandlerRadius: 12,
            ),
            onVideoError: () {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Center(
                  child: Text("An Error Occured"),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
