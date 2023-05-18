import 'package:flutter/material.dart';
import 'package:flutter_login_page/constants.dart';
import 'package:flutter_login_page/entities/shopping_item.dart';

import '../../Utils/shopping_list.dart';
import 'market_place_filter.dart';
import 'store/cart_store.dart';

class MarketplaceWidget extends StatefulWidget {
  final CartStore cartStore;

  const MarketplaceWidget({Key? key, required this.cartStore})
      : super(key: key);

  @override
  _MarketplaceWidgetState createState() => _MarketplaceWidgetState();
}

class _MarketplaceWidgetState extends State<MarketplaceWidget> {
  TextEditingController _searchController = TextEditingController();
  var test = shoppingList;

  List<String> _selectedFilters = [];
  String _searchText = '';

  void _addToCart(ShoppingItem item) {
    if (widget.cartStore.cartItems.contains(item)) {
      // Show warning message to user that item is already in cart
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item.itemName} is already in the cart.'),
        ),
      );
    } else {
      setState(() {
        widget.cartStore.addItemToCart(item);
      });
    }
  }

  void _showDetailsDialog(ShoppingItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.itemName),
          content: Text(item.description),
          actions: [
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('ADD TO CART'),
              onPressed: () {
                _addToCart(item);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onSaveFilters(List<String> selectedFilters) {
    setState(() {
      _selectedFilters = selectedFilters;
    });
    // Do something with the selected filters, such as filtering data
    // and updating the UI.
  }

  void _onClearFilters() {
    setState(() {
      _selectedFilters.clear();
    });
    // Do something to clear the filters, such as resetting data
    // and updating the UI.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
      ),
      drawer: FilterScreen(
        selectedFilters: _selectedFilters,
        onSaveFilters: _onSaveFilters,
        onClearFilters: _onClearFilters,
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.shopping_cart,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for items',
                        border: InputBorder.none,
                        fillColor: kPrimaryLightColor,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: shoppingList.length,
              itemBuilder: (BuildContext context, int index) {
                ShoppingItem item = shoppingList[index];
                if ((_selectedFilters.isNotEmpty &&
                        !_selectedFilters.contains(item.itemName)) ||
                    (_searchText.isNotEmpty &&
                        !item.itemName
                            .toLowerCase()
                            .contains(_searchText.toLowerCase()))) {
                  return const SizedBox.shrink();
                }
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
                        onTap: () => _showDetailsDialog(item),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
