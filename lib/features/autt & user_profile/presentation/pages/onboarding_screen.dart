import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkeasy/core/constant/constants.dart';
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
        return '/mappage';
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
      backgroundColor: bluecolor,
      body: SafeArea(
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 90, vertical: 8),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    child: Image.asset(
                      'assets/icon-park.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: Image.asset(
                    'assets/parck-esy.png',
                    fit: BoxFit.cover,
                  ),
                ),

                // parck-esy.png
                const Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('onboardingSeen', true);
                    // ignore: use_build_context_synchronously
                    context.go('/authPage');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: white,
                  ),
                  child: Text('Commencer', style: TextStyle(color: bluecolor)),
                ),
                const Expanded(child: SizedBox())
              ]),
        ),
      ),
    );
  }
}
