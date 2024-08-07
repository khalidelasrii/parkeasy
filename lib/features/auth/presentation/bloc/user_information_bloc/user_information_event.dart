import 'dart:io';

abstract class UserInformationEvent {}

class PickImage extends UserInformationEvent {}

class UploadImage extends UserInformationEvent {
  final File imageFile;
  UploadImage(this.imageFile);
}

class SaveUserInfo extends UserInformationEvent {
  final String name;
  final File? imageFile;
  SaveUserInfo({required this.name, this.imageFile});
}