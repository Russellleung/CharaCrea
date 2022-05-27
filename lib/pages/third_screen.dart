import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../provider/CharacterListProvider.dart';
import '../provider/shopping_cart_provider.dart';
import '../widgets/Formbuilder.dart';
import 'home_screen.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

class CollapsingList extends StatefulWidget {
  CollapsingList({
    Key? key,
  }) : super(key: key);

  @override
  _CollapsingList createState() => _CollapsingList();
}

class _CollapsingList extends State<CollapsingList> {
  final _formKey = GlobalKey<FormBuilderState>();
  Character character = Character();

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 70.0,
        child: Container(color: Colors.lightBlue, child: Center(child: Text(headerText))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      FormBuilder(
        key: _formKey,
        child: CustomScrollView(
          slivers: <Widget>[
            makeHeader('Header Section 1'),
            SliverGrid.count(
              crossAxisCount: 3,
              children: [
                Container(color: Colors.red, height: 150.0),
                Container(color: Colors.purple, height: 150.0),
                Container(color: Colors.green, height: 150.0),
                Container(color: Colors.orange, height: 150.0),
                Container(color: Colors.yellow, height: 150.0),
                Container(color: Colors.pink, height: 150.0),
                Container(color: Colors.cyan, height: 150.0),
                Container(color: Colors.indigo, height: 150.0),
                Container(color: Colors.blue, height: 150.0),
              ],
            ),
            makeHeader('Header Section 2'),
            SliverFixedExtentList(
              itemExtent: 150.0,
              delegate: SliverChildListDelegate(
                [
                  CustomTextField('name', character.name),
                  Container(color: Colors.purple),
                  Container(color: Colors.green),
                  Container(color: Colors.orange),
                  Container(color: Colors.yellow),
                ],
              ),
            ),
            makeHeader('Header Section 3'),
            SliverGrid(
              gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 4.0,
              ),
              delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return new Container(
                    alignment: Alignment.center,
                    color: Colors.teal[100 * (index % 9)],
                    child: new Text('grid item $index'),
                  );
                },
                childCount: 20,
              ),
            ),
            makeHeader('Header Section 4'),
            // Yes, this could also be a SliverFixedExtentList. Writing
            // this way just for an example of SliverList construction.
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  CustomTextField('name', character.name),
                  Container(color: Colors.cyan, height: 150.0),
                  Container(color: Colors.indigo, height: 150.0),
                  Container(color: Colors.blue, height: 150.0),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
