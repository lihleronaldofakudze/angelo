import 'dart:typed_data';

import 'package:angelo/constants.dart';
import 'package:angelo/screens/signature_preview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({Key? key}) : super(key: key);

  @override
  _SignatureScreenState createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  late SignatureController signatureController;

  @override
  void initState() {
    super.initState();
    signatureController =
        SignatureController(penColor: Colors.black, penStrokeWidth: 5);
  }

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }

  Future<Uint8List?> exportSignature() async {
    final exportController = SignatureController(
        penStrokeWidth: 2,
        penColor: Colors.black,
        exportBackgroundColor: Colors.white,
        points: signatureController.points);
    final signature = await exportController.toPngBytes();
    exportController.dispose();
    return signature;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().firstColor,
      appBar: AppBar(
        title: Text(
          'Signature',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Signature(
                controller: signatureController,
                backgroundColor: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () async {
                      if (signatureController.isNotEmpty) {
                        final signature = await exportSignature();
                        if (signature != null) {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => SignaturePreviewScreen(
                                    signature: signature,
                                  )));
                        }
                        signatureController.clear();
                      }
                    },
                    icon: Icon(
                      Icons.done,
                      color: Colors.green,
                      size: 36,
                    )),
                IconButton(
                    onPressed: () => signatureController.clear(),
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 36,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
