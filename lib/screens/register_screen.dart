import 'package:flutter/material.dart';
import 'package:habits/components/custom_textformfield.dart';
import 'package:habits/constants.dart';
import 'package:habits/screens/login_screen.dart';

import '../components/custom_appbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Hi there!',
                  style: TextStyle(
                    color: kPrimaryColour,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Let\'s quickly get your profile created',
                  style: TextStyle(color: kGreyTextColour, fontSize: 16),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.15,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      labelText: 'First name',
                      obscureText: false,
                      prefixIcon: Icon(Icons.person),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      labelText: 'Email',
                      obscureText: false,
                      prefixIcon: Icon(Icons.email),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      labelText: 'Password',
                      obscureText: true,
                      prefixIcon: Icon(Icons.lock),
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
                      'Create profile',
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
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Already have an account? Sign in',
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
