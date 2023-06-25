class Personal {
  final String name;
  final String username;
  final String birthday;
  final String sex;
  final int age;

  Personal(
      {required this.name,
      required this.username,
      required this.birthday,
      required this.sex,
      required this.age});

  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal(
      name: json['name'],
      username: json['username'],
      birthday: json['birthday'],
      sex: json['sex'],
      age: json['age']
    );
  }
}
