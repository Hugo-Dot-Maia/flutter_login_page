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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                String item = _cartItems[index];
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_shopping_cart),
                    onPressed: () => _removeItemFromCart(item),
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
                    _cartItems.clear();
                  },
                  child: const Text('Place Order'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the marketplace to add items to the cart
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
        child: const Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
