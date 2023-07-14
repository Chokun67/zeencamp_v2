class MenuList {
  final String nameMenu;
  final String pictures;
  final int price;
  final int exchange;
  final int receive;
  final String id;
  final int category;
  final int amountmenu;

  MenuList(
      {required this.nameMenu,
      required this.pictures,
      required this.price,
      required this.exchange,
      required this.receive,
      required this.id,
      required this.category,
      required this.amountmenu});

  factory MenuList.fromJson(Map<String, dynamic> json) {
    return MenuList(
        nameMenu: json['nameMenu'],
        pictures: json['pictures'],
        price: json['price'],
        exchange: json['exchange'],
        receive: json['receive'],
        id: json['id'],
        category: json['category'],
        amountmenu: json['amount']);
  }
}

class Qrhash {
  final int amount;
  final List<MenuList> menuStores;

  Qrhash({
    required this.amount,
    required this.menuStores,
  });
}
