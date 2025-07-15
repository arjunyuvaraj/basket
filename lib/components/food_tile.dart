import 'package:flutter/material.dart';

class FoodTile extends StatelessWidget {
  final String itemName;
  final String itemQuantity;
  final bool completed;
  final bool essential;
  final List<String> tags;
  final String label;
  final String labelSecond;
  final String store;
  final Function() onTap;
  final Function() onTapThird;
  final Function() onTapSecond;

  const FoodTile({
    super.key,
    required this.itemName,
    required this.itemQuantity,
    required this.completed,
    required this.essential,
    this.tags = const [],
    this.store = "",
    required this.label,
    required this.onTap,
    required this.labelSecond,
    required this.onTapThird,
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
                // Title with essential star
                Text(
                  itemName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color.primary,
                    fontSize: 18,
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
                if (store.isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.store_rounded, size: 18, color: color.primary),
                      const SizedBox(width: 6),
                      Text(
                        'Store: $store',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: color.primary,
                        ),
                      ),
                    ],
                  ),
                if (tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: color.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),

          // Action buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (essential)
                InkWell(
                  onTap: onTapThird,
                  child: Icon(Icons.star_rounded, color: Colors.amber),
                ),
              if (!essential)
                InkWell(
                  onTap: onTapThird,
                  child: Icon(
                    Icons.star_outline_rounded,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              const SizedBox(height: 4),
              if (label == "DONE")
                InkWell(
                  onTap: onTap,
                  child: Icon(
                    Icons.check_circle_outline_outlined,
                    color: Colors.green,
                  ),
                ),
              const SizedBox(height: 4),
              if (completed)
                InkWell(
                  onTap: onTapSecond,
                  child: Icon(
                    Icons.delete_forever_outlined,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              // MiniActionButton(
              //   label: label,
              //   onPressed: onTap,
              //   color: Theme.of(context).colorScheme.primary,
              // ),
              // if (completed)
              //   Column(
              //     children: [
              //       const SizedBox(height: 6),
              //       MiniActionButton(
              //         label: labelSecond,
              //         onPressed: onTapSecond,
              //         color: Theme.of(context).colorScheme.error,
              //       ),
              //     ],
              //   ),
            ],
          ),
        ],
      ),
    );
  }
}
