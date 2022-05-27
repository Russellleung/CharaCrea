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
          title: const Text('CharaCrea'),
        ),
        body: ListView(children: <Widget>[
          const Authentication(),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          if (loginState == ApplicationLoginState.loggedIn) ...[
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
