import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weight_graph/feature/weight_chart/data/index.dart';
import 'package:weight_graph/feature/weight_chart/presentation/index.dart';

part 'weight_state.dart';

class WeightCubit extends Cubit<WeightState> {
  final RestClient _restClient;
  WeightCubit(this._restClient) : super(WeightInitialState());

  void loadWeights() async {
    emit(WeightLoadingState());
    final data = await _restClient.getWeights();
    emit(WeightDataaState(_mapToEntity(data)));
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
}
