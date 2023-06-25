class Customer {
  final String accessToken;
  final bool isstore;
  final String accountid;
  // final String message;

  const Customer(
      {
      required this.accessToken,
      required this.isstore,
      required this.accountid});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        accessToken: json['accessToken'],
        isstore: json['store'],
        accountid: json['accountId'],
        );
  }
}
