import 'package:characrea/Themes.dart';
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
import '../Themes.dart';
import '../pages/third_screen.dart';
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

  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  CroppedFile? _smallerCroppedFile;
  String? temp;
  bool haveImageToggle = false;

  @override
  void initState() {
    super.initState();
    haveImageToggle = (widget.originalCharacter.displayPhoto != '' && widget.originalCharacter.facePhoto != '');
  }

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverAppBarDelegate(
        minHeight: 20.0,
        maxHeight: 40.0,
        child: Container(
            color: AppThemes.buttonColor,
            child: Center(
                child: Text(
              headerText,
              style: TextStyle(color: Colors.white),
            ))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: FormBuilder(
        key: _formKey,
        child: CustomScrollView(
          slivers: <Widget>[
            makeHeader('General'),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  CustomTextField('name', widget.originalCharacter.name),
                  CustomTextField('power', widget.originalCharacter.power),
                  CustomTextField('powerDescription', widget.originalCharacter.powerDescription),
                  CustomTextField('race', widget.originalCharacter.race),
                ],
              ),
            ),
            makeHeader('Identity'),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  CustomTextField('motto', widget.originalCharacter.motto),
                  CustomTextField('catchphrase', widget.originalCharacter.catchphrase),
                  CustomTextField('description', widget.originalCharacter.description),
                ],
              ),
            ),
            makeHeader('Style'),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  CustomTextField('hair', widget.originalCharacter.hair),
                  CustomTextField('appearance', widget.originalCharacter.appearance),
                  CustomTextField('frame', widget.originalCharacter.frame),
                  CustomTextField('outfit', widget.originalCharacter.outfit),
                ],
              ),
            ),
            makeHeader('Class'),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ChoiceChip('group', Character.groupOptions, widget.originalCharacter.group),
                  ChoiceChip('type', Character.typeOptions, widget.originalCharacter.type),
                  ChoiceChip('gender', Character.genderOptions, widget.originalCharacter.gender),
                  ChoiceChip('powerOrigin', Character.powerOriginOptions, widget.originalCharacter.powerOrigin),
                  // FormBuilderSlider(
                  //   name: 'slider',
                  //   validator: FormBuilderValidators.compose([
                  //     FormBuilderValidators.min(6),
                  //   ]),
                  //   min: 0.0,
                  //   max: 10.0,
                  //   initialValue: 7.0,
                  //   divisions: 20,
                  //   activeColor: Colors.red,
                  //   inactiveColor: Colors.pink[100],
                  //   decoration: const InputDecoration(
                  //     labelText: 'Number of things',
                  //   ),
                  // ),
                ],
              ),
            ),
            // makeHeader('Photo'),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  haveImageToggle
                      ? FutureBuilder(
                          future: Future.wait([
                            readImageFromDatabase(widget.originalCharacter.facePhoto),
                            readImageFromDatabase(widget.originalCharacter.displayPhoto)
                          ]),
                          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                            if (snapshot.hasData) {
                              return WhenHaveImage(snapshot.data![0], snapshot.data![1]);
                            }
                            return const Text("error");
                          })
                      : ImagePickerAndCropper(),
                  if (widget.originalCharacter.facePhoto != '' && widget.originalCharacter.displayPhoto != '') ...[
                    MaterialButton(
                      color: AppThemes.buttonColor,
                      child: Text(
                        haveImageToggle ? "Choose new Image" : "Back to original images",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          haveImageToggle = !haveImageToggle;
                        });
                      },
                    ),
                  ],
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
                            print(_formKey.currentState?.value);
                            if (!(_pickedFile != null && (_smallerCroppedFile == null || _croppedFile == null)) &&
                                _formKey.currentState!.validate()) {
                              var pathFaceImage = widget.originalCharacter.facePhoto;
                              var pathDisplayImage = widget.originalCharacter.displayPhoto;
                              if (_pickedFile != null) {
                                if (pathDisplayImage != "" && pathFaceImage != "") {
                                  deleteImageFromDatabase(pathDisplayImage);
                                  deleteImageFromDatabase(pathFaceImage);
                                }
                                pathFaceImage = "${FirebaseAuth.instance.currentUser?.uid}/${DateTime.now()}Face.jpg";
                                uploadImageToDatabase(File(_smallerCroppedFile!.path), pathFaceImage);
                                pathDisplayImage = "${FirebaseAuth.instance.currentUser?.uid}/${DateTime.now()}Display.jpg";
                                uploadImageToDatabase(File(_croppedFile!.path), pathDisplayImage);
                              }
                              Character editedCharacter = Character(
                                  name: _formKey.currentState?.value['name'],
                                  group: _formKey.currentState?.value['group'],
                                  type: _formKey.currentState?.value['type'],
                                  gender: _formKey.currentState?.value['gender'],
                                  power: _formKey.currentState?.value['power'],
                                  powerOrigin: _formKey.currentState?.value['powerOrigin'],
                                  powerDescription: _formKey.currentState?.value['powerDescription'],
                                  race: _formKey.currentState?.value['race'],
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
                              widget.originalCharacter.documentId == "" ? addCharacter(editedCharacter) : setCharacter(editedCharacter);
                              widget.callback(editedCharacter);
                              if (widget.originalCharacter.documentId == "") {
                                Navigator.of(context).pop();
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "One or more have not been cropped from chosen image or you have not filled some fields",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red.shade100,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
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
                            _formKey.currentState?.reset();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget WhenHaveImage(String smallImageUrl, String bigImageUrl) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 0.8 * screenWidth,
                maxHeight: 0.7 * screenHeight,
              ),
              child: Image.network(smallImageUrl),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 0.8 * screenWidth,
                maxHeight: 0.7 * screenHeight,
              ),
              child: Image.network(bigImageUrl),
            ),
          ),
        ),
      ),
    ]);
  }

  // Widget WhenHaveImage(String smallImageUrl, String bigImageUrl) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final screenHeight = MediaQuery.of(context).size.height;
  //   return FutureBuilder(
  //     future: Future.wait([readImageFromDatabase(widget.originalCharacter.facePhoto), readImageFromDatabase(widget.originalCharacter.displayPhoto)]),
  //     builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
  //       return Column(children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
  //           child: Card(
  //             elevation: 4.0,
  //             child: Padding(
  //               padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
  //               child: ConstrainedBox(
  //                 constraints: BoxConstraints(
  //                   maxWidth: 0.8 * screenWidth,
  //                   maxHeight: 0.7 * screenHeight,
  //                 ),
  //                 child: Image.network(snapshot.data![0]),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
  //           child: Card(
  //             elevation: 4.0,
  //             child: Padding(
  //               padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
  //               child: ConstrainedBox(
  //                 constraints: BoxConstraints(
  //                   maxWidth: 0.8 * screenWidth,
  //                   maxHeight: 0.7 * screenHeight,
  //                 ),
  //                 child: Image.network(snapshot.data![1]),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ]);
  //     },
  //   );
  // }

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                    color: Theme.of(context).highlightColor.withOpacity(0.4),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: Theme.of(context).highlightColor,
                            size: 80.0,
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Upload an image to start',
                            style: kIsWeb
                                ? Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).highlightColor)
                                : Theme.of(context).textTheme.bodyText2!.copyWith(color: Theme.of(context).highlightColor),
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
                  style: ElevatedButton.styleFrom(primary: AppThemes.buttonColor),
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
  Widget build(BuildContext context) => FormBuilderTextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
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
  Widget build(BuildContext context) => FormBuilderChoiceChip(
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
