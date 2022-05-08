import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../provider/CharacterListProvider.dart';

class Formbuilder extends StatefulWidget {
  final Character originalCharacter;

  const Formbuilder({Key? key, required this.originalCharacter}) : super(key: key);

  @override
  _Formbuilder createState() => _Formbuilder();
}

class _Formbuilder extends State<Formbuilder> {
  //final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  Character editedCharacter = Character();

  final _formKey = GlobalKey<FormBuilderState>();

  final _controller = TextEditingController();

  List genderOptions = ['male', 'female'];
  List groupOptions = ['male', 'female'];

  void _onChanged(parameter) {
    //setstate
  }

  @override
  void initState() {
    super.initState();
    editedCharacter = widget.originalCharacter.copy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          FormBuilder(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FormBuilderChoiceChip(
                  initialValue: '',
                  name: 'filter_chip',
                  decoration: InputDecoration(
                    labelText: 'Select many options',
                  ),
                  validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                  options: [
                    FormBuilderFieldOption(value: 'Test', child: Text('Test')),
                    FormBuilderFieldOption(value: 'Test 1', child: Text('Test 1')),
                    FormBuilderFieldOption(value: 'Test 2', child: Text('Test 2')),
                    FormBuilderFieldOption(value: 'Test 3', child: Text('Test 3')),
                    FormBuilderFieldOption(value: 'Test 4', child: Text('Test 4')),
                  ],
                ),
                FormBuilderChoiceChip(
                  name: 'choice_chip',
                  decoration: InputDecoration(
                    labelText: 'Select an option',
                  ),
                  options: [
                    FormBuilderFieldOption(value: 'Test', child: Text('Test')),
                    FormBuilderFieldOption(value: 'Test 1', child: Text('Test 1')),
                    FormBuilderFieldOption(value: 'Test 2', child: Text('Test 2')),
                    FormBuilderFieldOption(value: 'Test 3', child: Text('Test 3')),
                    FormBuilderFieldOption(value: 'Test 4', child: Text('Test 4')),
                  ],
                ),
                FormBuilderSlider(
                  name: 'slider',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.min(6),
                  ]),
                  onChanged: _onChanged,
                  min: 0.0,
                  max: 10.0,
                  initialValue: 7.0,
                  divisions: 20,
                  activeColor: Colors.red,
                  inactiveColor: Colors.pink[100],
                  decoration: InputDecoration(
                    labelText: 'Number of things',
                  ),
                ),
                FormBuilderCheckbox(
                  name: 'accept_terms',
                  initialValue: false,
                  onChanged: _onChanged,
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'I have read and agree to the ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  validator: FormBuilderValidators.equal(
                    true,
                    errorText: 'You must accept terms and conditions to continue',
                  ),
                ),
                FormBuilderTextField(
                  initialValue: "",
                  name: 'age',
                  decoration: InputDecoration(
                    labelText: 'The header',
                  ),
                  onChanged: _onChanged,
                  // valueTransformer: (text) => num.tryParse(text),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                    FormBuilderValidators.max(70),
                  ]),
                  keyboardType: TextInputType.number,
                ),
                FormBuilderDropdown(
                  name: 'gender',
                  decoration: InputDecoration(
                    labelText: 'Gender',
                  ),
                  // initialValue: 'Male',
                  allowClear: true,
                  hint: Text('Select Gender'),
                  validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                  items: genderOptions
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text('$gender'),
                          ))
                      .toList(),
                ),
                FormBuilderImagePicker(
                  name: 'photos',
                  decoration: const InputDecoration(labelText: 'Pick Photos'),
                  maxImages: 1,
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
                    } else {
                      print("validation failed");
                      print(_formKey.currentState?.value);
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
