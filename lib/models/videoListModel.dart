class VideoList {
  int? videoId;
  String? videoName;
  String? videoDescript;
  String? videoSize;
  String? videoUrl;
  String? thumbUrl;
  String? duration;
  String? status;
  VideoList(
      {this.videoName,
      this.videoSize,
      this.videoDescript,
      this.thumbUrl,
      this.duration,
      this.videoUrl,
      this.videoId,
      this.status});

  factory VideoList.fromJson(Map<String, dynamic> json) {
    return VideoList(
      thumbUrl: json["thumbUrl"],
      videoUrl: json["videoUrl"],
      videoName: json["videoName"],
      videoSize: json["videoSize"],
      duration: json["duration"],
      videoDescript: json["videoDescript"],
      status: json["status"],
      videoId: json["videoId"],
    );
  }

  set id(int id) {}
  Map<String, dynamic> toJson() => {
        "thumbUrl": thumbUrl,
        "videoUrl": videoUrl,
        "videoName": videoName,
        "videoSize": videoSize,
        "duration": duration,
        "videoDescript": videoDescript,
        "status": status,
        "videoId": videoId,
      };
}
