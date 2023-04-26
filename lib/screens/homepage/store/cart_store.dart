import 'package:mobx/mobx.dart';

part 'cart_store.g.dart';

class CartStore = _CartStore with _$CartStore;

abstract class _CartStore with Store {
  @observable
  int count = 0;

  @observable
  ObservableList<String> _cartItems = ObservableList<String>.of([]);

  @action
  void addItemToCart(String item) {
    _cartItems.add(item);
  }

  @action
  void removeItemFromCart(String item) {
    _cartItems.remove(item);
  }

  List<String> get cartItems => _cartItems;

  @action
  void increment() {
    count++;
  }

  @action
  void decrement() {
    count--;
  }
}
