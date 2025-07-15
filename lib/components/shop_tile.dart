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

    return Material(
      color: colorScheme.surface,
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: colorScheme.primary.withAlpha(25), // ripple
        highlightColor: Colors.transparent, // press background
        hoverColor: colorScheme.primary.withAlpha(25),

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.secondary.withAlpha(75)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Middle: Item Info
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
              Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
