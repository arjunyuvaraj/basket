// IMPORTS
import 'package:basket/components/food_tile.dart';
import 'package:basket/components/welcome_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  final String? initialStore;
  ListPage({super.key, this.initialStore});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // VARIABLES
  Map<String, dynamic> _fullList = {};
  List<String> _stores = [];
  String? _dropdownValue;

  // HELPER METHODS
  Future<void> _fetchItems() async {
    // Variables
    final doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get();

    final data = doc.data();
    final itemsMap = Map<String, dynamic>.from(data?['items'] ?? {});
    final storeKeys = itemsMap.keys.toList();

    if (data == null) return;

    // After fetching, reload components so that everything is updated
    setState(() {
      _fullList = itemsMap;
      _stores = storeKeys;
      _dropdownValue =
          widget.initialStore ?? (_stores.isNotEmpty ? _stores.first : null);
    });
  }

  // Provided with section header and items, build the required section
  Widget _buildCategory(
    String title,
    List<MapEntry<int, Map<String, dynamic>>> items,
  ) {
    return ExpansionTile(
      title: Text(title),
      children: [
        ...items.map(
          (item) => Container(
            margin: EdgeInsets.only(bottom: 12),
            child: FoodTile(
              itemName: item.value['name'],
              itemQuantity: item.value['quantity'].toString(),
              completed: item.value['completed'],
              label: "DONE",
              labelSecond: "DELETE",
              onTap: () => _handleCheck(item.key),
              onTapSecond: () => _handleDelete(item.key),
              onTapThird: () => _handleEssential(item.key),
              essential: item.value['essential'] ?? false,
            ),
          ),
        ),
      ],
    ); // placeholder
  }

  List<Map<String, dynamic>> _getItemsForStore(String store) {
    final items = _fullList[store];
    if (items == null) return [];
    return List<Map<String, dynamic>>.from(items);
  }

  // After checking, deleting, or unchecking an item, re-build the page
  Future<void> _updateStoreItems(
    String store,
    List<Map<String, dynamic>> items,
  ) async {
    final updated = Map<String, dynamic>.from(_fullList);

    if (items.isEmpty) {
      updated.remove(store);
    } else {
      updated[store] = items;
    }

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .update({'items': updated});

    setState(() {
      _fullList = updated;
      _stores = updated.keys.toList();

      if (!_stores.contains(_dropdownValue)) {
        _dropdownValue = _stores.isNotEmpty ? _stores.first : null;
      }
    });
  }

  void _handleCheck(int index) {
    final store = _dropdownValue!;
    final currentItems = _getItemsForStore(store);
    currentItems[index]['completed'] =
        !(currentItems[index]['completed'] ?? false);
    _updateStoreItems(store, currentItems);
  }

  void _handleEssential(int index) {
    final store = _dropdownValue!;
    final currentItems = _getItemsForStore(store);
    currentItems[index]['essential'] =
        !(currentItems[index]['essential'] ?? true);
    _updateStoreItems(store, currentItems);
  }

  void _handleDelete(int index) {
    final store = _dropdownValue!;
    final currentItems = _getItemsForStore(store);
    currentItems.removeAt(index);
    _updateStoreItems(store, currentItems);
  }

  void _onDropdownChange(String? newStore) {
    if (newStore == null) return;
    setState(() {
      _dropdownValue = newStore;
    });
  }

  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.initialStore ?? _dropdownValue;
    _fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    // THEME
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // VARIABLES
    final store = _dropdownValue ?? '';
    final storeItems = _getItemsForStore(store);

    // Main Sections - Items
    final essentialToBuy = <MapEntry<int, Map<String, dynamic>>>[];
    final nonEssentialToBuy = <MapEntry<int, Map<String, dynamic>>>[];
    final essentialBought = <MapEntry<int, Map<String, dynamic>>>[];
    final nonEssentialBought = <MapEntry<int, Map<String, dynamic>>>[];

    // Loop through items and sort the items into their respective categories
    for (final entry in storeItems.asMap().entries) {
      final item = entry.value;
      final isCompleted = item['completed'] ?? false;
      final isEssential = item['essential'] ?? false;

      if (!isCompleted && isEssential) {
        essentialToBuy.add(entry);
      } else if (!isCompleted && !isEssential) {
        nonEssentialToBuy.add(entry);
      } else if (isCompleted && isEssential) {
        essentialBought.add(entry);
      } else {
        nonEssentialBought.add(entry);
      }
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WelcomeHeader(
                      subtitle: "Store:",
                      title: store.isNotEmpty ? store : "Select a store",
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.secondary.withAlpha(75),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _dropdownValue,
                          onChanged: _onDropdownChange,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(12),
                          dropdownColor: colorScheme.surface,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                          items: _stores.map((store) {
                            return DropdownMenuItem<String>(
                              value: store,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  store,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              // Main content
              Expanded(
                flex: 8,
                child: storeItems.isEmpty
                    ? Center(
                        child: Text(
                          "No items for this store.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : ListView(
                        children: [
                          _buildCategory(
                            "Essential (Not Bought)",
                            essentialToBuy,
                          ),
                          _buildCategory(
                            "Non-Essential (Not Bought)",
                            nonEssentialToBuy,
                          ),
                          _buildCategory("Essential (Bought)", essentialBought),
                          _buildCategory(
                            "Non-Essential (Bought)",
                            nonEssentialBought,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
