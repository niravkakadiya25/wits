import 'package:flutter/material.dart';
import 'package:wit/controller/LoginController.dart';
import 'package:wit/screens/home_screen.dart';
import 'package:wit/utils/const.dart';
import 'package:wit/utils/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return commanScreen(
      isLoading: isLoading,
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Login / Signup',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: email,
                      style: textStyle,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Your Email';
                        } else {
                          //If email address matches pattern
                          if (EmailValidator(value).isValidEmail()) {
                            return null;
                          } else {
                            //If it doesn't match
                            return 'Email is not valid';
                          }
                        }
                      },
                      decoration: inputDecoration(
                          prefixIcon: Icons.person_outline,
                          hintText: 'Email Address'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: password,
                      style: textStyle,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Password';
                        }
                        return null;
                      },
                      decoration: inputDecoration(
                        prefixIcon: Icons.lock_outline_rounded,
                        hintText: 'Password',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: buttonWidget(
                        padding: 10,
                        callback: () async {
                          FocusScope.of(context).unfocus();
                          await LoginController().handleSignIn(context,
                              email: email.text.trim(),
                              password: password.text.trim());
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                        },
                        text: 'Login',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 15,
  );

  InputDecoration inputDecoration(
      {required IconData prefixIcon, required String hintText}) {
    return InputDecoration(
      fillColor: Colors.white,
      hoverColor: Colors.white,
      focusColor: Colors.white,
      filled: true,
      errorStyle: const TextStyle(
        color: Colors.white,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: Colors.black,
      ),
      hintText: hintText,
      hintStyle: textStyle,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
    );
  }
}
