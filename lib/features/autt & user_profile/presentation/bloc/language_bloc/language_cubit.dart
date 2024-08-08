import 'package:flutter_bloc/flutter_bloc.dart';

part 'language_state.dart';

class LanguageBloc extends Cubit<LanguageState> {
  LanguageBloc() : super(LanguageState(selectedLanguage: 'en'));

  void changeLanguage(String languageCode) {
    emit(LanguageState(selectedLanguage: languageCode));
  }
}