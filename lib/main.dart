import 'dart:async';

import 'package:characrea/provider/AttendProvider.dart';
import 'package:characrea/provider/CharacterListProvider.dart';
import 'package:characrea/provider/counter_provider.dart';
import 'package:characrea/provider/messageProvider.dart';
import 'package:characrea/provider/shopping_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'effects/distortion.dart';
import 'pages/homepage.dart';
import 'provider/homeProvider.dart';

final backgroundImageUrl = 'https://images.unsplash.com/photo-1613987549117-13c4781b32d3'
    '?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1024';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final image = NetworkImage(backgroundImageUrl);
  // final texture = Completer<ui.Image>();
  // image.load(image, PaintingBinding.instance!.instantiateImageCodec)
  //   ..addListener(ImageStreamListener(
  //     (ImageInfo info, _) => texture.complete(info.image),
  //     onError: texture.completeError,
  //   ));
  // runApp(ExampleApp(texture: await texture.future));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApplicationState()),
        ChangeNotifierProvider(create: (_) => AttendProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => ShoppingCart()),
        ChangeNotifierProvider(create: (_) => CharacterListProvider()),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Meetup',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.greenAccent,
            ),
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
