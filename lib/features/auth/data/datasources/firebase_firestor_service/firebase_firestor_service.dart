import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkeasy/core/exeption/auth_exeption.dart';
import 'package:parkeasy/features/auth/data/models/user_model.dart';
import 'package:parkeasy/features/auth/domain/entities/user_entity.dart';

class FirebaseFirestorService {
  final FirebaseFirestore _firestore;

  FirebaseFirestorService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserModel?> getUserData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        return UserModel.fromUserEntity(
            UserEntity.fromJson(docSnapshot.data()!));
      }
      return null;
    } catch (e) {
      throw AuthException('Error fetching user data: $e');
    }
  }

  Future<void> createUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
    } catch (e) {
      throw AuthException('Error creating user data: $e');
    }
  }
}
