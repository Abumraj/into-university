import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class VideoPlayers extends StatefulWidget {
  final String title;
  final String url;
  final String description;
  final String status;

  const VideoPlayers(
      {Key? key,
      required this.title,
      required this.url,
      required this.description,
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
    isInitialized = false;
    // _videoPlayerController = VideoPlayerController.network(widget.url);

    // _videoPlayerController2 = VideoPlayerController.file(File(url));
    controller = PodPlayerController(
        playVideoFrom: widget.status == 'downloaded'
            ? PlayVideoFrom.file(File(widget.url))
            : PlayVideoFrom.youtube(widget.url),
        podPlayerConfig: const PodPlayerConfig(
            autoPlay: true, isLooping: false, initialVideoQuality: 360))
      ..initialise();
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
      backgroundColor: Colors.purple,
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
