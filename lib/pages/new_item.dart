import 'dart:async';

import 'package:basket/components/app_button_primary.dart';
import 'package:basket/components/app_text_field.dart';
import 'package:basket/components/welcome_header.dart';
import 'package:basket/helper/help_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewItem extends StatefulWidget {
  final String? store;

  const NewItem({super.key, this.store});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  @override
  void initState() {
    super.initState();

    nameFocusNode.addListener(() {
      if (!nameFocusNode.hasFocus) {
        setState(() {
          _showSuggestions = false;
        });
      }
    });
    quantityFocusNode.addListener(() {
      if (!nameFocusNode.hasFocus) {
        setState(() {
          _showSuggestions = false;
        });
      }
    });

    nameController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 00), _searchSuggestions);
    });
  }

  bool isEssential = false;
  final TextEditingController tagsController = TextEditingController();
  List<String> tags = [];

  List<Map<String, dynamic>> _suggestions = [];
  bool _showSuggestions = false;
  final _formKey = GlobalKey<FormState>();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final FocusNode nameFocusNode = FocusNode();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController storesController = TextEditingController();

  final FocusNode quantityFocusNode = FocusNode();

  List<String> getStores() {
    return storesController.text
        .split(',')
        .map((store) => store.trim())
        .where((store) => store.isNotEmpty)
        .toList();
  }

  Timer? _debounce;

  Future<void> _searchSuggestions() async {
    final nameInput = nameController.text.trim().toLowerCase();
    if (nameInput.isEmpty || quantityFocusNode.hasFocus) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser?.email)
        .get();
    final data = doc.data();
    if (data == null) return;

    final itemsMap = Map<String, dynamic>.from(data['items'] ?? {});
    final List<Map<String, dynamic>> found = [];

    for (final entry in itemsMap.entries) {
      final store = entry.key;
      final List<dynamic> storeItems = entry.value;
      for (final item in storeItems) {
        final itemName = (item['name'] ?? '').toString();
        if (itemName.toLowerCase().contains(nameInput)) {
          found.add({
            'name': itemName,
            'quantity': item['quantity'],
            'store': store,
            'essential': item['essential'] ?? false,
            'tags': item['tags'] ?? [],
          });
        }
      }
    }

    setState(() {
      _suggestions = found;
      _showSuggestions = found.isNotEmpty;
    });
  }

  void handleSubmit(BuildContext context) async {
    final userDocRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser?.email);

    final newItem = {
      'name': nameController.text.trim(),
      'quantity': int.tryParse(quantityController.text.trim()) ?? 1,
      'essential': isEssential,
      'tags': tags,
      'completed': false,
    };

    final userSnapshot = await userDocRef.get();
    final existingData = userSnapshot.data();
    final Map<String, dynamic> existingItems = Map<String, dynamic>.from(
      existingData?['items'] ?? {},
    );

    // Go through all selected stores and add the item
    for (final store in getStores()) {
      final List<dynamic> storeList = List.from(existingItems[store] ?? []);

      // Remove duplicates with the same name (case-insensitive)
      storeList.removeWhere((item) {
        final existingName = (item['name'] ?? '').toString().toLowerCase();
        return existingName == newItem['name'].toString().toLowerCase();
      });

      storeList.add(newItem);
      existingItems[store] = storeList;
    }

    await userDocRef.update({'items': existingItems});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Item added successfully!")));
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // THEME
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeHeader(
                subtitle: "Got something to add?",
                title: "Update Your Basket",
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: nameController,
                            focusNode: nameFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Item Name',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  width: 1.5,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),

                          if (_showSuggestions)
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                border: Border.all(color: colorScheme.tertiary),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _suggestions.length,
                                itemBuilder: (context, index) {
                                  print(_showSuggestions);
                                  final suggestion = _suggestions[index];
                                  return ListTile(
                                    dense: true,
                                    title: Text(
                                      "${suggestion['name']} - ${suggestion['quantity']}",
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                    subtitle: Text(
                                      suggestion['store'],
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.primary,
                                      ),
                                    ),

                                    onTap: () {
                                      setState(() {
                                        nameController.text =
                                            suggestion['name'];
                                        quantityController.text =
                                            suggestion['quantity'].toString();
                                        storesController.text =
                                            suggestion['store'];

                                        // Safely assign essential (default to false if missing)
                                        isEssential =
                                            suggestion['essential'] ?? false;

                                        // Safely assign tags if it's a list
                                        if (suggestion['tags'] is List) {
                                          tags = List<String>.from(
                                            suggestion['tags'],
                                          );
                                          tagsController.text = tags.join(', ');
                                        } else {
                                          tags = [];
                                          tagsController.clear();
                                        }

                                        _suggestions = [];
                                        quantityFocusNode.requestFocus();
                                        _showSuggestions = false;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      TextFormField(
                        controller: quantityController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}'),
                          ),
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        focusNode: quantityFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                        ),
                        validator: (value) {
                          final num = double.tryParse(value ?? '');
                          return (num == null || num < 0)
                              ? 'Enter valid quantity'
                              : null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: tagsController,
                        decoration: const InputDecoration(
                          labelText: 'Tags (comma-separated)',
                        ),
                        onChanged: (value) {
                          final tagList = value
                              .split(',')
                              .map((tag) => tag.trim())
                              .where((tag) => tag.isNotEmpty)
                              .toSet()
                              .toList();
                          setState(() {
                            tags = tagList;
                          });
                        },
                      ),
                      if (tags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Wrap(
                            spacing: 8,
                            children: tags
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withAlpha(50),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tag,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                      const SizedBox(height: 12),
                      AppTextField(
                        hintText: "Store",
                        controller: storesController,
                        obscureText: false,
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text("Mark as Essential"),
                        value: isEssential,
                        onChanged: (value) {
                          setState(() {
                            isEssential = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      AppButtonPrimary(
                        text: "Add Item",
                        onPressed: () => rewriteUserItems(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
