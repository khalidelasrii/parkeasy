import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static Future<String> redirect(
      BuildContext context, GoRouterState state) async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingSeen = prefs.getBool('onboardingSeen') ?? false;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (onboardingSeen) {
      if (firebaseAuth.currentUser != null) {
        return '/';
      } else {
        return '/authPage';
      }
    }
    return '/onboarding';
  }

  static Widget page() => const OnboardingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/onboarding.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('onboardingSeen', true);
                  context.go('/home');
                },
                child: const Text('Commencer'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
