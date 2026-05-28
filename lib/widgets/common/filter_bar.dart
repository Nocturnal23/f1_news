import 'package:flutter/material.dart';

import '../../controllers/news_filter_controller.dart';

class FilterBar extends StatefulWidget {
  final NewsFilterController filterController;

  const FilterBar({super.key, required this.filterController});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cerca una notizia...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    widget.filterController.updateSearchQuery('');
                  },
                ),
              ),
                onChanged: (value) {
                  widget.filterController.updateSearchQuery(value);
                }
            ),
          ),
        ],
      ),
    );
  }
}
