import 'package:flutter/material.dart';
import 'package:flutter_login_page/constants.dart';

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

  List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
    'Item 6',
    'Item 7',
    'Item 8',
    'Item 9',
  ];
  List<String> _selectedFilters = [];
  String _searchText = '';

  void _addToCart(String item) {
    setState(() {
      widget.cartStore.addItemToCart(item);
    });
  }

  void _showDetailsDialog(String item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item),
          content: Text('Additional information about $item goes here.'),
          actions: [
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('ADD TO CART'),
              onPressed: () {
                _addToCart(item);
                // Add item to cart
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
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                String item = items[index];
                if ((_selectedFilters.isNotEmpty &&
                        !_selectedFilters.contains(item)) ||
                    (_searchText.isNotEmpty &&
                        !item
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
                      title: Text(item),
                      subtitle: const Text('Item description goes --here'),
                      trailing: InkWell(
                        onTap: () => _showDetailsDialog(item),
                        child: const Icon(Icons.add_shopping_cart),
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
