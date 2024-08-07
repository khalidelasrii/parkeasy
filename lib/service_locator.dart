import 'package:get_it/get_it.dart';
import 'package:parkeasy/features/auth/data/datasources/firebase_auth_service/firebase_auth_service.dart';
import 'package:parkeasy/features/auth/data/datasources/firebase_firestor_service/firebase_firestor_service.dart';
import 'package:parkeasy/features/auth/data/datasources/firebase_services.dart';
import 'package:parkeasy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:parkeasy/features/auth/domain/repositories/auth_repository.dart';
import 'package:parkeasy/features/auth/domain/usecases/signIn_with_google_use_case.dart';
import 'package:parkeasy/features/auth/domain/usecases/sign_in_with_phone_use_case.dart';
import 'package:parkeasy/features/auth/domain/usecases/sing_out_use_case.dart';
import 'package:parkeasy/features/auth/domain/usecases/verification_o_t_p_use_case.dart';
import 'package:parkeasy/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register Firebase services
  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  sl.registerLazySingleton<FirebaseFirestorService>(
      () => FirebaseFirestorService());

  // Register Firebase services implementation
  sl.registerLazySingleton<FirebaseServices>(
    () => FirebaseServicesImpl(
      firebaseAuthService: sl<FirebaseAuthService>(),
      firebaseFirestorService: sl<FirebaseFirestorService>(),
    ),
  );

  // Register repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseServices: sl<FirebaseServices>()),
  );

  // Register use cases
  sl.registerLazySingleton(() => SignInWithPhoneUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerificationOTPUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SingOutUseCase(sl<AuthRepository>()));

  // Register BLoC
  sl.registerFactory(() => AuthBloc(
      signInWithGoogleUseCase: sl(),
      signInWithPhoneUseCase: sl(),
      verificationOTPEvent: sl(),
      singOutUseCase: sl()));
}
