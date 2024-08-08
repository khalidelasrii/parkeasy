import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _firebaseStorage;

  FirebaseStorageService({FirebaseStorage? firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  static const String profilesFolderName = 'profiles';
  static const String documentsFolderName = 'documents';

  Future<String?> uploadFile(File file, String folder, String fileName) async {
    try {
      String extension = path.extension(file.path);
      Reference ref = _firebaseStorage.ref(folder).child('$fileName$extension');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<List<String>> uploadFiles(List<File> files, String folder) async {
    List<String> urls = [];
    String baseFileName = Timestamp.now().microsecondsSinceEpoch.toString();

    for (int i = 0; i < files.length; i++) {
      try {
        File file = files[i];
        String extension = path.extension(file.path);
        String fileName = '$baseFileName${i + 1}$extension';
        Reference newRef = _firebaseStorage.ref(folder).child(fileName);
        await newRef.putFile(file);
        urls.add(await newRef.getDownloadURL());
      } catch (e) {
        print('Error uploading file $i: $e');
        rethrow;
      }
    }
    return urls;
  }

  Future<void> deleteFileByUrl(String url) async {
    try {
      Reference reference = _firebaseStorage.refFromURL(url);
      await reference.delete();
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
}
