import 'package:characrea/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../pages/rootPage.dart';
import '../provider/homeProvider.dart';
import '../widgets/authwidgets/emailFormWidget.dart';
import '../widgets/authwidgets/passwordFormwidget.dart';
import '../widgets/authwidgets/registerWidget.dart';
import '../widgets/widgets.dart';

enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  register,
  password,
  loggedIn,
}

class Authentication extends StatelessWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ApplicationState applicationVariableState = context.watch<ApplicationState>();
    ApplicationLoginState loginState = applicationVariableState.loginState;
    String? email = applicationVariableState.email;

    ApplicationState applicationFunctionState = context.read<ApplicationState>();

    switch (loginState) {
      case ApplicationLoginState.loggedOut:
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                onPressed: () {
                  applicationFunctionState.startLoginFlow();
                },
                child: const Text('Join'),
              ),
            ),
          ],
        );
      case ApplicationLoginState.emailAddress:
        return EmailForm(callback: (email) => applicationFunctionState.verifyEmail(email, (e) => _showErrorDialog(context, 'Invalid email', e)));
      case ApplicationLoginState.password:
        return PasswordForm(
          email: email!,
          login: (email, password) {
            applicationFunctionState
                .signInWithEmailAndPassword(email, password, (e) => _showErrorDialog(context, 'Failed to sign in', e))
                .then((value) {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) {
                  return RootPage();
                }),
              );
            });
          },
        );
      case ApplicationLoginState.register:
        return RegisterForm(
          email: email!,
          cancel: () {
            applicationFunctionState.cancelRegistration();
          },
          registerAccount: (
            email,
            displayName,
            password,
          ) {
            applicationFunctionState.registerAccount(email, displayName, password, (e) => _showErrorDialog(context, 'Failed to create account', e));
          },
        );
      case ApplicationLoginState.loggedIn:
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: StyledButton(
                onPressed: () {
                  applicationFunctionState.signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('LOGOUT'),
              ),
            ),
          ],
        );
      default:
        return Row(
          children: const [
            Text("Internal error, this shouldn't happen..."),
          ],
        );
    }
  }
}

void _showErrorDialog(BuildContext context, String title, Exception e) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(fontSize: 24),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                '${(e as dynamic).message}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          StyledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
        ],
      );
    },
  );
}
