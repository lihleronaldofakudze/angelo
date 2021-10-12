import 'package:angelo/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().firstColor,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWave(color: Colors.teal),
            SizedBox(
              height: 10,
            ),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.teal, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
