import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../provider/CharacterListProvider.dart';
import '../widgets/widgets.dart';

class CharacterDetailedPage extends StatefulWidget {
  final Character character;

  CharacterDetailedPage({required this.character});

  @override
  _CharacterDetailedPage createState() => _CharacterDetailedPage();
}

class _CharacterDetailedPage extends State<CharacterDetailedPage> {
  BottomDrawerController bottomDrawerController = BottomDrawerController();

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Meetup'),
      ),
      body: SlidingUpPanel(
          backdropEnabled: true,
          panel: Center(
            child: Text("This is the sliding Widget"),
          ),
          collapsed: Container(
            decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: radius),
            child: Center(
              child: Text(
                "This is the collapsed Widget",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          borderRadius: radius,
          body: GestureDetector(
            // onHorizontalDragEnd: (DragEndDetails details) {
            //   int sensitivity = 8;
            //   if (details.primaryVelocity! > sensitivity) {
            //     // full screen
            //     Navigator.of(context, rootNavigator: true).push(
            //       MaterialPageRoute(builder: (context) {
            //         return ThirdScreen(
            //           message: '',
            //           title: '',
            //         );
            //       }),
            //     );
            //   } else if (details.primaryVelocity! < -sensitivity) {
            //     // edit screen
            //     Navigator.of(context, rootNavigator: false).push(
            //       MaterialPageRoute(builder: (context) {
            //         return ThirdScreen(
            //           message: '',
            //           title: '',
            //         );
            //       }),
            //     );
            //   }
            // },
              child: ListView(children: <Widget>[
                Image.asset('assets/codelab.png'),
                const SizedBox(height: 8),
                IconAndDetail(Icons.abc_rounded, widget.character.name),
                IconAndDetail(Icons.dangerous, widget.character.power),
                const Divider(
                  height: 8,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8,
                  color: Colors.grey,
                ),
                const Header("What we'll be doing"),
                const Paragraph(
                  'Join us for a day full of Firebase Workshops and Pizza!',
                ),
              ]))),
    );
  }
}

// Widget buildBottomDrawer(BuildContext context) {
//   var controller;
//   return GestureDetector(
//       child: BottomDrawer(
//     /// your customized drawer header.
//     header: Container(),
//
//     /// your customized drawer body.
//     body: Container(),
//
//     /// your customized drawer header height.
//     headerHeight: 60.0,
//
//     /// your customized drawer body height.
//     drawerHeight: 180.0,
//
//     /// drawer background color.
//     color: Colors.lightBlue,
//
//     /// drawer controller.
//     controller: controller,
//   ));
// }
//
// /// open the bottom drawer.
// controller.open();
//
// /// close the bottom drawer.
// controller.close();
