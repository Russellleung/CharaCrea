import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:path_provider/path_provider.dart';

class ImageCropperPage extends StatelessWidget {
  const ImageCropperPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          highlightColor: const Color(0xFFD0996F),
          backgroundColor: const Color(0xFFFDF5EC),
          canvasColor: const Color(0xFFFDF5EC),
          textTheme: TextTheme(
            headline5: ThemeData.light().textTheme.headline5!.copyWith(color: const Color(0xFFBC764A)),
          ),
          iconTheme: IconThemeData(
            color: Colors.grey[600],
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFBC764A),
            centerTitle: false,
            foregroundColor: Colors.white,
            actionsIconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) => const Color(0xFFBC764A)),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith(
                (states) => const Color(0xFFBC764A),
              ),
              side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(color: Color(0xFFBC764A))),
            ),
          )),
      home: const CropperImage(title: 'Image Cropper Demo'),
    );
  }
}

class CropperImage extends StatefulWidget {
  final String title;

  const CropperImage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CropperImage> {
  // Create a storage reference from our app

  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  CroppedFile? _smallerCroppedFile;
  String? temp;

  Future<void> convertUriToFile(String uriString) async {
    try {
      File file = await toFile(uriString); // Converting uri to file
    } on UnsupportedError catch (e) {
      print(e.message); // Unsupported error for uri not supported
    } on IOException catch (e) {
      print(e); // IOException for system error
    } catch (e) {
      print(e); // General exception
    }
  }

  //
  // Future<Uint8List> _networkImageToByte(imageUri) async {
  //   Uint8List byteImage = await networkImageToByte(imageUri);
  //   return byteImage;
  // }
  //
  // convertUint8ToFile(String imageUri) async {
  //   Uint8List byteImage = await networkImageToByte(imageUri);
  //   //final imageURI = _networkImageToByte('kP1Bw2MDB8dteXntQnStt114QEB2/2022-05-12 22:59:43.292478Whole.jpg');
  //   return XFile.fromData(byteImage);
  // }

  Future<void> _uploadToDatabase(File file, String path) async {
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

  Future<void> _readFromDatabase(String path) async {
    final storageRef = FirebaseStorage.instance.ref();
    final ImageUrl = await storageRef.child(path).getDownloadURL();

    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.absolute}/images/${ImageUrl}.jpg";
    final file = File(filePath);
    final downloadTask = storageRef.child(path).writeToFile(file);
  }

  Future<void> _deleteFromDatabase(String path) async {
    final storageRef = FirebaseStorage.instance.ref();
    await storageRef.child(path).delete();
  }

  @override
  void initState() {
    super.initState();
    print("init");
    _readFromDatabase("kP1Bw2MDB8dteXntQnStt114QEB2/2022-05-12 22:59:43.292478Whole.jpg");
    // _deleteFromDatabase("kP1Bw2MDB8dteXntQnStt114QEB2/2022-05-09 00:14:22.589960titleSmall.jpg");
    // _deleteFromDatabase("kP1Bw2MDB8dteXntQnStt114QEB2/2022-05-09 00:14:22.597231title.jpg");
  }

  @override
  Widget build(BuildContext context) {
    return _body();

    //   ListView(
    //   // mainAxisSize: MainAxisSize.max,
    //   // crossAxisAlignment: CrossAxisAlignment.start,
    //   shrinkWrap: true,
    //   padding: const EdgeInsets.all(20.0),
    //   children: [
    //     if (kIsWeb)
    //       Padding(
    //         padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
    //         child: Text(
    //           widget.title,
    //           style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).highlightColor),
    //         ),
    //       ),
    //
    //     //Image.network(temp!),
    //   ],
    // );
  }

  Widget _body() {
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
        FloatingActionButton(
          onPressed: () {
            if (_smallerCroppedFile != null && _croppedFile != null) {
              final pathSmall = "${FirebaseAuth.instance.currentUser?.uid}/${DateTime.now()}${widget.title}Small.jpg";
              _uploadToDatabase(File(_smallerCroppedFile!.path), pathSmall);
              final path = "${FirebaseAuth.instance.currentUser?.uid}/${DateTime.now()}${widget.title}.jpg";
              _uploadToDatabase(File(_croppedFile!.path), path);
            } else {
              Fluttertoast.showToast(
                  msg: "One or more have not been cropped",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
          backgroundColor: Colors.greenAccent,
          tooltip: '',
          child: const Icon(Icons.add),
        ),
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
