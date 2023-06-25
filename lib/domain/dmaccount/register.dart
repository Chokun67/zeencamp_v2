class Register {
  final String accessToken;
  final bool isstore;
  // final String message;
  final String accountid;

  const Register(
      {
      required this.accessToken,
      required this.isstore,
      required this.accountid,
      });

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(

        accessToken: json['accessToken'],
        isstore: json['store'],
        accountid: json['accountId']
        );
  }
}
