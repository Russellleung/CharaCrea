import 'package:characrea/provider/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/shopping_cart_provider.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider Example App (${context.watch<Counter>().count})'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('${context.watch<ShoppingCart>().count}'),
            Text('${context.watch<ShoppingCart>().cart}'),
            Text(message),
            Text('$title'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: Key('addItem_floatingActionButton'),
        onPressed: () => context.read<ShoppingCart>().addItem('Bread'),
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
