import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:manyas_v2/Post/repository/firebase_storage_api.dart';

class FirebaseStorageRepository{
  final _firebaseStorageAPI = FirebaseStorageAPI();
  Future<StorageUploadTask> uploadFile(String path, File image) => _firebaseStorageAPI.uploadFile(path, image);
  Future<void> deleteFile(String path) => _firebaseStorageAPI.deleteFile(path);
}