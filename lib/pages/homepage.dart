import 'package:characrea/pages/rootPage.dart';
import 'package:characrea/provider/AttendProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/homeProvider.dart';
import '../src/authentication.dart';
import '../widgets/guestbookwidget.dart';
import '../widgets/widgets.dart';
import '../widgets/yesnowidget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApplicationState applicationVariableState = context.watch<ApplicationState>();
    AttendProvider attendProvider = context.watch<AttendProvider>();

    int attendees = attendProvider.attendees;
    ApplicationLoginState loginState = applicationVariableState.loginState;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Meetup'),
        ),
        body: ListView(children: <Widget>[
          Image.asset('assets/codelab.png'),
          const SizedBox(height: 8),
          const IconAndDetail(Icons.calendar_today, 'October 30'),
          const IconAndDetail(Icons.location_city, 'San Francisco'),
          const Authentication(),
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
          if (attendees >= 2)
            Paragraph('$attendees people going')
          else if (attendees == 1)
            const Paragraph('1 person going')
          else
            const Paragraph('No one going'),
          if (loginState == ApplicationLoginState.loggedIn) ...[
            const YesNoSelection(),
            const Header('Discussion'),
            GuestBook(),
            FloatingActionButton(onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) {
                  return RootPage();
                }),
              );
            })
          ]
        ]));
  }
}
