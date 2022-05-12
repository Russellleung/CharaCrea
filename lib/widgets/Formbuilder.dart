import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../provider/CharacterListProvider.dart';

class Formbuilder extends StatefulWidget {
  Character originalCharacter;
  final void Function(Character character) callback;

  Formbuilder({Key? key, required this.originalCharacter, required this.callback}) : super(key: key);

  @override
  _Formbuilder createState() => _Formbuilder();
}

class _Formbuilder extends State<Formbuilder> {
  //final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _formKey = GlobalKey<FormBuilderState>();

  List genderOptions = ['male', 'female', 'other'];
  List groupOptions = ['Frontier', 'Mission', 'Mystery', 'War', 'New', 'Clandestine', 'Commando', 'Separate'];
  List typeOptions = [
    'AOE',
    'Tank',
    'Support',
    'Striker',
    'Defense',
    'Stealth',
    'Wild',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
      ),
      body: ListView(
        children: <Widget>[
          FormBuilder(
            key: _formKey,
            child: Column(
              children: <Widget>[
                CustomTextField('name', widget.originalCharacter.name),
                CustomTextField('power', widget.originalCharacter.power),
                CustomTextField('powerDescription', widget.originalCharacter.powerDescription),
                CustomTextField('race', widget.originalCharacter.race),
                CustomTextField('motto', widget.originalCharacter.motto),
                CustomTextField('catchphrase', widget.originalCharacter.catchphrase),
                CustomTextField('description', widget.originalCharacter.description),
                CustomTextField('hair', widget.originalCharacter.hair),
                CustomTextField('appearance', widget.originalCharacter.appearance),
                CustomTextField('frame', widget.originalCharacter.frame),
                CustomTextField('outfit', widget.originalCharacter.outfit),
                ChoiceChip('group', groupOptions, widget.originalCharacter.group),
                ChoiceChip('type', typeOptions, widget.originalCharacter.type),
                ChoiceChip('gender', genderOptions, widget.originalCharacter.gender),
                FormBuilderSlider(
                  name: 'slider',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.min(6),
                  ]),
                  min: 0.0,
                  max: 10.0,
                  initialValue: 7.0,
                  divisions: 20,
                  activeColor: Colors.red,
                  inactiveColor: Colors.pink[100],
                  decoration: const InputDecoration(
                    labelText: 'Number of things',
                  ),
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
                    print(_formKey.currentState?.value);
                    print(_formKey.currentState?.value['name']);
                    Character editedCharacter = Character(
                        name: _formKey.currentState?.value['name'],
                        group: _formKey.currentState?.value['group'],
                        type: _formKey.currentState?.value['type'],
                        gender: _formKey.currentState?.value['gender'],
                        power: _formKey.currentState?.value['power'],
                        powerDescription: _formKey.currentState?.value['powerDescription'],
                        race: _formKey.currentState?.value['race'],
                        photo: "",
                        croppedPhoto: "",
                        motto: _formKey.currentState?.value['motto'],
                        catchphrase: _formKey.currentState?.value['catchphrase'],
                        description: _formKey.currentState?.value['description'],
                        hair: _formKey.currentState?.value['hair'],
                        appearance: _formKey.currentState?.value['appearance'],
                        frame: _formKey.currentState?.value['frame'],
                        outfit: _formKey.currentState?.value['outfit'],
                        documentId: widget.originalCharacter.documentId);
                    addCharacter(editedCharacter);
                    // if (_formKey.currentState!.validate()) {
                    //   print(_formKey.currentState?.value);
                    // } else {
                    //   print("validation failed");
                    //   print(_formKey.currentState?.value);
                    //   print(_formKey.currentState?.value['name']);
                    //   Character editedCharacter = Character(
                    //       name: _formKey.currentState?.value['name'],
                    //       group: _formKey.currentState?.value['name'],
                    //       type: _formKey.currentState?.value['name'],
                    //       gender: _formKey.currentState?.value['name'],
                    //       power: _formKey.currentState?.value['name'],
                    //       powerDescription: _formKey.currentState?.value['name'],
                    //       race: _formKey.currentState?.value['name'],
                    //       photo: _formKey.currentState?.value['name'],
                    //       croppedPhoto: _formKey.currentState?.value['name'],
                    //       motto: _formKey.currentState?.value['name'],
                    //       catchphrase: _formKey.currentState?.value['name'],
                    //       description: _formKey.currentState?.value['name'],
                    //       hair: _formKey.currentState?.value['name'],
                    //       appearance: _formKey.currentState?.value['name'],
                    //       frame: _formKey.currentState?.value['name'],
                    //       outfit: _formKey.currentState?.value['name'],
                    //       documentId: "");
                    // }
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
                    _formKey.currentState?.reset();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(this.name, this.initialValue);

  final String name;
  final String initialValue;

  @override
  Widget build(BuildContext context) => FormBuilderTextField(
        initialValue: initialValue,
        name: name,
        decoration: InputDecoration(
          labelText: name,
        ),
// valueTransformer: (text) => num.tryParse(text),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.max(70),
        ]),
      );
}

class ChoiceChip extends StatelessWidget {
  const ChoiceChip(this.name, this.options, this.initialValue);

  final String name;
  final int initialValue;
  final List options;

  @override
  Widget build(BuildContext context) => FormBuilderChoiceChip(
        spacing: 5,
        initialValue: initialValue,
        name: name,
        decoration: InputDecoration(
          labelText: name,
        ),
        validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
        options: options
            .asMap()
            .entries
            .map(
              (item) => FormBuilderFieldOption(value: item.key, child: Text(item.value)),
            )
            .toList(),
      );
}

// FormBuilderTextField(
//   initialValue: "",
//   name: 'power',
//   decoration: InputDecoration(
//     labelText: 'power',
//   ),
//   onChanged: _onChanged,
//   // valueTransformer: (text) => num.tryParse(text),
//   validator: FormBuilderValidators.compose([
//     FormBuilderValidators.required(),
//     FormBuilderValidators.max(70),
//   ]),
// ),
