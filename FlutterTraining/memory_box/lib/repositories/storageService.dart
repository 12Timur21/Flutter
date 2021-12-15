import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memory_box/repositories/databaseService.dart';
import 'package:uuid/uuid.dart';

enum FileType {
  sound,
  file,
  avatar,
}

class StorageService {
  static final FirebaseStorage _cloud = FirebaseStorage.instance;
  StorageService._();
  static StorageService instance = StorageService._();

  DatabaseService _databaseService = DatabaseService.instance;

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
    required String userUID,
  }) async {
    String fileUID = Uuid().v4();

    final destination = mapDestination(
      fileType: fileType,
      uid: userUID,
      fileName: fileUID,
    );

    try {
      _cloud.ref().child('/$destination').putFile(file);
      _databaseService.addSoundToUserCollection(
        uid: userUID,
        soundTitle: fileName,
        soundUID: fileUID,
      );
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  // Future<void> updateSoundTitle({
  //   required String newName,
  //   required String oldName,
  //   required String userUID,
  // }) {}

  void dispose() {}
}
