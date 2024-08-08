import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parkeasy/core/exeption/auth_exeption.dart';
import 'package:parkeasy/features/auth/data/models/user_model.dart';

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
      return UserModel.fromJson(docSnapshot.data()!);
    } catch (e) {
      throw AuthException('Error fetching user data: $e');
    }
  }

  Future<UserModel> createUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());

      return await getUserData(user.id!);
    } catch (e) {
      throw AuthException('Error creating user data: $e');
    }
  }

  Future<UserModel> updateUserInfo(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .update(user.jsonUpdatUserInfo());
      return await getUserData(user.id!);
    } catch (e) {
      throw AuthException('Error updating user info: $e');
    }
  }


}
