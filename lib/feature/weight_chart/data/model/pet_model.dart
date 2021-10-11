import 'package:weight_graph/feature/weight_chart/data/index.dart';

class PetModel {
  String? name;
  String? petId;
  List<WeightModel> weights;

  PetModel({this.name, this.petId, required this.weights});

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      name: json['name'],
      petId: json['petId'],
      weights: json['weights'] != null
          ? (json['weights'] as List)
              .map((i) => WeightModel.fromJson(i))
              .toList()
          : <WeightModel>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['petId'] = petId;
    data['weights'] = weights.map((v) => v.toJson()).toList();
    return data;
  }
}
