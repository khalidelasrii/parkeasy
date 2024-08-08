import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/core/exeption/auth_exeption.dart';
import 'package:parkeasy/core/extension/acount_status.dart';
import 'package:parkeasy/features/auth/data/models/user_model.dart';
import 'package:parkeasy/features/auth/domain/entities/user_entity.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore;

  FirebaseFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<bool> checkUserExists(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      return docSnapshot.exists;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (!docSnapshot.exists) {
        throw AuthException('User does not exist');
      }
      return UserModel.fromUserEntity(UserEntity.fromJson(docSnapshot.data()!));
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

  Future<UserModel> updateUserInfo(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toJson());
      return await getUserData(user.id!);
    } catch (e) {
      rethrow;
    }
  }

  Stream<AccountStatus?> getAccountStatusStream(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final statusString = snapshot.data()?["accountStatus"];
        return AccountStatusExtension.fromString(statusString);
      } else {
        return null;
      }
    });
  }
}
