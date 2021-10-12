import 'dart:io';
import 'dart:typed_data';

import 'package:angelo/constants.dart';
import 'package:angelo/models/CurrentUser.dart';
import 'package:angelo/models/Gallery.dart';
import 'package:angelo/services/database.dart';
import 'package:angelo/widgets/loading_widget.dart';
import 'package:angelo/widgets/ok_dialog_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  Future<File?> downloadFile(
      {required String url, required String name}) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final response = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.data),
          quality: 68,
          name: name);

      final isSuccess = result['isSuccess'];

      if (isSuccess) {
        showDialog(
            context: context,
            builder: (_) => okDialogWidget(
                context: context,
                message: 'Image Downloaded, Check Phone Gallery'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final currentUser = Provider.of<CurrentUser?>(context);
    return StreamBuilder<Gallery>(
      stream: DatabaseService(imageId: id).gallery,
      builder: (context, snapshot) {
        Gallery? gallery = snapshot.data;
        if (snapshot.hasData) {
          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () =>
                  downloadFile(url: gallery!.image, name: gallery.name),
              label: Text('Download'),
              icon: FaIcon(FontAwesomeIcons.download),
            ),
            appBar: AppBar(
              title: Text('Select Image'),
              actions: [
                currentUser!.uid == gallery!.uid
                    ? IconButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text(
                                      'Angelo',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.teal),
                                    ),
                                    content: Text(
                                      'Are your sure you want to delete.',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.teal),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.teal)),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await DatabaseService(
                                                  imageId: gallery.id)
                                              .deleteImage()
                                              .then((value) {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text('Yes',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.teal)),
                                      )
                                    ],
                                  ));
                        },
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                        ))
                    : IconButton(
                        onPressed: () {}, icon: Icon(Icons.person_rounded))
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                  color: Constants().firstColor,
                  image: DecorationImage(
                      image: NetworkImage(gallery.image), fit: BoxFit.contain)),
            ),
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }
}
