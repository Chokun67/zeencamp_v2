class Allstore {
  final String id;
  final String name;
  final String storePicture;

  Allstore({
    required this.id,
    required this.name,
    required this.storePicture
  });

  factory Allstore.fromJson(Map<String, dynamic> json) {
    return Allstore(
      id: json['id'],
      name: json['name'],
      storePicture: json['picture']
    );
  }
}
