class ValidateTranfer {
  final String payee;
  final String message;


  ValidateTranfer({
    required this.payee,
    required this.message,
  });

  factory ValidateTranfer.fromJson(Map<String, dynamic> json) {
    return ValidateTranfer(
      payee: json['payee'],
      message: json['message'],
    );
  }
}