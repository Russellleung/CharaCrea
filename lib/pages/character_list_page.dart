import 'package:characrea/pages/CharacterCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import '../Themes.dart';
import '../provider/CharacterListProvider.dart';
import '../widgets/Formbuilder.dart';

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
  List groups = [];
  List powerOrigins = [];
  List types = [];

  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    context.read<CharacterListProvider>().setCharacterProvider(() {
      selectedResultsList();
    });
    super.initState();
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
      if ((genders.contains(character.gender) || genders.isEmpty == true) &&
          (groups.contains(character.group) || groups.isEmpty == true) &&
          (powerOrigins.contains(character.powerOrigin) || powerOrigins.isEmpty == true) &&
          (types.contains(character.type) || types.isEmpty == true)) {
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
                    _displayDialog(
                        context,
                        (
                          List genderList,
                          List groupList,
                          List typeList,
                          List powerOriginList,
                        ) {
                          setState(() {
                            genders = genderList;
                            groups = groupList;
                            types = typeList;
                            powerOrigins = powerOriginList;
                          });
                        },
                        genders,
                        powerOrigins,
                        groups,
                        types,
                        () {
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
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) {
                        return Scaffold(
                          backgroundColor: AppThemes.pageColor,
                          resizeToAvoidBottomInset: false,
                          appBar: AppBar(
                            title: const Text('Form'),
                            backgroundColor: AppThemes.appbarColor,
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
                    child: GridView.builder(
                  padding: EdgeInsets.all(12.0),
                  itemCount: context.watch<CharacterListProvider>().filteredCharacters.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
                  itemBuilder: (BuildContext context, int index) =>
                      CharacterCard(context, context.read<CharacterListProvider>().filteredCharacters[index]),
                )),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          return false;
        });
  }

  @override
  bool get wantKeepAlive => keepAlive;
}

_displayDialog(
  BuildContext context,
  Function setAllOptions,
  List genders,
  List powerOrigins,
  List groups,
  List types,
  Function setSelectedCharacters,
) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: EdgeInsets.all(10),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Sieve'),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.cancel,
                  color: AppThemes.buttonColor,
                  size: 40,
                ))
          ],
        ),
        content: selectionView(
          genders: genders,
          powerOrigins: powerOrigins,
          types: types,
          groups: groups,
          setAllOptions: setAllOptions,
          setSelectedCharacters: setSelectedCharacters,
        ),
      );
    },
  );
}

class selectionView extends StatefulWidget {
  Function setAllOptions;
  List genders;
  List powerOrigins;
  List groups;
  List types;
  Function setSelectedCharacters;

  selectionView(
      {Key? key,
      required this.genders,
      required this.groups,
      required this.types,
      required this.powerOrigins,
      required this.setAllOptions,
      required this.setSelectedCharacters})
      : super(key: key);

  @override
  _selectionView createState() => _selectionView();
}

class _selectionView extends State<selectionView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[
              FilterChip("gender", Character.genderOptions, widget.genders),
              FilterChip("type", Character.typeOptions, widget.types),
              FilterChip("powerOrigin", Character.powerOriginOptions, widget.powerOrigins),
              FilterChip("group", Character.groupOptions, widget.groups),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                color: AppThemes.buttonColor,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _formKey.currentState?.save();
                  if (_formKey.currentState!.validate()) {
                    widget.setAllOptions(_formKey.currentState?.value['gender'], _formKey.currentState?.value['group'],
                        _formKey.currentState?.value['type'], _formKey.currentState?.value['powerOrigin']);
                    widget.setSelectedCharacters();
                    Navigator.of(context).pop();
                  } else {
                    print("validation failed");
                  }
                },
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: MaterialButton(
                color: AppThemes.buttonColor,
                child: Text(
                  "Reset",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  //_formKey.currentState?.reset();
                  _formKey.currentState?.patchValue({
                    'gender': [],
                    'group': [],
                    'powerOrigin': [],
                    'type': [],
                  });
                },
              ),
            ),
          ],
        )
      ],
    ));
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
