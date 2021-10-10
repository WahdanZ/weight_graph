part of 'weight_cubit.dart';

@immutable
abstract class WeightState {}

class WeightInitialState extends WeightState {}

class WeightLoadingState extends WeightState {}

class WeightDataaState extends WeightState {
  final List<WeightEntity> weights;

  WeightDataaState(this.weights);
}
