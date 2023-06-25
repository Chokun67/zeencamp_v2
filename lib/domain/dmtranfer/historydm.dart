class DepositModel {
  final String state;
  final DateTime date;
  final int point;
  final String opposite;

  DepositModel({
    required this.state,
    required this.date,
    required this.point,
    required this.opposite
  });

  factory DepositModel.fromJson(Map<String, dynamic> json) {
    return DepositModel(
      state: json['state'],
      date: DateTime.parse(json['date']),
      point: json['point'],
      opposite: json['opposite'],
    );
  }
}
