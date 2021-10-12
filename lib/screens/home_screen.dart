import 'package:angelo/constants.dart';
import 'package:angelo/services/auth.dart';
import 'package:angelo/widgets/gallery_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().firstColor,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Text(
                          'Angelo',
                          style: TextStyle(fontSize: 20, color: Colors.teal),
                        ),
                        content: Text(
                          'Are your sure you want to logout',
                          style: TextStyle(fontSize: 20, color: Colors.teal),
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
          'Angelo',
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: GalleryWidget(),
    );
  }
}
