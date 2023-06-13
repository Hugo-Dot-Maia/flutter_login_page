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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserOrder &&
        this.helpedEmail == other.helpedEmail &&
        this.totalPrice == other.totalPrice &&
        this.status == other.status &&
        _listEquals(this.items, other.items);
  }

  @override
  int get hashCode {
    return helpedEmail.hashCode ^
        totalPrice.hashCode ^
        status.hashCode ^
        items.hashCode;
  }

  bool _listEquals(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;

    for (var i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }

    return true;
  }
}
