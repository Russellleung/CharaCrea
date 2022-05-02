import 'package:characrea/pages/third_screen.dart';
import 'package:characrea/provider/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultPage(),
    );
  }
}

class DefaultPage extends StatefulWidget {
  @override
  _DefaultPageState createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> with AutomaticKeepAliveClientMixin<DefaultPage> {
  bool keepAlive = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(
          title: Text("hello"),
        ),
        onTap: () {
          print("hi");
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),

      // AppBar(
      //   title: Text('Provider Example App (${context.watch<Counter>().count})'),
      // ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times: ${context.watch<Counter>().count}'),
            Count(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) {
                    return ThirdScreen(
                      message: '',
                      title: '',
                    );
                  }),
                );
              },
              child: Text('Launch screen without nav bar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(builder: (context) {
                    return ThirdScreen(
                      message: '',
                      title: '',
                    );
                  }),
                );
              },
              child: Text('Launch screen with nav bar'),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            key: Key('decrement_floatingActionButton'),
            onPressed: () => context.read<Counter>().decrement(),
            tooltip: 'Decrement',
            child: Icon(Icons.remove),
          ),
          SizedBox(
            width: 10.0,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            key: Key('reset_floatingActionButton'),
            onPressed: () => context.read<Counter>().reset(),
            tooltip: 'Reset',
            child: Icon(Icons.exposure_zero),
          ),
          SizedBox(
            width: 10.0,
          ),
          FloatingActionButton(
            heroTag: "btn3",
            key: Key('increment_floatingActionButton'),
            onPressed: () => context.read<Counter>().increment(),
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => keepAlive;
}

class Count extends StatelessWidget {
  Count({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('${context.watch<Counter>().count}', key: Key('counterState'), style: Theme.of(context).textTheme.headline4);
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final AppBar appBar;

  const CustomAppBar({required this.onTap, required this.appBar});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onLongPress: onTap, child: appBar);
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
