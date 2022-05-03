import 'package:characrea/pages/CharacterCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/CharacterListProvider.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({Key? key}) : super(key: key);

  @override
  _CharacterListPage createState() => _CharacterListPage();
}

class _CharacterListPage extends State<CharacterListPage> {
  TextEditingController _searchController = TextEditingController();

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
      for (var character in context.watch<CharacterListProvider>().allCharacters) {
        var title = character.name.toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          context.watch<CharacterListProvider>().addFilteredCharacter(character);
        }
      }
    } else {
      context.watch<CharacterListProvider>().filteredCharacters = context.watch<CharacterListProvider>().allCharacters;
    }
  }

  Widget build(BuildContext context) {
    //context.watch<CharacterListProvider>().setCharacterProvider();
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
            itemBuilder: (BuildContext context, int index) =>
                CharacterCard(context, context.watch<CharacterListProvider>().filteredCharacters[index]),
          )),
        ],
      ),
    );
  }
}
