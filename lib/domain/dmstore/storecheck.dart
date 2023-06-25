class Check {
  final int code;
  final String message;

  Check({
    required this.code,
    required this.message,
  });

  factory Check.fromJson(Map<String, dynamic> json) {
    return Check(
      code: json['code'],
      message: json['message'],
    );
  }
}