import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:weight_graph/feature/weight_chart/data/index.dart';
import 'package:weight_graph/feature/weight_chart/presentation/index.dart';

part 'weight_state.dart';

class WeightCubit extends Cubit<WeightState> {
  final RestClient _restClient;

  int _wight = 1;
  final int petId = Random().nextInt(100);
  DateTime _date = DateTime.now();
  WeightCubit(this._restClient) : super(WeightInitialState());

  void loadWeights() async {
    emit(WeightLoadingState());
    try {
      final data = await _restClient.getWeights(petId.toString());
      if (data.weights.length > 2) {
        emit(WeightDataState(_mapToEntity(data.weights)));
      } else {
        emit(WeightNoDataState());
      }
    } catch (e, s) {
      emit(WeightErrorState("Failed to get data"));
      debugPrintStack(stackTrace: s);
    }
  }

  List<WeightEntity> _mapToEntity(List<WeightModel> weight) {
    return weight
        .map((e) {
          if (e.weight != null && e.date != null) {
            return WeightEntity(e.weight!.toDouble(), e.date!);
          }
          return null;
        })
        .whereType<WeightEntity>()
        .toList();
  }

  addCurrentWeight() async {
    try {
      await _restClient.addWeight(
          petId.toString(), WeightModel(date: _date, weight: _wight));
      loadWeights();
    } catch (e, s) {
      emit(WeightErrorState("Failed to Add data"));
      print(e);
      debugPrintStack(stackTrace: s);
    }
  }

  setWeight(int value) {
    _wight = value;
  }

  setDate(DateTime dateTime) {
    _date = dateTime;
  }
}
