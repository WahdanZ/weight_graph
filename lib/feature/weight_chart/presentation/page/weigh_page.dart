import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_graph/feature/weight_chart/presentation/index.dart';
import 'package:weight_graph/feature/weight_chart/presentation/widgets/number_picker.dart';
import 'package:weight_graph/styles/app_colors.dart';
import 'package:weight_graph/styles/index.dart';
import 'package:weight_graph/utils/bottom_sheet.dart';

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
            listener: (context, state) {
              if (state is WeightErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ));
              }
            },
            buildWhen: (prv, current) => (current is! WeightErrorState),
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Flexible(
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Weight Graph",
                          style: labelTextStyle,
                        )),
                  ),
                  if (state is WeightDataState)
                    Flexible(
                      flex: 3,
                      child: Container(
                          color: Colors.grey.shade100,
                          child: WeightGraphWidget(
                            wights: state.weights,
                          )),
                    ),
                  if (state is WeightInitialState || state is WeightNoDataState)
                    const Flexible(
                      flex: 3,
                      child: Text("Not Data (add at least 3 data points)"),
                    ),
                  if (state is WeightLoadingState)
                    const Flexible(
                      flex: 3,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: OutlinedButton.icon(
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.buttonColor,
                        ),
                        label: Text(
                          "Add Weight",
                          style: buttonTextStyle.copyWith(
                              color: AppColors.buttonColor),
                        ),
                        onPressed: () => showAppSheetBottomSheet(context,
                            child: SizedBox(
                              height: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Expanded(
                                            child: Text(
                                          "Wight",
                                          textAlign: TextAlign.center,
                                          style: labelTextStyle,
                                        )),
                                        Expanded(
                                            flex: 3,
                                            child: Text(
                                              "Date",
                                              textAlign: TextAlign.center,
                                              style: labelTextStyle,
                                            ))
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            child: SizedBox(
                                                height: 216.0,
                                                child: NumberPicker(
                                                  onSelectedItemChanged:
                                                      (value) => context
                                                          .read<WeightCubit>()
                                                          .setWeight(value),
                                                ))),
                                        Flexible(
                                          flex: 3,
                                          child: CupertinoDatePicker(
                                              minimumYear:
                                                  DateTime.now().year - 1,
                                              maximumYear: DateTime.now().year,
                                              maximumDate: DateTime.now().add(
                                                  const Duration(seconds: 60)),
                                              initialDateTime: DateTime.now(),
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                              onDateTimeChanged: (dateTime) =>
                                                  context
                                                      .read<WeightCubit>()
                                                      .setDate(dateTime)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ), onClicked: () {
                          context.read<WeightCubit>().addCurrentWeight();
                          Navigator.pop(context);
                        }),
                        style: rounderButtonStyle(
                            AppColors.buttonColor.withOpacity(.25)),
                      ),
                    ),
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
