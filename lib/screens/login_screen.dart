import 'package:flutter/material.dart';
import 'package:habits/components/custom_appbar.dart';
import 'package:habits/components/custom_textformfield.dart';
import 'package:habits/screens/register_screen.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(titleText: 'habits'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 64),
                child: Text(
                  'Glad to have you back!',
                  style: TextStyle(
                    color: kPrimaryColour,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 48),
                child: Text(
                  'Resume your journey in building better habits',
                  style: TextStyle(color: kGreyTextColour, fontSize: 16),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      obscureText: false,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColour,
                      elevation: 0,
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Don\'t have an account yet? Sign up',
                    style: TextStyle(
                      fontSize: 16,
                      color: kPrimaryColour,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
