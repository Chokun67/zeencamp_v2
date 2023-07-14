class PaymentList {
  final String id;
  final String price;
  final String point;

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