import 'package:basket/pages/account_page.dart';
import 'package:basket/pages/list_page.dart';
import 'package:basket/pages/new_item.dart';
import 'package:basket/pages/store_page.dart';
import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {
  final int initialIndex;
  final String? initialStore;

  const NavigationPage({super.key, this.initialIndex = 0, this.initialStore});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late int _selectedIndex;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    pages = [
      StorePage(
        onEnterStore: (storeName) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  NavigationPage(initialIndex: 1, initialStore: storeName),
            ),
          );
        },
      ),
      ListPage(initialStore: widget.initialStore),
      NewItem(),
      AccountPage(),
    ];
  }

  void _changeIndex(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      onPressed: () => _changeIndex(index),
      icon: Icon(
        icon,
        size: 28,
        color: isSelected
            ? ColorScheme.of(context).primary
            : Colors.grey.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavIcon(Icons.store_rounded, 0),
              _buildNavIcon(Icons.list_rounded, 1),
              _buildNavIcon(Icons.playlist_add_rounded, 2),
              _buildNavIcon(Icons.account_circle_rounded, 3),
            ],
          ),
        ),
      ),
    );
  }
}
