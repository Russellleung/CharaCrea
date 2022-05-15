import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/shopping_cart_provider.dart';
import 'home_screen.dart';

class CharacterFullScreenPage extends StatelessWidget {
  const CharacterFullScreenPage({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(message),
          Text('$title'),
        ],
      ),
    );
  }
}
