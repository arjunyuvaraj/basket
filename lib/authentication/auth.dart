import 'package:basket/authentication/login_or_register.dart';
import 'package:basket/pages/navigation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const NavigationPage();
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
