import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../effects/ripple/ripple_widget.dart';
import '../provider/CharacterListProvider.dart';
import '../provider/shopping_cart_provider.dart';
import 'home_screen.dart';

// class CharacterFullScreenPage extends StatelessWidget {
//   const CharacterFullScreenPage({required this.title, required this.message});
//
//   final String title;
//   final String message;
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         children: [
//           Text(message),
//           Text('$title'),
//         ],
//       ),
//     );
//   }
// }

class CharacterFullScreenPage extends StatefulWidget {
  final Character character;

  CharacterFullScreenPage({required this.character});

  @override
  _CharacterFullScreenPage createState() => _CharacterFullScreenPage();
}

class _CharacterFullScreenPage extends State<CharacterFullScreenPage> {
  Widget DisplayBlankImage() {
    return Image.asset(
      'assets/egg-eye.png',
      width: 70,
      height: 70,
    );
  }

  Widget DisplayImage(String bigImageUrl) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenWidth,
            maxHeight: screenWidth * (4 / 3),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Image.network(bigImageUrl),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "hiwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwhiwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwhiwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwhiwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding: EdgeInsets.all(10),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Flexible(
                  //         child: Text(
                  //           "hiwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwhiwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwhiwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwhiwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
                  //           style: TextStyle(color: Colors.deepOrange),
                  //         ),
                  //       ),
                  //       Text(
                  //         "hi",
                  //         style: TextStyle(color: Colors.deepOrange),
                  //       ),
                  //       Text(
                  //         "hi",
                  //         style: TextStyle(color: Colors.deepOrange),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "hi",
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                        Text(
                          "hi",
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                        Text(
                          "hi",
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Wrap(
              //   direction: Axis.vertical,
              //   children: [
              //     Text(
              //       "hi",
              //       style: TextStyle(color: Colors.deepOrange),
              //     ),
              //     Text(
              //       "hi",
              //       style: TextStyle(color: Colors.deepOrange),
              //     ),
              //     Text(
              //       "hi",
              //       style: TextStyle(color: Colors.deepOrange),
              //     ),
              //     Wrap(
              //       direction: Axis.horizontal,
              //       children: [
              //         Text(
              //           "hi",
              //           style: TextStyle(color: Colors.deepOrange),
              //         ),
              //         Text(
              //           "hi",
              //           style: TextStyle(color: Colors.deepOrange),
              //         ),
              //         Text(
              //           "hi",
              //           style: TextStyle(color: Colors.deepOrange),
              //         ),
              //       ],
              //     ),
              //     Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         Text(
              //           "hi",
              //           style: TextStyle(color: Colors.deepOrange),
              //         ),
              //         Text(
              //           "hi",
              //           style: TextStyle(color: Colors.deepOrange),
              //         ),
              //         SizedBox(width: 50),
              //         Text(
              //           "hi",
              //           style: TextStyle(color: Colors.deepOrange),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget TestDisplayImage() {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final screenHeight = MediaQuery.of(context).size.height;
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
  //     child: Card(
  //       elevation: 4.0,
  //       child: Padding(
  //         padding: EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
  //         child: ConstrainedBox(
  //           constraints: BoxConstraints(
  //             maxWidth: 0.8 * screenWidth,
  //             maxHeight: 0.7 * screenHeight,
  //           ),
  //           child: Image.asset('assets/codelab.png'),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RippleEffect(
        pulsations: 2,
        dampening: 0.98,
        child: FutureBuilder(
            future: Future.wait([readImageFromDatabase(widget.character.displayPhoto)]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                return DisplayImage(snapshot.data![0]);
              }
              return DisplayBlankImage();
            }),
      ),
    );
  }
}
