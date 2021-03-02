import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageAPI {
  final StorageReference _storageReference = FirebaseStorage.instance.ref();

  Future<StorageUploadTask> uploadFile(String path, File image) async {
    return _storageReference.child(path).putFile(image);
  }

  Future<void> deleteFile(String path) async {
    print('path $path');
    await FirebaseStorage.instance.getReferenceFromUrl(path).then((reference) {
      reference.delete().then((value) => print('se borró el file de Storage'));
    }).catchError((e) => print('Error deleteFile $e'));
  }
}
