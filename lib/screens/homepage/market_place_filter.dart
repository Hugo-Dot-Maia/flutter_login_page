import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final List<String> selectedFilters;
  final Function(List<String>) onSaveFilters;
  final Function() onClearFilters;

  FilterScreen({
    required this.selectedFilters,
    required this.onSaveFilters,
    required this.onClearFilters,
  });

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final List<String> _allFilters = [
    'Filter 1',
    'Filter 2',
    'Filter 3',
  ];

  void _toggleFilter(String filter) {
    setState(() {
      if (widget.selectedFilters.contains(filter)) {
        widget.selectedFilters.remove(filter);
      } else {
        widget.selectedFilters.add(filter);
      }
    });
  }

  void _clearFilters() {
    setState(() {
      widget.selectedFilters.clear();
    });
    widget.onClearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              children: const [
                Icon(Icons.filter_list, color: Colors.white, size: 32),
                SizedBox(width: 16),
                Text(
                  'Filters',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _allFilters.length,
              itemBuilder: (context, index) {
                final filter = _allFilters[index];
                return CheckboxListTile(
                  title: Text(filter),
                  value: widget.selectedFilters.contains(filter),
                  onChanged: (value) => _toggleFilter(filter),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _clearFilters,
            child: const Text('Clear Filters'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
