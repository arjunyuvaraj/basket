import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  final String subtitle;
  final String title;
  const WelcomeHeader({super.key, required this.subtitle, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: TextTheme.of(context).headlineSmall?.copyWith(
            color: ColorScheme.of(context).onSurface.withAlpha(100),
          ),
        ),
        Text(
          title,
          style: TextTheme.of(context).headlineLarge?.copyWith(),
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
