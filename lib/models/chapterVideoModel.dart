class ChapterList {
  int? id;
  String? coursecode;
  String? title;
  String? subtitle;
  String? liveUrl;
  String? type;
  String? status;
  String? chatLink;
  String? startAt;

  ChapterList({
    this.id,
    this.coursecode,
    this.title,
    this.subtitle,
    this.liveUrl,
    this.type,
    this.status,
    this.chatLink,
    this.startAt,
  });
  factory ChapterList.fromJson(Map<String, dynamic> json) => ChapterList(
        id: json["id"],
        coursecode: json["coursecode"],
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
        "coursecode": coursecode,
        "title": title,
        "subtitle": subtitle,
        "live_url": liveUrl,
        "type": type,
        "status": status,
        "chatLink": chatLink,
        "start_at": startAt!,
      };
}
