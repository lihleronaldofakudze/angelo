import 'package:angelo/constants.dart';
import 'package:angelo/models/CurrentUser.dart';
import 'package:angelo/models/Photographer.dart';
import 'package:angelo/services/auth.dart';
import 'package:angelo/services/database.dart';
import 'package:angelo/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUser?>(context);
    return StreamBuilder<Photographer>(
      stream: DatabaseService(uid: currentUser!.uid).photographer,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Photographer? photographer = snapshot.data;
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
                'Profile',
                style: TextStyle(fontSize: 25),
              ),
              actions: [
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.settings_rounded)),
              ],
            ),
            body: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(photographer!.image),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    photographer.username,
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${currentUser.email}',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signature');
                        },
                        child: Text(
                          'Add Signature',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
          );
        } else {
          return LoadingWidget();
        }
      },
    );
  }
}
