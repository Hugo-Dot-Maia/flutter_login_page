class UserOrder {
  String helpedEmail;
  double totalPrice;
  String status;
  List<String> items;

  UserOrder({
    required this.helpedEmail,
    required this.totalPrice,
    required this.status,
    required this.items,
  });
}
