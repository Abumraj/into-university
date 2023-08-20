class Subscription {
  int? id;
  String? planName;
  String? planPrice;
  String? planCode;
  String? description1;
  String? description2;
  String? description3;
  String? description4;
  String? description5;
  String? introUrl;
  Subscription(
      {this.id,
      this.planName,
      this.planPrice,
      this.planCode,
      this.description1,
      this.description2,
      this.description3,
      this.description4,
      this.description5,
      this.introUrl});

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      planName: json['planName'],
      planPrice: json['planPrice'],
      planCode: json['planCode'],
      description1: json['description1'],
      description2: json['description2'],
      description3: json['description3'],
      description4: json['description4'],
      description5: json['description5'],
      introUrl: json['introUrl'],
    );
  }
}
