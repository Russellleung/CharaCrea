import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/shopping_cart_provider.dart';
import 'home_screen.dart';

class CharacterEditPage extends StatelessWidget {
  const CharacterEditPage({required this.title, required this.message});

  final String title;
  final String message;

  // will have to be stateful. save character locally so other places can't change
  // should have 2 character states. 1 original and another will be changed so can go back

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(
          title: Text("hello"),
        ),
        onTap: () {
          print("hi");
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
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
        onPressed: () {
          context.read<ShoppingCart>().addItem('Bread');
          // Navigator.pop(context);
        },
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
