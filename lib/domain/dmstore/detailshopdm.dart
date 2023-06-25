class Store {
  final String nameMenu;
  final String pictures;
  final int price;
  final int exchange;
  final int receive;
  final String id;

  Store({
    required this.nameMenu,
    required this.pictures,
    required this.price,
    required this.exchange,
    required this.receive,
    required this.id
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      nameMenu: json['nameMenu'],
      pictures: json['pictures'],
      price: json['price'],
      exchange: json['exchange'],
      receive: json['receive'],
      id: json['id']
    );
  }
}

class StoreData {
  final String storePicture;
  final List<Store> menuStores;

  StoreData({
    required this.storePicture,
    required this.menuStores,
  });
}