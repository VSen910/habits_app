import 'package:flutter/material.dart';
import 'package:habits/auth/auth_functions.dart';
import 'package:habits/components/custom_appbar.dart';
import 'package:habits/components/custom_textformfield.dart';
import 'package:habits/screens/home_screen.dart';
import 'package:habits/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.prefs}) : super(key: key);

  final SharedPreferences prefs;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomAppBar(
        titleText: 'habits',
        hasLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 32.0, right: 64),
                child: Text(
                  'Glad to have you back!',
                  style: TextStyle(
                    color: kPrimaryColour,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 32.0, right: 48),
                child: Text(
                  'Resume your journey',
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
                      prefixIcon: const Icon(Icons.email),
                      obscureText: false,
                      onSaved: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      validator: (val) {
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomTextFormField(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      obscureText: true,
                      onSaved: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      validator: (val) {
                        return null;
                      },
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
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final username =
                          await AuthServices.signIn(email!, password!);
                      if (username != null && context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              username: username,
                              prefs: widget.prefs,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
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
                        builder: (context) => RegisterScreen(prefs: widget.prefs,),
                      ),
                    );
                  },
                  child: const Text(
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
