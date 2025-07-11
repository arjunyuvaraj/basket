import 'package:basket/authentication/auth.dart';
import 'package:basket/firebase_options.dart';
import 'package:basket/models/theme_model.dart';
import 'package:basket/theme/dark_mode.dart';
import 'package:basket/theme/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final themeModel = ThemeModel();
  try {
    await themeModel.loadUserTheme();
  } catch (e) {
    print('Failed to load user theme: $e');
  }

  runApp(
    ChangeNotifierProvider<ThemeModel>.value(
      value: themeModel,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeModel.currentTheme == 'dark'
          ? ThemeMode.dark
          : ThemeMode.light,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(color: ColorScheme.of(context).surface),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: child,
            ),
          ),
        );
      },

      home: const AuthPage(),
    );
  }
}
