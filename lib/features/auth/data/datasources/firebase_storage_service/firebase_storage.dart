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
    String extension = path.extension(file.path);
    Reference ref = _firebaseStorage.ref(folder).child('$fileName$extension');
    await ref.putFile(file);
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<List<String>> uploadFiles(List<File> files, String folder) async {
    Reference reference = _firebaseStorage.ref(folder);
    List<String> urls = [];
    String baseFileName = Timestamp.now().microsecondsSinceEpoch.toString();

    for (int i = 0; i < files.length; i++) {
      File file = files[i];
      String extension = path.extension(file.path);
      String fileName = '$baseFileName${i + 1}$extension';
      Reference newRef = reference.child(fileName);
      await newRef.putFile(file);
      String url = await newRef.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  Future<void> deleteFileByUrl(String url) async {
    Reference reference = _firebaseStorage.refFromURL(url);
    await reference.delete();
  }
}
