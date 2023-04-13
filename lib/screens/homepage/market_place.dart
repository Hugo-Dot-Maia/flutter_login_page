import 'package:flutter/material.dart';
import 'package:flutter_login_page/constants.dart';

import 'market_place_filter.dart';

class MarketplaceWidget extends StatefulWidget {
  @override
  _MarketplaceWidgetState createState() => _MarketplaceWidgetState();
}

class _MarketplaceWidgetState extends State<MarketplaceWidget> {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to cart screen
            },
          ),
        ],
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
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for items',
                        border: InputBorder.none,
                        fillColor: Colors.white,
                        filled: true,
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
                if (_selectedFilters.isNotEmpty &&
                    !_selectedFilters.contains(item)) {
                  return const SizedBox
                      .shrink(); // Return an empty widget if the item is not selected
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
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(item),
                      subtitle: Text('Item description goes here'),
                      trailing: Text('\$10'),
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
