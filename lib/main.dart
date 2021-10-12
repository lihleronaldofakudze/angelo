import 'package:angelo/constants.dart';
import 'package:angelo/models/CurrentUser.dart';
import 'package:angelo/screens/auth_state_screen.dart';
import 'package:angelo/screens/image_screen.dart';
import 'package:angelo/screens/login_screen.dart';
import 'package:angelo/screens/register_screen.dart';
import 'package:angelo/screens/signature_screen.dart';
import 'package:angelo/services/auth.dart';
import 'package:angelo/services/database.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/Gallery.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<CurrentUser?>.value(
          value: AuthService().user,
          initialData: CurrentUser(),
        ),
        StreamProvider<List<Gallery>>.value(
          value: DatabaseService().galleries,
          initialData: [],
        ),
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => AnimatedSplashScreen(
                splashIconSize: double.infinity,
                nextScreen: AuthStateScreen(),
                splash: Container(
                  color: Constants().firstColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Clout Developers',
                        style: TextStyle(
                            fontSize: 24, color: Constants().secondColor),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('images/logo.png'),
                        )),
                      )
                    ],
                  ),
                ),
              ),
          '/auth': (context) => AuthStateScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/image': (context) => ImageScreen(),
          '/signature': (context) => SignatureScreen(),
        },
        title: 'Angelo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.teal,
            textTheme:
                GoogleFonts.caveatTextTheme(Theme.of(context).textTheme)),
      ),
    );
  }
}
