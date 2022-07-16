class School {
  int? id;
  var schoolName;
  String? schoolCode;
  String? schoolChannel;

  School({this.id, this.schoolName, this.schoolChannel, this.schoolCode});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      schoolName: json['name'],
      schoolCode: json['code'],
      schoolChannel: json['channel'],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "schoolName": schoolName,
        "schoolCode": schoolCode,
        "schoolChannel": schoolChannel,
      };
}
