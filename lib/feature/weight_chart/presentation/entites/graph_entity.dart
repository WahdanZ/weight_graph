class WeightEntity {
  final double value;
  final DateTime dateTime;

  WeightEntity(this.value, this.dateTime);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightEntity &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          dateTime == other.dateTime;

  @override
  int get hashCode => value.hashCode ^ dateTime.hashCode;
}
