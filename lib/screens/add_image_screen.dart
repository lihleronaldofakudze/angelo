import 'dart:io';

import 'package:angelo/constants.dart';
import 'package:angelo/models/CurrentUser.dart';
import 'package:angelo/services/auth.dart';
import 'package:angelo/services/database.dart';
import 'package:angelo/widgets/loading_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class AddImageScreen extends StatefulWidget {
  const AddImageScreen({Key? key}) : super(key: key);

  @override
  State<AddImageScreen> createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  File _imageFile = File('');
  bool _isLoading = false;

  _pickImage(ImageSource source) async {
    XFile? selected =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    setState(() {
      _imageFile = File(selected!.path);
    });
  }

  Future<void> _cropImage() async {
    File? cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
    );
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  Future<void> _uploadImage({required String? uid}) async {
    setState(() {
      _isLoading = true;
    });
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('angelo')
        .child(basename(_imageFile.path));
    UploadTask uploadTask = reference.putFile(_imageFile);
    uploadTask.whenComplete(() async {
      reference.getDownloadURL().then((url) async {
        await DatabaseService(uid: uid)
            .addImage(image: url, name: basename(_imageFile.path))
            .then((value) {
          setState(() {
            _imageFile = File('');
            _isLoading = false;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUser?>(context);
    return _isLoading
        ? LoadingWidget()
        : Scaffold(
            backgroundColor: Constants().firstColor,
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  backgroundColor: Colors.pink,
                  onPressed: () => _pickImage(ImageSource.gallery),
                  label: Text(
                    'Gallery Pick',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                FloatingActionButton.extended(
                  backgroundColor: Colors.blue,
                  onPressed: () => _pickImage(ImageSource.camera),
                  label: Text(
                    'Camera Pick',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(
                                'Angelo',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.teal),
                              ),
                              content: Text(
                                'Are your sure you want to logout',
                                style:
                                    TextStyle(fontSize: 20, color: Colors.teal),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.teal)),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await AuthService().logout()!.then((value) {
                                      Navigator.pushNamed(context, '/auth');
                                    });
                                  },
                                  child: Text('Yes',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.teal)),
                                )
                              ],
                            ));
                  },
                  icon: Icon(Icons.logout_rounded)),
              title: Text(
                'Add Image',
                style: TextStyle(fontSize: 25),
              ),
            ),
            body: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  if (_imageFile.path != '') ...[
                    Image.file(_imageFile),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 45,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange),
                              onPressed: () => _cropImage(),
                              child: Text(
                                'Crop Image',
                                style: TextStyle(fontSize: 24),
                              )),
                        ),
                        SizedBox(
                          height: 45,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green),
                              onPressed: () =>
                                  _uploadImage(uid: currentUser!.uid),
                              child: Text(
                                'Upload Image',
                                style: TextStyle(fontSize: 24),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ] else ...[
                    Center(
                      child: Text(
                        'No Image Picked',
                        style: TextStyle(fontSize: 24, color: Colors.red),
                      ),
                    )
                  ]
                ],
              ),
            ),
          );
  }
}
