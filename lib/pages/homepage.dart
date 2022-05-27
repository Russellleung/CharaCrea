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
    return Scaffold(
        appBar: AppBar(
          title: const Text('CharaCrea'),
        ),
        body: const Authentication());
  }
}
