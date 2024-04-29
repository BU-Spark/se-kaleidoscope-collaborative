import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String AppBarText;
  const CustomAppBar({super.key, required this.AppBarText});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppBarText, style: const TextStyle(color: Colors.black)),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.white,
      elevation: 0, // Removes the shadow under the app bar
    );
  }
}