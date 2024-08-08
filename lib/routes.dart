import 'package:go_router/go_router.dart';
import 'package:parkeasy/features/auth/presentation/pages/auth_page.dart';
import 'package:parkeasy/features/auth/presentation/pages/information_complete.dart';
import 'package:parkeasy/features/auth/presentation/pages/onboarding_screen.dart';
import 'package:parkeasy/features/auth/presentation/pages/verification_otp.dart';
import 'package:parkeasy/features/auth/presentation/widgets/auth_info.dart';
import 'package:parkeasy/features/map/presentation/pages/home_screen.dart';
import 'package:parkeasy/core/constant/waiting_page.dart';

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
  static const String connectionScreen = '/onnectionscreen';
  static const String phoneGest = '/PhoneGest';
  static const String authPage = '/authPage';
  static const String informationCompleteUser = '/informationcompleteuser';
  static const String verificationGest = '/VerificationGest';
  static const String parkEaseNombre = '/ParkEaseNombre';
  static const String badgeScreen = '/BadgeScreen';
  static const String carteNationale = '/cartenationale';
  static const String parkScreen = '/parkscreen';
  static const String verificationOTP = '/VerificationOTP';
  static const String onboarding = '/onboarding';
  static const String registrationConfirmationPage =
      '/registrationConfirmationPage';
  static const String defaultPage = '/';
  static const String waitingPage = '/waitingPage';

  static final GoRouter router = GoRouter(
    initialLocation: onboarding,
    routes: [
      GoRoute(
        path: waitingPage,
        redirect: OnboardingScreen.redirect,
        pageBuilder: (context, state) {
          return const NoTransitionPage(child: WaitingPage());
        },
      ),

      GoRoute(
        path: onboarding,
        redirect: OnboardingScreen.redirect,
        pageBuilder: (context, state) {
          return NoTransitionPage(child: OnboardingScreen.page());
        },
      ),
      GoRoute(
        path: home,
        redirect: HomeScreen.redirect,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
          path: verificationOTP,
          builder: (context, state) {
            AuthInfo authInfo = state.extra as AuthInfo;
            return VerificationOtp(
              verificationId: authInfo.verificationId!,
              phoneNumber: authInfo.sms!,
            );
          }),
      GoRoute(
        path: authPage,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: informationCompleteUser,
        builder: (context, state) => const InformationCompletePage(),
      ),
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
