import 'dart:io';

abstract class UserInformationState {}

class UserInformationInitial extends UserInformationState {}

class Loading extends UserInformationState {}

class ImagePicked extends UserInformationState {
  final File imageFile;
  ImagePicked(this.imageFile);
}

class ImageUploaded extends UserInformationState {
  final String imageUrl;
  ImageUploaded(this.imageUrl);
}

class UserInfoSaved extends UserInformationState {}

class Error extends UserInformationState {
  final String message;
  Error(this.message);
}