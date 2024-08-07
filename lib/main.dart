import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkeasy/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:parkeasy/features/auth/presentation/bloc/language_bloc/language_cubit.dart';
import 'package:parkeasy/features/auth/presentation/bloc/theme_bloc/theme_cubit.dart';
import 'package:parkeasy/firebase_options.dart';
import 'package:parkeasy/service_locator.dart' as di;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parkeasy/app_localization.dart';
import 'package:parkeasy/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LanguageBloc>(create: (context) => LanguageBloc()),
        BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
        BlocProvider<AuthBloc>(create: (context) => di.sl<AuthBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Parkeasy',
              theme: themeState.themeData,
              darkTheme: themeState.darkTheme,
              themeMode: themeState.themeMode,
              supportedLocales: const [
                Locale('fr'),
                Locale('en'),
                Locale('ar')
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: Locale(languageState.selectedLanguage),
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (deviceLocale != null &&
                      deviceLocale.languageCode == locale.languageCode) {
                    return deviceLocale;
                  }
                }
                return supportedLocales.first;
              },
              routerConfig: Routes.router,
            );
          },
        );
      },
    );
  }
}
