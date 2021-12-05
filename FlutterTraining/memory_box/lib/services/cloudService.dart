import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum FileType {
  sound,
  file,
}

class CloudService {
  static final FirebaseStorage _cloud = FirebaseStorage.instance;
  const CloudService._();
  static const CloudService instance = CloudService._();

  void init() {
    // _cloud.
  }

  String mapDestination(FileType fileType) {
    String destination = '';
    if (fileType == FileType.file) destination = 'files';
    if (fileType == FileType.sound) destination = 'audiofiles';
    return destination;
  }

  Future<int> filesLength({
    required FileType fileType,
    required String uid,
  }) async {
    final destination = mapDestination(fileType);
    ListResult listResult = await _cloud
        .ref()
        .child(
          '$destination/$uid',
        )
        .listAll();

    return listResult.items.length;
  }

  Future<bool> isFileExist({
    required FileType fileType,
    required String fileName,
    required String uid,
  }) async {
    final destination = mapDestination(fileType);

    String fileUrl = await _cloud
        .ref()
        .child(
          '$destination/$uid/$fileName',
        )
        .getDownloadURL();

    if (fileUrl.isNotEmpty) return true;
    return false;
  }

  Future<String> getFileUrl({
    required FileType fileType,
    required String uid,
  }) async {
    final destination = mapDestination(fileType);

    String downloadUrl = await _cloud
        .ref()
        .child(
          '$destination/$uid',
        )
        .getDownloadURL();

    return downloadUrl;
  }

  Future<void> uploadFile({
    required File file,
    required FileType fileType,
    required String fileName,
    required String uid,
  }) async {
    final destination = mapDestination(fileType);

    try {
      _cloud.ref().child('$destination/$uid/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  void dispose() {}
}
