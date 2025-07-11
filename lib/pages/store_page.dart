import 'package:basket/components/shop_tile.dart';
import 'package:basket/components/welcome_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StorePage extends StatefulWidget {
  final void Function(String storeName) onEnterStore;

  const StorePage({super.key, required this.onEnterStore});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late Future<List<String>> _storeNamesFuture;
  Map<String, List<dynamic>> itemsMap = {};
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<List<String>> _getUserStores() async {
    final doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get();

    final data = doc.data();
    if (data == null || data['items'] == null) return [];

    final rawMap = data['items'] as Map<String, dynamic>;

    // Convert values to lists
    itemsMap = {
      for (var entry in rawMap.entries) entry.key: List.from(entry.value ?? []),
    };

    return itemsMap.keys.toList();
  }

  @override
  void initState() {
    super.initState();
    _storeNamesFuture = _getUserStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeHeader(subtitle: "Welcome,", title: "Your Basket Awaits"),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<String>>(
                  future: _storeNamesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No stores found."));
                    }

                    final stores = snapshot.data!;

                    return ListView.builder(
                      itemCount: stores.length,
                      itemBuilder: (context, index) {
                        final storeName = stores[index];
                        final items = itemsMap[storeName] ?? [];
                        return ShopTile(
                          itemName: storeName,
                          itemQuantity: items.length,
                          onTap: () => widget.onEnterStore(storeName),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
