import 'package:flutter/material.dart';

import 'home_page.dart';
import 'store/cart_store.dart';

class CartWidget extends StatefulWidget {
  final CartStore cartStore;

  const CartWidget({super.key, required this.cartStore});

  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  late List<String> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = widget.cartStore.cartItems;
  }

  void _removeItemFromCart(String item) {
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

  double getItemPrice(String item) {
    // Calculate the price of an item
    return 10;
  }

  double _getTotalPrice() {
    // Calculate the total price of all the items in the cart
    double total = 0;
    for (String item in _cartItems) {
      total += getItemPrice(item);
    }
    return total;
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
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                String item = _cartItems[index];
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
                      title: Text(item),
                      subtitle: const Text('Item description goes here'),
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
                Text('Total: \$${_getTotalPrice()}'),
                ElevatedButton(
                  onPressed: () {
                    // Do something with the cart items, such as place an order
                    // and clear the cart.
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
