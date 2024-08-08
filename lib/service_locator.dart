import 'package:get_it/get_it.dart';
import 'package:parkeasy/core/services/shared_pref_service.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/data/datasources/firebase_auth_service/firebase_auth_service.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/data/datasources/firebase_firestor_service/firebase_firestor_service.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/data/datasources/firebase_services.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/data/datasources/firebase_storage_service/firebase_storage.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/data/repositories/auth_repository_impl.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/repositories/auth_repository.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/usecases/get_courent_user_use_case.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/usecases/save_user_info_use_case.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/usecases/signIn_with_google_use_case.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/usecases/sign_in_with_phone_use_case.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/usecases/sing_out_use_case.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/usecases/verification_o_t_p_use_case.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:parkeasy/features/map/data/repositories/location_repository_impl.dart';
import 'package:parkeasy/features/map/data/repositories/parking_repository_impl.dart';
import 'package:parkeasy/features/map/domain/repositories/location_repository.dart';
import 'package:parkeasy/features/map/domain/repositories/parking_repository.dart';
import 'package:parkeasy/features/map/domain/usecases/get_current_location_use_case.dart';
import 'package:parkeasy/features/map/domain/usecases/get_nearby_parkings_use_case.dart';
import 'package:parkeasy/features/map/presentation/bloc/map_bloc/map_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final sharedPrefService = SharedPrefService(sharedPreferences);

  sl.registerLazySingleton<SharedPrefService>(() => sharedPrefService);

  // Register Firebase services --------------------------------------------------------------
  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  sl.registerLazySingleton<FirebaseFirestoreService>(
      () => FirebaseFirestoreService());
  sl.registerLazySingleton<FirebaseStorageService>(
      () => FirebaseStorageService());

  // Register Firebase services implementation ------------------------------------------------------
  sl.registerLazySingleton<FirebaseServices>(
    () => FirebaseServicesImpl(
      firebaseStorageService: sl<FirebaseStorageService>(),
      firebaseAuthService: sl<FirebaseAuthService>(),
      firebaseFirestorService: sl<FirebaseFirestoreService>(),
    ),
  );

  // Register repositories -----------------------------------------------------------------------------
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseServices: sl<FirebaseServices>()),
  );
  sl.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl());
  sl.registerLazySingleton<ParkingRepository>(() => ParkingRepositoryImpl());

  // Register use cases ------------------------------------------------------------------------------
  //! auth features
  sl.registerLazySingleton(() => SignInWithPhoneUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerificationOTPUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SingOutUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SaveUserInfoUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCourentUserUseCase(sl<AuthRepository>()));
  //! Map features
  sl.registerLazySingleton(() => GetCurrentLocationUseCase(sl()));
  sl.registerLazySingleton(() => GetNearbyParkingsUseCase(sl()));

  // Register BLoC --------------------------------------------------------------------------------------
  //! auth features
  sl.registerFactory(() => AuthBloc(
      getCurrentUserUseCase: sl(),
      signInWithGoogleUseCase: sl(),
      signInWithPhoneUseCase: sl(),
      verificationOTPEvent: sl(),
      singOutUseCase: sl(),
      saveUserInfoUseCase: sl()));
  //! Map features

  sl.registerFactory(() => MapBloc(
      getCurrentLocationUseCase: sl(),
      getNearbyParkingsUseCase: sl(),
      sharedPrefService: sl<SharedPrefService>()));
}
