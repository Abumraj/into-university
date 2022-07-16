class CourseLevel {
  String? name;
  int? level;
  CourseLevel({this.name, this.level});

  factory CourseLevel.fromJson(Map<String, dynamic> json) {
    return CourseLevel(
      name: json['name'],
      level: json['level'],
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "level": level,
      };
}
