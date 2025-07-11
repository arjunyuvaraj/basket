import 'package:basket/components/mini_button.dart';
import 'package:flutter/material.dart';

class FoodTile extends StatelessWidget {
  final String itemName;
  final String itemQuantity;
  final bool completed;
  final String label;
  final String labelSecond;
  final Function() onTap;
  final Function() onTapSecond;

  const FoodTile({
    super.key,
    required this.itemName,
    required this.itemQuantity,
    required this.completed,
    required this.label,
    required this.onTap,
    required this.labelSecond,
    required this.onTapSecond,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.secondary.withAlpha(75)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Expanded content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  itemName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.shopping_cart_rounded,
                      size: 18,
                      color: color.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Quantity: $itemQuantity',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: color.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action button
          Column(
            children: [
              MiniActionButton(
                label: label,
                onPressed: onTap,
                color: Theme.of(context).colorScheme.primary,
              ),
              if (completed)
                Column(
                  children: [
                    const SizedBox(height: 6),
                    MiniActionButton(
                      label: labelSecond,
                      onPressed: onTapSecond,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
