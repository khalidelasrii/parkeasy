import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/core/services/local_service/local_controller.dart';
import 'package:parkeasy/core/services/shared_pref_service.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/presentation/bloc/language_bloc/language_cubit.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/presentation/bloc/theme_bloc/theme_cubit.dart';
import 'package:parkeasy/firebase_options.dart';
import 'package:parkeasy/service_locator.dart' as di;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:parkeasy/app_localization.dart';
import 'package:parkeasy/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.debug);
  await di.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LanguageBloc()),
        BlocProvider(create: (_) => ThemeBloc()),
        BlocProvider(
            create: (_) => di.sl<AuthBloc>()..add(GetCurrentUserEvent())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late LocalController localController;

  @override
  void initState() {
    super.initState();
    _initializeLocalController();
  }

  Future<void> _initializeLocalController() async {
    final sharedPrefService = await SharedPrefService.initializeService();
    localController = LocalController(sharedPrefService: sharedPrefService);
    localController.addListenner(onLocalChange);
  }

  void onLocalChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'Parkeasy',
                  theme: themeState.themeData,
                  darkTheme: themeState.darkTheme,
                  themeMode: themeState.themeMode,
                  supportedLocales: const [
                    Locale('fr'),
                    Locale('en'),
                    Locale('ar'),
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
                  routerConfig: _getRouterConfig(context, state),
                );
              },
            );
          },
        );
      },
    );
  }

  RouterConfig<Object> _getRouterConfig(BuildContext context, AuthState state) {
    if (state.status == AppStatus.unknown && state.user == null) {
      return Routes.router..go(Routes.waitingPage);
    } else if (state.user != null) {
      switch (state.user?.accountStatus) {
        case AccountStatus.initial:
          return Routes.router..go(Routes.informationCompleteUser);
        case AccountStatus.pending:
        case AccountStatus.blocked:
          return Routes.router..go(Routes.registrationConfirmationPage);
        case AccountStatus.accepted:
          return Routes.router..go(Routes.mapPage);
        default:
          return Routes.router;
      }
    }
    return Routes.router..go(Routes.authPage);
  }

  @override
  void dispose() {
    localController.removeListener();
    super.dispose();
  }
}
