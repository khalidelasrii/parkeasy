import 'package:parkeasy/features/auth/data/datasources/firebase_auth_service/firebase_auth_service.dart';
import 'package:parkeasy/features/auth/data/datasources/firebase_firestor_service/firebase_firestor_service.dart';
import 'package:parkeasy/features/auth/data/datasources/firebase_storage_service/firebase_storage.dart';

abstract class FirebaseServices {
  FirebaseAuthService get firebaseAuthService;
  FirebaseFirestoreService get firebaseFirestorService;

  FirebaseStorageService get firebaseStorageService;
}

class FirebaseServicesImpl implements FirebaseServices {
  @override
  final FirebaseAuthService firebaseAuthService;
  @override
  final FirebaseFirestoreService firebaseFirestorService;
  @override
  final FirebaseStorageService firebaseStorageService;
  FirebaseServicesImpl({
    required this.firebaseStorageService,
    required this.firebaseAuthService,
    required this.firebaseFirestorService,
  });
}
