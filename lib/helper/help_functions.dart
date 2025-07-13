import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

Future<void> rewriteUserItems() async {
  final userEmail = "arjyuvaraj@gmail.com";
  final userDocRef = FirebaseFirestore.instance
      .collection('Users')
      .doc(userEmail);

  // Sample new items data you want to write
  final newItems = {
    "Whole Foods": [
      {
        "name": "Almond Milk",
        "quantity": 1,
        "completed": false,
        "essential": true,
        "tags": ["dairy-free", "organic", "beverage"],
      },
      {
        "name": "Quinoa",
        "quantity": 2,
        "completed": false,
        "essential": true,
        "tags": ["grain", "gluten-free", "healthy"],
      },
      {
        "name": "Dark Chocolate",
        "quantity": 3,
        "completed": true,
        "essential": false,
        "tags": ["snack", "sweet"],
      },
      {
        "name": "Avocados",
        "quantity": 4,
        "completed": false,
        "essential": true,
        "tags": ["fruit", "healthy", "fresh"],
      },
    ],
    "Trader Joe's": [
      {
        "name": "Organic Eggs",
        "quantity": 12,
        "completed": false,
        "essential": true,
        "tags": ["protein", "organic"],
      },
      {
        "name": "Peanut Butter",
        "quantity": 1,
        "completed": false,
        "essential": false,
        "tags": ["spread", "snack"],
      },
      {
        "name": "Frozen Berries",
        "quantity": 2,
        "completed": true,
        "essential": false,
        "tags": ["fruit", "frozen"],
      },
    ],
    "Costco": [
      {
        "name": "Paper Towels",
        "quantity": 6,
        "completed": false,
        "essential": true,
        "tags": ["household"],
      },
      {
        "name": "Olive Oil",
        "quantity": 1,
        "completed": false,
        "essential": true,
        "tags": ["cooking", "healthy"],
      },
      {
        "name": "Chicken Breasts",
        "quantity": 10,
        "completed": true,
        "essential": true,
        "tags": ["protein", "meat", "fresh"],
      },
    ],
    "Local Farmers Market": [
      {
        "name": "Tomatoes",
        "quantity": 5,
        "completed": false,
        "essential": true,
        "tags": ["vegetable", "fresh", "organic"],
      },
      {
        "name": "Honey",
        "quantity": 1,
        "completed": false,
        "essential": false,
        "tags": ["sweetener", "natural"],
      },
    ],
    "Safeway": [
      {
        "name": "Whole Wheat Bread",
        "quantity": 2,
        "completed": false,
        "essential": true,
        "tags": ["bakery", "healthy"],
      },
      {
        "name": "Cheddar Cheese",
        "quantity": 1,
        "completed": true,
        "essential": false,
        "tags": ["dairy"],
      },
      {
        "name": "Carrots",
        "quantity": 3,
        "completed": false,
        "essential": true,
        "tags": ["vegetable", "fresh"],
      },
    ],
  };

  await userDocRef.update({
    "email": "arjyuvaraj@gmail.com",
    "username": "arjunyuvaraj",
    "first_name": "Arjun",
    "last_name": "Yuvaraj",
    "theme": "dark",
    "items": newItems,
  });
}
