import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'user_information_event.dart';
import 'user_information_state.dart';

class UserInformationBloc extends Bloc<UserInformationEvent, UserInformationState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');
  final ImagePicker _picker = ImagePicker();

  UserInformationBloc() : super(UserInformationInitial()) {
    on<PickImage>(_onPickImage);
    on<UploadImage>(_onUploadImage);
    on<SaveUserInfo>(_onSaveUserInfo);
  }

  Future<void> _onPickImage(PickImage event, Emitter<UserInformationState> emit) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(ImagePicked(File(pickedFile.path)));
    }
  }

  Future<void> _onUploadImage(UploadImage event, Emitter<UserInformationState> emit) async {
    emit(Loading());
    try {
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${_auth.currentUser!.uid}.png');

      await storageRef.putFile(event.imageFile);
      final String imageUrl = await storageRef.getDownloadURL();

      await _usersCollection.doc(_auth.currentUser!.uid).update({
        'imageUser': imageUrl,
      });

      emit(ImageUploaded(imageUrl));
    } catch (error) {
      emit(Error('Error uploading image: $error'));
    }
  }

  Future<void> _onSaveUserInfo(SaveUserInfo event, Emitter<UserInformationState> emit) async {
    emit(Loading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(Error('User not found'));
        return;
      }

      final name = event.name.isEmpty ? 'User' : event.name;
      await _usersCollection.doc(user.uid).update({'name_user': name});

      if (event.imageFile != null) {
        add(UploadImage(event.imageFile!));
      }

      emit(UserInfoSaved());
    } catch (e) {
      emit(Error(e.toString()));
    }
  }
}