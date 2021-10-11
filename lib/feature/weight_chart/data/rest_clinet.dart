import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'index.dart';
import 'model/pet_model.dart';

part 'rest_clinet.g.dart';

@RestApi(baseUrl: "https://petweight.herokuapp.com/api")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/{id}/weights")
  Future<PetModel> getWeights(@Path("id") String petId);
  @POST("/{id}/weights")
  Future<void> addWeight(@Path("id") String petId, @Body() WeightModel model);
}
