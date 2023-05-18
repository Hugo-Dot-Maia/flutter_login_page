class ShoppingItem {
  final String itemName;
  final String description;
  final ItemType type;
  final double price;

  ShoppingItem({
    required this.itemName,
    required this.description,
    required this.type,
    this.price = 0.0,
  });
}

enum ItemType {
  consumableGoods,
  healthcare,
}
