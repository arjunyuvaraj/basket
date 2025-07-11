import 'package:basket/components/food_tile.dart';
import 'package:basket/components/welcome_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  final String? initialStore;
  const ListPage({super.key, this.initialStore});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Map<String, dynamic> _fullList = {};
  List<String> _stores = [];
  String? _dropdownValue;
  @override
  void initState() {
    super.initState();
    _dropdownValue = widget.initialStore ?? _dropdownValue;
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get();

    final data = doc.data();
    if (data == null) return;

    final itemsMap = Map<String, dynamic>.from(data['items'] ?? {});
    final storeKeys = itemsMap.keys.toList();

    setState(() {
      _fullList = itemsMap;
      _stores = storeKeys;
      _dropdownValue =
          widget.initialStore ?? (_stores.isNotEmpty ? _stores.first : null);
    });
  }

  List<Map<String, dynamic>> _getItemsForStore(String store) {
    final items = _fullList[store];
    if (items == null) return [];
    return List<Map<String, dynamic>>.from(items);
  }

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final store = _dropdownValue ?? '';
    final storeItems = _getItemsForStore(store);

    final toBuyItems = storeItems
        .asMap()
        .entries
        .where((entry) => !(entry.value['completed'] ?? false))
        .toList();

    final boughtItems = storeItems
        .asMap()
        .entries
        .where((entry) => entry.value['completed'] == true)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
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
                    : Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You still need to buy...",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: toBuyItems.isEmpty
                                      ? Center(child: Text("Nothing!"))
                                      : ListView(
                                          children: toBuyItems.map((entry) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 16,
                                              ),
                                              child: FoodTile(
                                                itemName: entry.value["name"],
                                                itemQuantity: entry
                                                    .value["quantity"]
                                                    .toString(),
                                                completed: false,
                                                onTap: () =>
                                                    _handleCheck(entry.key),
                                                label: "DONE",
                                                onTapSecond: () =>
                                                    _handleDelete(entry.key),
                                                labelSecond: "DROP",
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Divider(color: colorScheme.tertiary.withAlpha(50)),
                          const SizedBox(height: 6),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You've already bought...",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: boughtItems.isEmpty
                                      ? Center(child: Text("Nothing!"))
                                      : ListView(
                                          children: boughtItems.map((entry) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 16,
                                              ),
                                              child: FoodTile(
                                                itemName: entry.value["name"],
                                                itemQuantity: entry
                                                    .value["quantity"]
                                                    .toString(),
                                                completed: true,
                                                onTap: () =>
                                                    _handleCheck(entry.key),
                                                label: "UNDO",
                                                onTapSecond: () =>
                                                    _handleDelete(entry.key),
                                                labelSecond: "DROP",
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                ),
                              ],
                            ),
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
