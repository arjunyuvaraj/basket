// IMPORTS
import 'package:basket/authentication/login_or_register.dart';
import 'package:basket/components/app_button_primary.dart';
import 'package:basket/components/app_loading_circle.dart';
import 'package:basket/components/info_row.dart';
import 'package:basket/models/theme_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  AccountPage({super.key});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  // HELPER METHODS
  void handleSignOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginOrRegister()),
    );
  }

  void handleDeleteAccount(BuildContext context, String username) async {
    // Variables
    final TextEditingController confirmController = TextEditingController();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    // Confirmation Method: Type in username
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "To delete your account, please type your username below to confirm. This action cannot be undone.",
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final input = confirmController.text.trim();
              if (input == username) {
                navigator.pop(true);
              } else {
                messenger.showSnackBar(
                  const SnackBar(content: Text("Username does not match.")),
                );
              }
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        messenger.showSnackBar(const SnackBar(content: Text("No user found.")));
        return;
      }

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.email)
          .delete();
      await user.delete();

      navigator.pushReplacement(
        MaterialPageRoute(builder: (_) => LoginOrRegister()),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text("Account deletion failed: $e")),
      );
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    final email = currentUser?.email;
    if (email == null) {
      throw Exception("No logged-in user.");
    }

    return FirebaseFirestore.instance.collection("Users").doc(email).get();
  }

  @override
  Widget build(BuildContext context) {
    // THEME
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          // Get user data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoadingCircle());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: Text("No user data found."));
          }
          final user = snapshot.data!.data()!;
          final username = user['username'] ?? '';
          final fullName =
              "${user['first_name']?.toString().toUpperCase() ?? ''} ${user['last_name']?.toString().toUpperCase() ?? ''}";

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              children: [
                // Profile Header
                Center(
                  // Header
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person_rounded,
                          size: 52,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "WELCOME",
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        fullName,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "@${user['username'] ?? ''}",
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Account Info Section Header
                Text(
                  "ACCOUNT INFORMATION",
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                // Email, Username, and Mode
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: colorScheme.surface,
                  child: Column(
                    children: [
                      InfoRow(
                        bottomBorder: true,
                        label: "Email",
                        value: user['email'],
                        icon: Icons.email_outlined,
                      ),
                      InfoRow(
                        bottomBorder: true,
                        label: "Username",
                        value: user['username'],
                        icon: Icons.person_outline_rounded,
                      ),
                      InkWell(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14),
                        ),
                        onTap: () => Provider.of<ThemeModel>(
                          context,
                          listen: false,
                        ).handleModeChange(),
                        child: InfoRow(
                          bottomBorder: false,
                          label: "Theme",
                          value: user['theme'] == "light"
                              ? "Light Mode"
                              : "Dark Mode",
                          icon: theme.brightness == Brightness.dark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Actions Section Header
                Text(
                  "ACTIONS",
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.outline,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                AppButtonPrimary(
                  text: "Sign Out",
                  onPressed: () => handleSignOut(context),
                ),

                const SizedBox(height: 40),

                // Danger Zone Section Header
                Text(
                  "DANGER ZONE",
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.onError,
                    backgroundColor: colorScheme.error,
                    side: BorderSide(color: colorScheme.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => handleDeleteAccount(context, username),
                  icon: const Icon(Icons.delete_forever),
                  label: const Text("Delete Account"),
                ),

                const SizedBox(
                  height: 48,
                ), // Bottom padding so not stuck to bottom nav
              ],
            ),
          );
        },
      ),
    );
  }
}
