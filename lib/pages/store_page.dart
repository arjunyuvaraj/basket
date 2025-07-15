// IMPORTS
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
  // VARIABLES
  late Future<List<String>> _storeNamesFuture;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  Map<String, List<dynamic>> itemsMap = {};
  Future<String>? _firstNameFuture;

  // HELPER METHODS
  Future<List<String>> _getUserStores() async {
    // load doc and get the data
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

  Future<String> _getFirstName() async {
    final doc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser?.email)
        .get();

    final data = doc.data();
    return data?['first_name'] ?? "";
  }

  void handleNewStore(BuildContext use_build_context_synchronously) async {
    // Variables
    final TextEditingController newStoreController = TextEditingController();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    // Show alert with input for new store
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("New Store"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "To add a new store, type in the name of the store below and click \"Add\"",
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newStoreController,
              decoration: const InputDecoration(
                labelText: "New Store",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final input = newStoreController.text.trim();
              if (input.isNotEmpty) {
                navigator.pop(true);
              } else {
                messenger.showSnackBar(
                  const SnackBar(content: Text("Something went wrong...")),
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        messenger.showSnackBar(const SnackBar(content: Text("No user found.")));
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(currentUser?.email)
          .get();

      final data = doc.data();

      data?['items'].addEntries({newStoreController.text: []});
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _firstNameFuture = _getFirstName();
    _storeNamesFuture = _getUserStores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => handleNewStore,
        child: Icon(Icons.add_rounded),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<String>(
                future: _firstNameFuture,
                builder: (context, snapshot) {
                  final name = snapshot.data ?? '';
                  return WelcomeHeader(
                    subtitle: "Welcome $name,",
                    title: "Your Basket Awaits",
                  );
                },
              ),

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
                        return Container(
                          margin: EdgeInsets.only(bottom: 12),
                          child: ShopTile(
                            itemName: storeName,
                            itemQuantity: items.length,
                            onTap: () => widget.onEnterStore(storeName),
                          ),
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
