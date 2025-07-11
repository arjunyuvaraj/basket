import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShopTile extends StatelessWidget {
  final String itemName;
  final int itemQuantity;
  final Function() onTap;
  const ShopTile({
    super.key,
    required this.itemName,
    required this.itemQuantity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.secondary.withAlpha(75)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Left: Item Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itemName,
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Items: $itemQuantity",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
