import 'package:basket/components/app_text_field.dart';
import 'package:basket/components/food_tile.dart';
import 'package:basket/components/welcome_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchQuery = TextEditingController();
  List<Map<String, dynamic>> _allItems = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> getFilteredItems() {
    final query = _searchQuery.text.toLowerCase();

    return _allItems.where((item) {
      final name = item['name']?.toString().toLowerCase() ?? '';
      return name.contains(query);
    }).toList();
  }

  Future<void> _fetchAllItems() async {
    final doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get();

    final data = doc.data();
    if (data == null) return;

    final itemsMap = Map<String, dynamic>.from(data['items'] ?? {});
    List<Map<String, dynamic>> allItems = [];

    itemsMap.forEach((store, items) {
      if (store != "order") {
        final itemList = List<Map<String, dynamic>>.from(items);
        for (var item in itemList) {
          item['store'] = store;
          allItems.add(item);
        }
      }
    });

    setState(() {
      _allItems = allItems;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _fetchAllItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // THEME
    List<Map<String, dynamic>> filteredItems = getFilteredItems();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              WelcomeHeader(
                subtitle: "Looking for Something?",
                title: "Search Your Basket",
              ),
              // Search Bar
              const SizedBox(height: 6),
              AppTextField(
                hintText: "Search for any item",
                controller: _searchQuery,
                obscureText: false,
                onChange: (context) {
                  setState(() {});
                },
              ),
              if (!_isLoading)
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final suggestion = filteredItems[index];
                      return Container(
                        margin: EdgeInsets.only(top: 12),
                        child: FoodTile(
                          itemName: suggestion['name'],
                          itemQuantity: suggestion['quantity'].toString(),
                          completed: suggestion['completed'],
                          store: suggestion['store'],
                          essential: suggestion['essential'] ?? false,
                          label: "DONE",
                          onTap: () {},
                          labelSecond: "DELETE",
                          onTapSecond: () {},
                          onTapThird: () {},
                        ),
                      );
                    },
                  ),
                ),
              if (filteredItems.isEmpty) Text("No items found."),
            ],
          ),
        ),
      ),
    );
  }
}
