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
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.topRight,
                  child: Text(
                    widget.character.catchphrase,
                    style: TextStyle(color: Colors.deepOrange),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.character.motto != "") ...[
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            widget.character.motto,
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),
                      )
                    ],
                    if (widget.character.description != "") ...[
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            widget.character.description,
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ),
                      )
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.character.name,
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              widget.character.groupImage(),
                              scale: 20,
                            ),
                            Image.asset(
                              widget.character.genderImage(),
                              scale: 20,
                            ),
                            Image.asset(
                              widget.character.powerOriginImage(),
                              scale: 20,
                            ),
                            Image.asset(
                              widget.character.typeImage(),
                              scale: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
