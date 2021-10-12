import 'package:angelo/constants.dart';
import 'package:angelo/services/auth.dart';
import 'package:angelo/services/database.dart';
import 'package:angelo/widgets/loading_widget.dart';
import 'package:angelo/widgets/ok_dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Create Account',
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                  Text(
                    'Please fill all details required.',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'USERNAME',
                        fillColor: Colors.white.withOpacity(.3),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        filled: true),
                    keyboardType: TextInputType.text,
                    controller: _usernameController,
                  ),
                  SizedBox(
                    height: 20,
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
                    height: 20,
                  ),
                  TextField(
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'CONFIRM PASSWORD',
                        fillColor: Colors.white.withOpacity(.3),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        filled: true),
                    keyboardType: TextInputType.visiblePassword,
                    controller: _confirmPasswordController,
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
                          if (_usernameController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty) {
                            if (_passwordController.text ==
                                _confirmPasswordController.text) {
                              final result = await AuthService().register(
                                  email: _emailController.text,
                                  password: _passwordController.text);

                              if (result != null) {
                                await DatabaseService(uid: result.uid)
                                    .setUserProfile(
                                        image: Constants().image,
                                        username: _usernameController.text)
                                    .then((value) {
                                  _usernameController.clear();
                                  _emailController.clear();
                                  _passwordController.clear();
                                  _confirmPasswordController.clear();
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.pushNamed(context, '/auth');
                                }).catchError((onError) {
                                  _usernameController.clear();
                                  _emailController.clear();
                                  _passwordController.clear();
                                  _confirmPasswordController.clear();
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showDialog(
                                      context: context,
                                      builder: (_) => okDialogWidget(
                                          context: context,
                                          message: onError.toString()));
                                });
                              } else {
                                _usernameController.clear();
                                _emailController.clear();
                                _passwordController.clear();
                                _confirmPasswordController.clear();
                                setState(() {
                                  _isLoading = false;
                                });
                                showDialog(
                                    context: context,
                                    builder: (_) => okDialogWidget(
                                        context: context,
                                        message:
                                            'Something went wrong, please try again.'));
                              }
                            } else {
                              _passwordController.clear();
                              _confirmPasswordController.clear();
                              setState(() {
                                _isLoading = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (_) => okDialogWidget(
                                      context: context,
                                      message: 'Passwords do not match'));
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
                          'Register',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Login',
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
