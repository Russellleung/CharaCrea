import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../provider/CharacterListProvider.dart';
import 'imageCropper.dart';

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

  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  CroppedFile? _smallerCroppedFile;
  String? temp;

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
          ImagePickerAndCropper(),
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _formKey.currentState?.save();
                    if (_smallerCroppedFile != null && _croppedFile != null && _formKey.currentState!.validate()) {
                      final pathFaceImage = "${FirebaseAuth.instance.currentUser?.uid}/${DateTime.now()}Face.jpg";
                      uploadImageToDatabase(File(_smallerCroppedFile!.path), pathFaceImage);
                      final pathDisplayImage = "${FirebaseAuth.instance.currentUser?.uid}/${DateTime.now()}Display.jpg";
                      uploadImageToDatabase(File(_croppedFile!.path), pathDisplayImage);
                      final pathWholeImage = "${FirebaseAuth.instance.currentUser?.uid}/${DateTime.now()}Whole.jpg";
                      uploadImageToDatabase(File(_pickedFile!.path), pathWholeImage);

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
                          wholePhoto: pathWholeImage,
                          displayPhoto: pathDisplayImage,
                          facePhoto: pathFaceImage,
                          motto: _formKey.currentState?.value['motto'],
                          catchphrase: _formKey.currentState?.value['catchphrase'],
                          description: _formKey.currentState?.value['description'],
                          hair: _formKey.currentState?.value['hair'],
                          appearance: _formKey.currentState?.value['appearance'],
                          frame: _formKey.currentState?.value['frame'],
                          outfit: _formKey.currentState?.value['outfit'],
                          documentId: widget.originalCharacter.documentId);
                      addCharacter(editedCharacter);
                    } else {
                      Fluttertoast.showToast(
                          msg: "One or more have not been cropped or you have not picked and image or you have not filled some fields",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
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
                  color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,
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

  Future<void> uploadImageToDatabase(File file, String path) async {
    final storageRef = FirebaseStorage.instance.ref();
    final ImageRef = storageRef.child(path);
    try {
      await ImageRef.putFile(
          file,
          SettableMetadata(
            contentType: "name/jpeg",
          ));
    } catch (error) {
      print(error);
    }
  }

  Future<void> readImageFromDatabase(String path) async {
    final storageRef = FirebaseStorage.instance.ref();
    final ImageUrl = await storageRef.child(path).getDownloadURL();
    // setState(() {
    //   temp = ImageUrl;
    // });
  }

  Future<void> deleteImageFromDatabase(String path) async {
    final storageRef = FirebaseStorage.instance.ref();
    await storageRef.child(path).delete();
  }

  Widget ImagePickerAndCropper() {
    if (_smallerCroppedFile != null || _croppedFile != null || _pickedFile != null) {
      return _imageCard();
    } else {
      return _uploaderCard();
    }
  }

  Widget _imageCard() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
                child: _image(),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          _menu(),
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
                child: _image2(),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          _menu2(),
        ],
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _image2() {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    if (_smallerCroppedFile != null) {
      final path = _smallerCroppedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _menu() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_croppedFile == null)
          FloatingActionButton(
            onPressed: () {
              _cropImage(
                  ratioY: 3,
                  ratioX: 2,
                  setCropped: (CroppedFile croppedFile) {
                    setState(() {
                      _croppedFile = croppedFile;
                    });
                  });
            },
            backgroundColor: const Color(0xFFBC764A),
            tooltip: 'Crop',
            child: const Icon(Icons.crop),
          )
        else
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _croppedFile = null;
              });
            },
            backgroundColor: const Color(0xFFBC764A),
            tooltip: 'Revert',
            child: const Icon(Icons.undo),
          ),
      ],
    );
  }

  Widget _menu2() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: () {
            _clear();
          },
          backgroundColor: Colors.redAccent,
          tooltip: 'Delete',
          child: const Icon(Icons.delete),
        ),
        // FloatingActionButton(
        //   onPressed: () {
        //     if (_smallerCroppedFile != null && _croppedFile != null) {
        //       final pathSmall = "${FirebaseAuth.instance.currentUser?.uid}/${DateTime.now()}Small.jpg";
        //       uploadImageToDatabase(File(_smallerCroppedFile!.path), pathSmall);
        //       final path = "${FirebaseAuth.instance.currentUser?.uid}/${DateTime.now()}Large.jpg";
        //       uploadImageToDatabase(File(_croppedFile!.path), path);
        //     } else {
        //       Fluttertoast.showToast(
        //           msg: "One or more have not been cropped",
        //           toastLength: Toast.LENGTH_SHORT,
        //           gravity: ToastGravity.BOTTOM,
        //           timeInSecForIosWeb: 1,
        //           backgroundColor: Colors.red,
        //           textColor: Colors.white,
        //           fontSize: 16.0);
        //     }
        //   },
        //   backgroundColor: Colors.greenAccent,
        //   tooltip: '',
        //   child: const Icon(Icons.add),
        // ),
        if (_smallerCroppedFile == null)
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton(
              onPressed: () {
                _cropImage(
                    ratioY: 1,
                    ratioX: 1,
                    setCropped: (CroppedFile croppedFile) {
                      setState(() {
                        _smallerCroppedFile = croppedFile;
                      });
                    });
              },
              backgroundColor: const Color(0xFFBC764A),
              tooltip: 'Crop',
              child: const Icon(Icons.crop),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _smallerCroppedFile = null;
                });
              },
              backgroundColor: const Color(0xFFBC764A),
              tooltip: 'Revert',
              child: const Icon(Icons.undo),
            ),
          )
      ],
    );
  }

  Widget _uploaderCard() {
    return Center(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: kIsWeb ? 380.0 : 320.0,
          height: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DottedBorder(
                    radius: const Radius.circular(12.0),
                    borderType: BorderType.RRect,
                    dashPattern: const [8, 4],
                    color: Theme
                        .of(context)
                        .highlightColor
                        .withOpacity(0.4),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: Theme
                                .of(context)
                                .highlightColor,
                            size: 80.0,
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Upload an image to start',
                            style: kIsWeb
                                ? Theme
                                .of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: Theme
                                .of(context)
                                .highlightColor)
                                : Theme
                                .of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Theme
                                .of(context)
                                .highlightColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    _uploadImage();
                  },
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage({double ratioX = 1, double ratioY = 1, required void Function(CroppedFile croppedFile) setCropped}) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatio: CropAspectRatio(ratioX: ratioX, ratioY: ratioY),
        uiSettings: [
          AndroidUiSettings(toolbarTitle: 'Cropper', toolbarColor: Colors.deepOrange, toolbarWidgetColor: Colors.white, lockAspectRatio: true),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        setCropped(croppedFile);
      }
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
      _smallerCroppedFile = null;
    });
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(this.name, this.initialValue);

  final String name;
  final String initialValue;

  @override
  Widget build(BuildContext context) =>
      FormBuilderTextField(
        initialValue: initialValue,
        name: name,
        decoration: InputDecoration(
          labelText: name,
        ),
// valueTransformer: (text) => num.tryParse(text),
        validator: FormBuilderValidators.compose([
          // FormBuilderValidators.required(),
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
  Widget build(BuildContext context) =>
      FormBuilderChoiceChip(
        spacing: 5,
        initialValue: initialValue,
        name: name,
        decoration: InputDecoration(
          labelText: name,
        ),
        validator: FormBuilderValidators.compose([FormBuilderValidators.required(), FormBuilderValidators.min(0)]),
        options: options
            .asMap()
            .entries
            .map(
              (item) => FormBuilderFieldOption(value: item.key, child: Text(item.value)),
        )
            .toList(),
      );
}