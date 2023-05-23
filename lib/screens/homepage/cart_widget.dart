import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Utils/sign_up_alert.dart';
import '../../constants.dart';
import '../../entities/shopping_item.dart';
import 'store/cart_store.dart';

class CartWidget extends StatefulWidget {
  final CartStore cartStore;

  const CartWidget({super.key, required this.cartStore});

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  late List<ShoppingItem> _cartItems;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _cartItems = widget.cartStore.cartItems;
  }

  void _removeItemFromCart(ShoppingItem item) {
    setState(() {
      widget.cartStore.removeItemFromCart(item);
      _cartItems = widget.cartStore.cartItems;
    });
  }

  void _clearCartItems() {
    setState(() {
      widget.cartStore.clearCart();
      _cartItems = widget.cartStore.cartItems;
    });
  }

  double _getTotalPrice() {
    // Calculate the total price of all the items in the cart
    double total = 0;
    for (var item in _cartItems) {
      total += item.price;
    }
    return total;
  }

  Future<void> _createOrder(List<ShoppingItem> cartItems) async {
    String userEmail = FirebaseAuth.instance.currentUser!.email!;
    var db = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final order = <String, dynamic>{
      'userEmail': userEmail,
      'items': cartItems.map((item) => item.itemName).toList(),
      'totalPrice': _getTotalPrice(),
      'status': 'pending',
    };
    try {
      await db
          .collection('orders')
          .doc(userId)
          .collection('userOrders')
          .doc()
          .set(order);
      showWarningDialog(context, 'Order placed successfully!');
    } catch (e) {
      showWarningDialog(context, 'An error occurred. Please try again later.');
    }
  }

  void _sortItemsByPrice() {
    setState(() {
      _sortAscending = !_sortAscending;
      _cartItems.sort((a, b) {
        return _sortAscending
            ? a.price.compareTo(b.price)
            : b.price.compareTo(a.price);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _sortItemsByPrice,
              child: Text(_sortAscending
                  ? 'Sort by Price (Low to High)'
                  : 'Sort by Price (High to Low)'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                ShoppingItem item = _cartItems[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(item.itemName),
                      subtitle: Text(item.description),
                      leading: Icon(item.type == ItemType.healthcare
                          ? Icons.local_hospital
                          : Icons.restaurant_menu),
                      trailing: InkWell(
                        onTap: () => _removeItemFromCart(item),
                        child: const Icon(Icons.remove_shopping_cart,
                            color: Colors.red),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${_getTotalPrice().toStringAsFixed(2)}',
                  style: totalTextStyle,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _createOrder(_cartItems);
                    _clearCartItems();
                  },
                  child: const Text('Place Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
