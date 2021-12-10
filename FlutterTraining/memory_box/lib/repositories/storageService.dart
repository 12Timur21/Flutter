import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum FileType {
  sound,
  file,
  avatar,
}

class StorageService {
  static final FirebaseStorage _cloud = FirebaseStorage.instance;
  const StorageService._();
  static const StorageService instance = StorageService._();

  String mapDestination({
    required FileType fileType,
    String? uid,
    String? fileName,
  }) {
    String destination = '';
    String src = '';
    if (fileType == FileType.file) destination = 'files';
    if (fileType == FileType.sound) destination = 'audiofiles';
    if (fileType == FileType.avatar) destination = 'avatars';

    if (uid != null) src = '$destination/$uid';
    if (fileName != null) src = '$destination/$fileName';
    if (uid == null && fileName == null) src = destination;
    if (uid != null && fileName != null) src = '$destination/$uid/$fileName';

    return src;
  }

  Future<int> filesLength({
    required FileType fileType,
    required String uid,
  }) async {
    final destination = mapDestination(
      fileType: fileType,
      uid: uid,
    );
    ListResult listResult = await _cloud.ref().child(destination).listAll();

    return listResult.items.length;
  }

  Future<bool> isFileExist({
    required FileType fileType,
    required String fileName,
    required String uid,
  }) async {
    final destination = mapDestination(
      fileType: fileType,
      uid: uid,
      fileName: fileName,
    );

    String fileUrl = await _cloud
        .ref()
        .child(
          destination,
        )
        .getDownloadURL();

    if (fileUrl.isNotEmpty) return true;
    return false;
  }

  Future<String> getFileUrl({
    required FileType fileType,
    String? uid,
    required String fileName,
  }) async {
    final destination = mapDestination(
      fileType: fileType,
      uid: uid,
      fileName: fileName,
    );

    String downloadUrl = await _cloud
        .ref()
        .child(
          destination,
        )
        .getDownloadURL();

    return downloadUrl;
  }

  Future<void> uploadFile({
    required File file,
    required FileType fileType,
    required String fileName,
    String? uid,
  }) async {
    final destination = mapDestination(
      fileType: fileType,
      uid: uid,
      fileName: fileName,
    );

    try {
      print('--error--');
      print(destination);
      print(file.length());
      _cloud.ref().child('/$destination').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  void dispose() {}
}
