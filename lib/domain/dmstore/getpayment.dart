class PaymentList {
  final String id;
  final double price;
  final int point;

  PaymentList({
    required this.id,
    required this.price,
    required this.point
  });

  factory PaymentList.fromJson(Map<String, dynamic> json) {
    return PaymentList(
      id: json['id'],
      price: json['price'],
      point: json['point']
    );
  }
}