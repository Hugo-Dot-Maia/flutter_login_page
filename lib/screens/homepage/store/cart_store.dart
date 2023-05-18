import 'package:mobx/mobx.dart';

import '../../../entities/shopping_item.dart';

part 'cart_store.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  @observable
  int count = 0;

  @observable
  ObservableList<ShoppingItem> _cartItems = ObservableList<ShoppingItem>.of([]);

  @action
  void addItemToCart(ShoppingItem item) {
    _cartItems.add(item);
  }

  @action
  void removeItemFromCart(ShoppingItem item) {
    _cartItems.remove(item);
  }

  @action
  void clearCart() {
    _cartItems.clear();
  }

  List<ShoppingItem> get cartItems => _cartItems;

  @action
  void increment() {
    count++;
  }

  @action
  void decrement() {
    count--;
  }
}
