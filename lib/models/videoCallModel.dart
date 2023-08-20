class CourseVideo {
  int? id;
  String? title;
  String? subtitle;
  String? liveUrl;
  String? type;
  String? status;
  String? chatLink;
  String? startAt;

  CourseVideo({
    this.id,
    this.title,
    this.subtitle,
    this.liveUrl,
    this.type,
    this.status,
    this.chatLink,
    this.startAt,
  });
  factory CourseVideo.fromJson(Map<String, dynamic> json) => CourseVideo(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        liveUrl: json["live_url"],
        type: json["type"],
        status: json["status"],
        chatLink: json["chatLink"],
        startAt: json["start_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "live_url": liveUrl,
        "type": type,
        "status": status,
        "chatLink": chatLink,
        "start_at": startAt
      };
}
