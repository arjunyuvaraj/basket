// ignore_for_file: use_build_context_synchronously

import 'package:basket/components/app_button_primary.dart';
import 'package:basket/components/app_loading_circle.dart';
import 'package:basket/components/app_text_field.dart';
import 'package:basket/helper/help_functions.dart';
import 'package:basket/pages/navigation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key, required this.onTap});
  void Function() onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //controllers
  TextEditingController emailController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  void handleRegister() async {
    //show loading circle
    showDialog(context: context, builder: (context) => AppLoadingCircle());

    //make sure passwords match
    if (passwordController.text != confirmPasswordController.text) {
      //pop loading circle
      Navigator.pop(context);
      //alert user
      displayMessageToUser("Passwords don't match", context);
    } else {
      //try creating the user
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
        createUserDocument(userCredential);
        Navigator.pop(context);
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

          if (!mounted) return;
          Navigator.pop(context); // close loading spinner

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavigationPage()),
          );
        } on FirebaseAuthException catch (e) {
          if (!mounted) return;
          Navigator.pop(context); // close loading spinner
          displayMessageToUser(e.message ?? "Login error", context);
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
            'email': userCredential.user!.email,
            'username': usernameController.text,
            'first_name': firstNameController.text,
            'last_name': lastNameController.text,
            'theme': 'light',
            'items': {},
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //subtitle
              Text(
                "WELCOME  TO ",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  letterSpacing: 0.1,
                ),
              ),
              //app name
              Text(
                "B A S K E T",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              //Email
              AppTextField(
                hintText: "Email",
                controller: emailController,
                obscureText: false,
              ),
              const SizedBox(height: 16),
              AppTextField(
                hintText: "Username",
                controller: usernameController,
                obscureText: false,
              ),
              const SizedBox(height: 16),
              //full name
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      hintText: "First Name",
                      controller: firstNameController,
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(width: 8), // Add spacing if needed
                  Expanded(
                    child: AppTextField(
                      hintText: "Last Name",
                      controller: lastNameController,
                      obscureText: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              //Password
              AppTextField(
                hintText: "Password",
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 16),
              //Confirm Password
              AppTextField(
                hintText: "Confirm Password",
                controller: confirmPasswordController,
                obscureText: true,
              ),
              //Forgot password
              const SizedBox(height: 16),
              //login button
              AppButtonPrimary(text: "REGISTER", onPressed: handleRegister),
              //sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onTap,
                    child: Text(
                      'Login Here',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
