class WeightModel {
  DateTime? date;
  String? id;
  num? weight;

  WeightModel({this.date, this.id, this.weight});

  factory WeightModel.fromJson(Map<String, dynamic> json) {
    return WeightModel(
      date: DateTime.parse(json["date"]),
      id: json['id'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date?.toIso8601String();
    data['id'] = id;
    data['weight'] = weight;
    return data;
  }
}
