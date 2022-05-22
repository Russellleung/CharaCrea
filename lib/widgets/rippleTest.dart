import '../effects/ripple/ripple_widget.dart';
import '../provider/CharacterListProvider.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RippleTest extends StatefulWidget {
  final Character character;

  RippleTest({required this.character});

  @override
  _RippleTest createState() => _RippleTest();
}

class _RippleTest extends State<RippleTest> {
  Widget DisplayImage(String bigImageUrl) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 0.8 * screenWidth,
              maxHeight: 0.7 * screenHeight,
            ),
            child: Image.network(bigImageUrl),
          ),
        ),
      ),
    );
  }

  Widget TestDisplayImage() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 0.8 * screenWidth,
              maxHeight: 0.7 * screenHeight,
            ),
            child: Image.asset('assets/codelab.png'),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RippleEffect(
        rippleController: RippleController(),
        pulsations: 2,
        dampening: 0.96,
        child: TestDisplayImage(),
      ),
    );
  }
}
