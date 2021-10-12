import 'package:angelo/models/CurrentUser.dart';
import 'package:angelo/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_screen.dart';

class AuthStateScreen extends StatelessWidget {
  const AuthStateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<CurrentUser?>(context);

    if (currentUser == null) {
      return LoginScreen();
    } else {
      return AppScreen();
    }
  }
}
