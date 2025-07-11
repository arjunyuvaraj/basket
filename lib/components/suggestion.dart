import 'package:flutter/material.dart';

class Suggestion extends StatelessWidget {
  final List suggestions;
  final Function() onTap;

  const Suggestion({super.key, required this.suggestions, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            dense: true,
            title: Text(suggestion['name']),
            subtitle: Text(suggestion['store']),
            onTap: onTap,
          );
        },
      ),
    );
  }
}
