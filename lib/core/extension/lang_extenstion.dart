
import 'package:parkeasy/core/constant/enum.dart';

extension LangsExtension on Langs {
  String get langCode {
    switch (this) {
      case Langs.frensh:
        return 'fr';
      case Langs.english:
        return 'en';
      case Langs.arabic:
        return 'ar';
      default:
        return 'en';
    }
  }
}

extension LangsExtensionOnString on String {
  Langs get langCodeString {
    switch (this) {
      case 'fr':
        return Langs.frensh;
      case 'en':
        return Langs.english;
      case 'ar':
        return Langs.arabic;
      default:
        return Langs.english;
    }
  }
}
