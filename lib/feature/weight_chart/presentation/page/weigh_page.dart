import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_graph/feature/weight_chart/presentation/index.dart';

class WeighPage extends StatefulWidget {
  const WeighPage({Key? key}) : super(key: key);

  @override
  State<WeighPage> createState() => _WeighPageState();
}

class _WeighPageState extends State<WeighPage> {
  @override
  void initState() {
    context.read<WeightCubit>().loadWeights();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocConsumer<WeightCubit, WeightState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (state is WeightDataaState)
                    Flexible(
                      child: Container(
                          color: Colors.grey.shade100,
                          child: WeightGraphWidget(wights: state.weights)),
                    )
                ],
              );
            },
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
