import 'package:f1_news/core/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/news_filter_controller.dart';
import '../../l10n/app_localizations.dart';

class FilterBar extends ConsumerStatefulWidget {
  final NewsFilterController filterController;

  const FilterBar({super.key, required this.filterController});

  @override
  ConsumerState<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends ConsumerState<FilterBar> {
  final TextEditingController _searchController = TextEditingController();
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() { //Bug barra di ricerca.
    super.initState();
    _searchController.text = widget.filterController.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drivers = ref.watch(driversProvider).value ?? [];
    final teams = ref.watch(constructorsProvider).value ?? [];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Barra di ricerca.
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.search,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  widget.filterController.updateSearchQuery('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              widget.filterController.updateSearchQuery(value);
            },
          ),

          const SizedBox(height: 12),

          //Dropdown
          Row(
            children: [
              //Piloti.
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: widget.filterController.selectedDriver,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l10n.genericFilter),
                    ),
                    for (final d in drivers)
                      DropdownMenuItem<String?>(
                        value: d.driver.id,
                        child: Text(d.driver.surname),
                      ),
                  ],
                  onChanged: (value) {
                    widget.filterController.updateDriver(value);
                  },
                  decoration: InputDecoration(
                    labelText: l10n.driver,
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12
                    ),
                  ),
                ),
              ),

              //Costruttori.
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: widget.filterController.selectedConstructor,
                  isExpanded: true,
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l10n.genericFilter),
                    ),
                    for (final t in teams)
                      DropdownMenuItem<String?>(
                        value: t.id,
                        child: Text(t.name),
                      ),
                  ],
                  onChanged: (value) {
                    widget.filterController.updateConstructor(value);
                  },
                  decoration: InputDecoration(
                    labelText: l10n.team,
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
