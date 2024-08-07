import 'dart:ui';

import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/core/extension/lang_extenstion.dart';
import 'package:parkeasy/core/services/shared_pref_service.dart';

class LocalController {
  late Locale _currentLocal;
  VoidCallback? listenner;
  SharedPrefService sharedPrefService;

  LocalController({required this.sharedPrefService}) {
    String langCode = sharedPrefService.getValue(
        SharedPrefService.appLang, Langs.frensh.langCode);
    _currentLocal = Locale(langCode);
  }
  void removeListener() {
    listenner = null;
  }

  void changelang(Langs lang) {
    _currentLocal = Locale(lang.langCode);
    sharedPrefService.putValue(SharedPrefService.appLang, lang.langCode);
    listenner?.call();
  }

  void addListenner(VoidCallback listenner) {
    this.listenner = listenner;
  }

  Locale get currentLocal => _currentLocal;
}
