class Program {
  int? id;
  var programName;
  String? programCode;

  Program({this.id, this.programName, this.programCode});

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'],
      programName: json['name'],
      programCode: json['code'],
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "programName": programName,
        "programCode": programCode,
      };
}
