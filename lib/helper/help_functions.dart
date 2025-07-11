import 'package:flutter/material.dart';

void displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(title: Text(message)),
  );
}

int getItemsPerStore(String storeName, List groceryItems) {
  return groceryItems
      .where((item) {
        return (item['stores'] as List<String>).contains(storeName);
      })
      .toList()
      .length;
}
