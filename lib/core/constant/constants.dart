import 'package:flutter/material.dart';
import 'package:parkeasy/app_localization.dart';

Color bluecolor = const Color(0xFF0096FF);
Color background =const Color(0xFF262A43);
double opacity = 0.1;
Widget icon_arrow_back =const Icon(
  Icons.arrow_back_ios,
  color: Colors.white,
  size: 30,
);
// String apiKey = 'AIzaSyA6aGDVjftADFvEgs5kdJgfhjXJoEU7naM';
String apiKey = 'AIzaSyCrzgO70HKs9VY73T1oeWxK1n22x1hpssQ';

String getErrorMessage(String errorCode, BuildContext context) {
  switch (errorCode) {
    case 'invalid-email':
      return 'Adresse e-mail invalide'.tr(context);
    case 'invalid-credential':
      return 'Adresse e-mail  ou mot de passe invalide'.tr(context);
    case 'user-disabled':
      return "L'utilisateur a été désactivé".tr(context);
    case 'user-not-found':
      return "L'utilisateur n'existe pas".tr(context);
    case 'wrong-password':
      return 'Mot de passe incorrect'.tr(context);
    case 'too-many-requests':
      return "Trop de tentatives. Réessayez plus tard.".tr(context);
    case 'operation-not-allowed':
      return "Opération non autorisée".tr(context);
    case 'The email address is badly formatted':
      return 'The email address is badly formatted';

    case 'email-already-in-use':
      return "email est deja utilisé".tr(context);
    case 'channel-error':
      return "invalide email et mot de pass".tr(context);
    case 'weak-password':
      return "le mot de passe est faible".tr(context);
    default:
      return "";
  }
}

Image backgroundimage = Image.asset('assets/profile.png');
Color darkcolor = Color(0xFF262A43);
Color colorblue = Color(0xFFEDEDF7);
Color white = Colors.white;
Color purple = Color(0xFF7A5AF5);
Color darkmodeback = Color.fromARGB(255, 2, 7, 22);
Color darkmodeback2 = Color.fromARGB(255, 30, 29, 29);
void getSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? white
              : darkcolor,
        ),
      ),
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark ? purple : bluecolor,
      // Optionnel: couleur de fond
    ),
  );
}

Widget getcircularprogress(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
      color:
          Theme.of(context).brightness == Brightness.dark ? purple : bluecolor,
    ),
  );
}
