import 'package:parkeasy/features/auth/data/datasources/firebase_auth_service/firebase_auth_service.dart';
import 'package:parkeasy/features/auth/data/datasources/firebase_firestor_service/firebase_firestor_service.dart';

abstract class FirebaseServices {
  FirebaseAuthService get firebaseAuthService;
  FirebaseFirestorService get firebaseFirestorService;
}

class FirebaseServicesImpl implements FirebaseServices {
  @override
  final FirebaseAuthService firebaseAuthService;
  @override
  final FirebaseFirestorService firebaseFirestorService;

  FirebaseServicesImpl({
    required this.firebaseAuthService,
    required this.firebaseFirestorService,
  });
}