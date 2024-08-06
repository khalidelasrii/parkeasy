import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const String home = '/';
  static const String profile = '/profile';
  static const String mapPage = '/mappage';
  static const String profileUser = '/profileUser';
  static const String mapsChoice = '/MapsChoice';
  static const String signUpUser = '/SignUpUser';
  static const String resetPasswordUser = '/ResetPasswordUser';
  static const String signInGest = '/SignInGest';
  static const String signUpGest = '/SignUpGest';
  static const String resetPasswordGest = '/ResetPasswordGest';
  static const String profilGest = '/ProfilGest';
  static const String connectionScreen = '/connectionscreen';
  static const String phoneGest = '/PhoneGest';
  static const String phoneUser = '/PhoneUser';
  static const String informationCompleteUser = '/informationcompleteuser';
  static const String verificationGest = '/VerificationGest';
  static const String parkEaseNombre = '/ParkEaseNombre';
  static const String badgeScreen = '/BadgeScreen';
  static const String carteNationale = '/cartenationale';
  static const String parkScreen = '/parkscreen';
  static const String verification = '/Verification';

  static final GoRouter router = GoRouter(
    routes: [
      // GoRoute(
      //   path: home,
      //   builder: (context, state) => const HomeScreen(),
      // ),
      // GoRoute(
      //   path: profile,
      //   builder: (context, state) => const ProfileScreen(),
      // ),
      // GoRoute(
      //   path: mapPage,
      //   builder: (context, state) => const MapPage(),
      // ),
      // GoRoute(
      //   path: profileUser,
      //   builder: (context, state) => const ProfileScreen(),
      // ),
      // GoRoute(
      //   path: mapsChoice,
      //   builder: (context, state) => const MapsChoice(),
      // ),
      // GoRoute(
      //   path: signUpUser,
      //   builder: (context, state) => const SignUpScreen(),
      // ),
      // GoRoute(
      //   path: resetPasswordUser,
      //   builder: (context, state) => const ResetPassword(),
      // ),
      // GoRoute(
      //   path: signInGest,
      //   builder: (context, state) => const SignInScreenGest(),
      // ),
      // GoRoute(
      //   path: signUpGest,
      //   builder: (context, state) => const SignUpScreenGest(),
      // ),
      // GoRoute(
      //   path: resetPasswordGest,
      //   builder: (context, state) => const ResetPasswordGest(),
      // ),
      // GoRoute(
      //   path: profilGest,
      //   builder: (context, state) => const ProfileGest(),
      // ),
      // GoRoute(
      //   path: connectionScreen,
      //   builder: (context, state) => const ConnectionScreen(),
      // ),
      // GoRoute(
      //   path: phoneGest,
      //   builder: (context, state) => const PhoneScreenGest(),
      // ),
      // GoRoute(
      //   path: phoneUser,
      //   builder: (context, state) => const PhoneScreen(),
      // ),
      // GoRoute(
      //   path: informationCompleteUser,
      //   builder: (context, state) => const InformationComplete(),
      // ),
      // GoRoute(
      //   path: verificationGest,
      //   builder: (context, state) => const Verification(),
      // ),
      // GoRoute(
      //   path: parkEaseNombre,
      //   builder: (context, state) => const ParkEaseScreenNomber(),
      // ),
      // GoRoute(
      //   path: badgeScreen,
      //   builder: (context, state) => const BadgeScreen(),
      // ),
      // GoRoute(
      //   path: carteNationale,
      //   builder: (context, state) => const CarteNationale(),
      // ),
      // GoRoute(
      //   path: parkScreen,
      //   builder: (context, state) => const ParkScreen(),
      // ),
      // GoRoute(
      //   path: verification,
      //   builder: (context, state) => const Verification(),
      // ),
    ],
  );
}
