import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_graph/feature/weight_chart/data/index.dart';

import 'feature/weight_chart/presentation/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WeightCubit(RestClient(Dio()..interceptors.add(LogInterceptor()))),
      child: MaterialApp(
        title: 'Weight Demo',
        theme: ThemeData(
            primaryColor: Colors.orange, accentColor: Colors.orangeAccent),
        home: const WeighPage(),
      ),
    );
  }
}
