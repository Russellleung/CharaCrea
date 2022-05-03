import 'package:characrea/pages/CharacterCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/CharacterListProvider.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CharacterListPage(),
    );
  }
}

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({Key? key}) : super(key: key);

  @override
  _CharacterListPage createState() => _CharacterListPage();
}

class _CharacterListPage extends State<CharacterListPage> with AutomaticKeepAliveClientMixin<CharacterListPage> {
  TextEditingController _searchController = TextEditingController();
  bool keepAlive = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    if (_searchController.text != "") {
      context.read<CharacterListProvider>().filteredCharacters = [];
      for (var character in context.read<CharacterListProvider>().allCharacters) {
        var title = character.name.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          context.read<CharacterListProvider>().addFilteredCharacter(character);
        }
      }
    } else {
      context.read<CharacterListProvider>().filteredCharacters = context.read<CharacterListProvider>().allCharacters;
    }
  }

  Widget build(BuildContext context) {
    super.build(context);
    // context.watch<CharacterListProvider>().setCharacterProvider();
    _onSearchChanged();
    return Container(
      child: Column(
        children: <Widget>[
          Text("Past Trips", style: TextStyle(fontSize: 20)),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: context.watch<CharacterListProvider>().filteredCharacters.length,
            itemBuilder: (BuildContext context, int index) => CharacterCard(context, context.read<CharacterListProvider>().filteredCharacters[index]),
          )),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => keepAlive;
}
