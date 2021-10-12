import 'package:angelo/services/auth.dart';
import 'package:angelo/widgets/loading_widget.dart';
import 'package:angelo/widgets/ok_dialog_widget.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingWidget()
        : Scaffold(
            backgroundColor: Constants().firstColor,
            body: SafeArea(
                child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/Images-bro.png'))),
                  ),
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  Text(
                    'Please login to continue',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'EMAIL',
                        fillColor: Colors.white.withOpacity(.3),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        filled: true),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'PASSWORD',
                        fillColor: Colors.white.withOpacity(.3),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        filled: true),
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Align(
                    child: SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            final result = await AuthService().login(
                                email: _emailController.text,
                                password: _passwordController.text);

                            if (result != null) {
                              _emailController.clear();
                              _passwordController.clear();
                              setState(() {
                                _isLoading = false;
                              });
                              Navigator.pushNamed(context, '/auth');
                            } else {
                              _emailController.clear();
                              _passwordController.clear();
                              setState(() {
                                _isLoading = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (_) => okDialogWidget(
                                      context: context,
                                      message:
                                          'Something went wrong please try again.'));
                            }
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            showDialog(
                                context: context,
                                builder: (_) => okDialogWidget(
                                    context: context,
                                    message:
                                        'Please enter all required details'));
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(fontSize: 20, color: Colors.teal),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: 20, color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            )),
          );
  }
}
