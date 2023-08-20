class FirebaseLocalNotification {
  String? isLive;
  String? dataTitle;
  String? dataBody;
  String? dataLink;
  String? dataImageLink;

  FirebaseLocalNotification({
    this.isLive,
    this.dataTitle,
    this.dataBody,
    this.dataLink,
    this.dataImageLink,
  });

  factory FirebaseLocalNotification.fromJson(Map<String, dynamic> json) {
    return FirebaseLocalNotification(
      isLive: json['isLive'],
      dataTitle: json['dataTitle'],
      dataBody: json['dataBody'],
      dataLink: json['dataLink'],
      dataImageLink: json['dataImageLink'],
    );
  }
  set id(int id) {}

  Map<String, dynamic> toJson() => {
        "isLive": isLive,
        "dataTitle": dataTitle,
        "dataBody": dataBody,
        "dataLink": dataLink,
        "dataImageLink": dataImageLink,
      };
}
