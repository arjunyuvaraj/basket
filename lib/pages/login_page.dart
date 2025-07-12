import 'package:basket/components/app_button_primary.dart';
import 'package:basket/components/app_loading_circle.dart';
import 'package:basket/components/app_text_field.dart';
import 'package:basket/helper/help_functions.dart';
import 'package:basket/pages/navigation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.onTap});
  void Function() onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controllers
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void handleLogin() async {
    final ctx = context;

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) => const AppLoadingCircle(),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (!mounted) return;
      Navigator.pop(ctx);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationPage()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      Navigator.pop(ctx); // close loading spinner
      displayMessageToUser(e.message ?? "Login error", ctx);
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
              Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(height: 16),
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
              //Password
              AppTextField(
                hintText: "Password",
                controller: passwordController,
                obscureText: true,
              ),
              //Forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {}, child: Text("Forgot Password?")),
                ],
              ),
              //login button
              AppButtonPrimary(text: "LOGIN", onPressed: handleLogin),
              // sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onTap,
                    child: Text(
                      'Register Here',
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
