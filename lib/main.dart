import 'package:characrea/provider/AttendProvider.dart';
import 'package:characrea/provider/messageProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'pages/homepage.dart';
import 'provider/homeProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApplicationState()),
        ChangeNotifierProvider(create: (_) => AttendProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
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
              highlightColor: Colors.deepPurple,
            ),
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
