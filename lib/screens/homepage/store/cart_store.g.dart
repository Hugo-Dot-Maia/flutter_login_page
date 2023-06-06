// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CartStore on _CartStore, Store {
  late final _$_cartItemsAtom =
      Atom(name: '_CartStore._cartItems', context: context);

  @override
  ObservableList<ShoppingItem> get _cartItems {
    _$_cartItemsAtom.reportRead();
    return super._cartItems;
  }

  @override
  set _cartItems(ObservableList<ShoppingItem> value) {
    _$_cartItemsAtom.reportWrite(value, super._cartItems, () {
      super._cartItems = value;
    });
  }

  late final _$_CartStoreActionController =
      ActionController(name: '_CartStore', context: context);

  @override
  void addItemToCart(ShoppingItem item) {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.addItemToCart');
    try {
      return super.addItemToCart(item);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItemFromCart(ShoppingItem item) {
    final _$actionInfo = _$_CartStoreActionController.startAction(
        name: '_CartStore.removeItemFromCart');
    try {
      return super.removeItemFromCart(item);
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearCart() {
    final _$actionInfo =
        _$_CartStoreActionController.startAction(name: '_CartStore.clearCart');
    try {
      return super.clearCart();
    } finally {
      _$_CartStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
