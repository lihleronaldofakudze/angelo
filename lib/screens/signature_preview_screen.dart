import 'dart:typed_data';

import 'package:angelo/widgets/ok_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';

class SignaturePreviewScreen extends StatefulWidget {
  final Uint8List signature;
  const SignaturePreviewScreen({Key? key, required this.signature})
      : super(key: key);

  @override
  _SignaturePreviewScreenState createState() => _SignaturePreviewScreenState();
}

class _SignaturePreviewScreenState extends State<SignaturePreviewScreen> {
  Future storeSignature(BuildContext context) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = 'signature_$time.png';
    final result =
        await ImageGallerySaver.saveImage(widget.signature, name: name);
    final isSuccess = result['isSuccess'];

    if (isSuccess) {
      showDialog(
          context: context,
          builder: (_) => okDialogWidget(
              context: context, message: 'Signature downloaded successfully'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().firstColor,
      appBar: AppBar(
        title: Text(
          'Store Signature',
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          IconButton(
              onPressed: () => storeSignature(context), icon: Icon(Icons.save))
        ],
      ),
      body: Container(
        child: Center(
          child: Image.memory(widget.signature),
        ),
      ),
    );
  }
}
