part of 'weight_cubit.dart';

@immutable
abstract class WeightState {}

class WeightInitialState extends WeightState {}

class WeightLoadingState extends WeightState {}

class WeightDataState extends WeightState {
  final List<WeightEntity> weights;

  WeightDataState(this.weights);
}

class WeightNoDataState extends WeightState {}

class WeightErrorState extends WeightState {
  final String error;

  WeightErrorState(this.error);
}
