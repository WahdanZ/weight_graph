import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'index.dart';

part 'rest_clinet.g.dart';

@RestApi(baseUrl: "https://6162956c37492500176315e3.mockapi.io/api")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/weight")
  Future<List<WeightModel>> getWeights();
  @POST("/weight")
  Future<void> addWeight(@Body() WeightModel model);
}
