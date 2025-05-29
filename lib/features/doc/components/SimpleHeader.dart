import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SimpleHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title.tr, style: Theme.of(context).textTheme.titleLarge),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}