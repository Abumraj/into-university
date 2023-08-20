class StudentType {
  String? name;
  String? type;
  String? paymentModel;
  StudentType({this.name, this.type, this.paymentModel});

  factory StudentType.fromJson(Map<String, dynamic> json) {
    return StudentType(
      name: json['name'],
      type: json['type'],
      paymentModel: json['paymentModel'],
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "paymentModel": paymentModel,
      };
}
