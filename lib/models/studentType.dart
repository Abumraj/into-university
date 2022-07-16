class StudentType {
  String? name;
  String? type;
  StudentType({this.name, this.type});

  factory StudentType.fromJson(Map<String, dynamic> json) {
    return StudentType(
      name: json['name'],
      type: json['type'],
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
      };
}
