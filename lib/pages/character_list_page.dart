import 'package:characrea/pages/CharacterCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import '../Themes.dart';
import '../provider/CharacterListProvider.dart';
import '../widgets/Formbuilder.dart';
import 'package:intl/intl.dart';

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
  List genders = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    context.read<CharacterListProvider>().setCharacterProvider(() {
      selectedResultsList();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    context.read<CharacterListProvider>().characterListSubscription?.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    if (_searchController.text != "") {
      context.read<CharacterListProvider>().filteredCharacters = [];
      for (var character in context.read<CharacterListProvider>().selectedCharacters) {
        var title = character.name.toLowerCase();
        if (title.contains(_searchController.text.toLowerCase())) {
          context.read<CharacterListProvider>().addFilteredCharacter(character);
        }
      }
    } else {
      context.read<CharacterListProvider>().filteredCharacters = context.read<CharacterListProvider>().selectedCharacters;
    }
  }

  selectedResultsList() {
    context.read<CharacterListProvider>().selectedCharacters = [];
    for (var character in context.read<CharacterListProvider>().allCharacters) {
      if (genders.contains(character.gender) || genders.isEmpty == true) {
        context.read<CharacterListProvider>().addSelectedCharacter(character);
      }
    }
    searchResultsList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: AppThemes.pageColor,
            resizeToAvoidBottomInset: false,
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(AppThemes.buttonColor)),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _displayDialog(context, genders, (List genderList) {
                      setState(() {
                        genders = genderList;
                      });
                    }, () {
                      selectedResultsList();
                    });
                  },
                  child: Text("Sieve"),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  backgroundColor: AppThemes.buttonColor,
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.of(context, rootNavigator: false).push(
                      MaterialPageRoute(builder: (context) {
                        return Scaffold(
                          resizeToAvoidBottomInset: false,
                          appBar: AppBar(
                            title: const Text('Form'),
                          ),
                          body: Formbuilder(
                            originalCharacter: Character(),
                            callback: (Character character) {},
                          ),
                        );
                      }),
                    );
                  },
                  tooltip: 'Add Item',
                  child: Icon(Icons.add),
                )
              ],
            ),
            appBar: AppBar(
              title: Text("search characters"),
              backgroundColor: AppThemes.appbarColor,
            ),
            body: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: AppThemes.buttonColor,
                          controller: _searchController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppThemes.buttonColor,
                            ),
                            // enabledBorder: UnderlineInputBorder(
                            //   borderSide: BorderSide(color: AppThemes.buttonColor),
                            // ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: AppThemes.buttonColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        context.watch<CharacterListProvider>().filteredCharacters.length.toString(),
                        textScaleFactor: 2,
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppThemes.buttonColor),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: context.watch<CharacterListProvider>().filteredCharacters.length,
                    itemBuilder: (BuildContext context, int index) =>
                        CharacterCard(context, context.read<CharacterListProvider>().filteredCharacters[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          print("hi");
          return false;
        });

    Container(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("search characters"),
          ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(context.watch<CharacterListProvider>().filteredCharacters.length.toString()),
              ElevatedButton(
                onPressed: () {
                  _displayDialog(context, genders, (List genderList) {
                    setState(() {
                      genders = genderList;
                    });
                  }, () {
                    selectedResultsList();
                  });
                },
                child: Text("Sieve"),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(builder: (context) {
                      return Scaffold(
                        resizeToAvoidBottomInset: false,
                        appBar: AppBar(
                          title: const Text('Form'),
                        ),
                        body: Formbuilder(
                          originalCharacter: Character(),
                          callback: (Character character) {},
                        ),
                      );
                    }),
                  );
                },
                tooltip: 'Add Item',
                child: Icon(Icons.add),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => keepAlive;
}

_displayDialog(
  BuildContext context,
  List genders,
  Function setGender,
  Function setSelectedCharacters,
) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Welcome'),
        content: selectionView(
          genders: genders,
          setGender: setGender,
          setSelectedCharacters: setSelectedCharacters,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'YES',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'NO',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

class selectionView extends StatefulWidget {
  List genders;
  Function setGender;
  Function setSelectedCharacters;

  selectionView({Key? key, required this.genders, required this.setGender, required this.setSelectedCharacters}) : super(key: key);

  @override
  _selectionView createState() => _selectionView();
}

class _selectionView extends State<selectionView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[
              FilterChip("gender", Character.genderOptions, widget.genders),
              FormBuilderFilterChip(
                name: 'filter_chip',
                decoration: InputDecoration(
                  labelText: 'Select many options',
                ),
                options: [
                  FormBuilderFieldOption(value: 'Test', child: Text('Test')),
                  FormBuilderFieldOption(value: 'Test 1', child: Text('Test 1')),
                  FormBuilderFieldOption(value: 'Test 2', child: Text('Test 2')),
                  FormBuilderFieldOption(value: 'Test 3', child: Text('Test 3')),
                  FormBuilderFieldOption(value: 'Test 4', child: Text('Test 4')),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                color: Theme.of(context).colorScheme.secondary,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _formKey.currentState?.save();
                  if (_formKey.currentState!.validate()) {
                    print(_formKey.currentState?.value);
                    widget.setGender(_formKey.currentState?.value['gender']);
                    widget.setSelectedCharacters();
                  } else {
                    print("validation failed");
                  }
                },
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: MaterialButton(
                color: Theme.of(context).colorScheme.secondary,
                child: Text(
                  "Reset",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  //_formKey.currentState?.reset();
                  _formKey.currentState?.patchValue({
                    'gender': [],
                  });
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

class FilterChip extends StatelessWidget {
  const FilterChip(this.name, this.options, this.initialValues);

  final String name;
  final List initialValues;
  final List options;

  @override
  Widget build(BuildContext context) => FormBuilderFilterChip(
        spacing: 5,
        initialValue: initialValues,
        name: name,
        decoration: InputDecoration(
          labelText: name,
        ),
        options: options
            .asMap()
            .entries
            .map(
              (item) => FormBuilderFieldOption(value: item.key, child: Text(item.value)),
            )
            .toList(),
      );
}
