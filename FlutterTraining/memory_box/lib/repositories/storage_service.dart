import 'dart:core';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:memory_box/models/tale_model.dart';

import 'package:memory_box/repositories/auth_service.dart';
import 'package:memory_box/repositories/database_service.dart';

enum FileType {
  tale,
  file,
  avatar,
  playListCover,
}

class StorageService {
  static final FirebaseStorage _cloud = FirebaseStorage.instance;
  StorageService._();
  static StorageService instance = StorageService._();

  final DatabaseService _database = DatabaseService.instance;

  String mapDestination({
    required FileType fileType,
    String? uid,
    String? fileName,
  }) {
    String destination = '';
    String src = '';
    if (fileType == FileType.file) destination = 'files';
    if (fileType == FileType.tale) destination = 'audiofiles';
    if (fileType == FileType.avatar) destination = 'avatars';
    if (fileType == FileType.playListCover) destination = 'playListCovers';

    if (uid != null) src = '$destination/$uid';
    if (fileName != null) src = '$destination/$fileName';
    if (uid == null && fileName == null) src = destination;
    if (uid != null && fileName != null) src = '$destination/$uid/$fileName';

    return src;
  }

  //??[Start] File

  Future<int> filesLength({
    required FileType fileType,
  }) async {
    final destination = mapDestination(
      fileType: fileType,
      uid: AuthService.userID,
    );
    ListResult listResult = await _cloud.ref().child(destination).listAll();

    return listResult.items.length;
  }

  Future<bool> isFileExist({
    required FileType fileType,
    required String fileName,
  }) async {
    final destination = mapDestination(
      fileType: fileType,
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
    required String fileName,
  }) async {
    final destination = mapDestination(
      fileType: fileType,
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

  // Future<void> uploadFile({
  //   required File file,
  //   required FileType fileType,
  //   String? fileName,
  // }) async {
  //   final destination = mapDestination(
  //     fileType: fileType,
  //     uid: AuthService.userID,
  //     fileName: fileNa
  //   );

  //   try {
  //     await _cloud.ref().child('/$destination').putFile(
  //           file,
  //         );
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  // }
  //??[End] File

  //??[Start] Tale

  Future<void> uploadTaleFIle({
    required File file,
    required TaleModel taleModel,
  }) async {
    final String destination = mapDestination(
      fileType: FileType.tale,
      uid: AuthService.userID,
      fileName: taleModel.ID,
    );

    try {
      await _cloud.ref().child('/$destination').putFile(file);

      String url = await _cloud.ref().child('/$destination').getDownloadURL();

      await _database.createTale(
        taleModel: taleModel.copyWith(
          url: url,
        ),
      );
    } on FirebaseException catch (_) {}
  }

  // Future<void> updateTaleTitle({
  //   required String taleID,
  //   required String newTitle,
  // }) async {
  //   final destination = mapDestination(
  //     fileType: FileType.tale,
  //     uid: AuthService.userID,
  //     fileName: taleID,
  //   );

  //   try {
  //     FullMetadata fullMetaData =
  //         await _cloud.ref().child('/$destination').getMetadata();
  //     Map<String, String>? customMetaData = fullMetaData.customMetadata;
  //     customMetaData?['title'] = newTitle;

  //     if (customMetaData != null) {
  //       await _cloud.ref().child('/$destination').updateMetadata(
  //             SettableMetadata(
  //               customMetadata: customMetaData,
  //             ),
  //           );
  //     }
  //   } catch (_) {}
  // }

  // Future<TaleModel> getTaleModel({
  //   required String taleID,
  // }) async {
  //   TaleModel taleModel = TaleModel();

  //   final destination = mapDestination(
  //     fileType: FileType.tale,
  //     uid: AuthService.userID,
  //     fileName: taleID,
  //   );

  //   try {
  //     String? url = await _cloud.ref().child('/$destination').getDownloadURL();

  //     FullMetadata fullMetaData =
  //         await _cloud.ref().child('/$destination').getMetadata();

  //     Map<String, dynamic>? customMetadata =
  //         fullMetaData.customMetadata as Map<String, dynamic>?;

  //     taleModel.duration = Duration(
  //       milliseconds: int.parse(
  //         customMetadata?['durationInMS'],
  //       ),
  //     );
  //     taleModel.title = customMetadata?['title'];
  //     taleModel.ID = taleID;
  //     taleModel.url = url;
  //   } catch (e) {
  //     print(e);
  //   }
  //   return taleModel;
  // }

  // Future<List<TaleModel?>> getAllTaleModels() async {
  //   final destination = mapDestination(
  //     fileType: FileType.tale,
  //     uid: AuthService.userID,
  //   );

  //   List<TaleModel> taleModels = [];

  //   try {
  //     ListResult listResult =
  //         await _cloud.ref().child('/$destination').listAll();

  //     String? url;
  //     FullMetadata fullMetadata;
  //     Map<String, dynamic>? customMetadata;

  //     for (Reference item in listResult.items) {
  //       TaleModel taleModel = TaleModel();

  //       url = await item.getDownloadURL();
  //       fullMetadata = await item.getMetadata();
  //       customMetadata = fullMetadata.customMetadata;

  //       taleModel.duration = Duration(
  //         milliseconds: int.parse(
  //           customMetadata?['durationInMS'],
  //         ),
  //       );
  //       taleModel.title = customMetadata?['title'];
  //       taleModel.ID = customMetadata?['taleID'];
  //       taleModel.url = url;

  //       taleModels.add(taleModel);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }

  //   return taleModels;
  // }

  // Future<Map<String, String>?> getTaleMetadata({
  //   required String taleID,
  // }) async {
  //   final destination = mapDestination(
  //     fileType: FileType.tale,
  //     uid: AuthService.userID,
  //     fileName: taleID,
  //   );

  //   try {
  //     FullMetadata fullMetaData =
  //         await _cloud.ref().child('/$destination').list().
  //   } catch (_) {}
  // }

  Future<void> deleteTale({
    required String taleID,
  }) async {
    final destination = mapDestination(
      uid: AuthService.userID,
      fileName: taleID,
      fileType: FileType.tale,
    );

    await _cloud.ref().child('/$destination').delete();
  }

  //??[End] Tale

  //??[Start] PlayList
  Future<String> uploadPlayListCover({
    required File file,
    required String coverID,
  }) async {
    final destination = mapDestination(
      uid: AuthService.userID,
      fileName: coverID,
      fileType: FileType.playListCover,
    );

    await _cloud.ref().child('/$destination').putFile(file);
    return await _cloud.ref().child('/$destination').getDownloadURL();
  }

  Future<void> deletePlayListCover({
    required String coverID,
  }) async {
    final destination = mapDestination(
      uid: AuthService.userID,
      fileName: coverID,
      fileType: FileType.playListCover,
    );

    await _cloud.ref().child('/$destination').delete();
  }

  Future<void> getPlayListCoverURL({
    required String coverID,
  }) async {
    final destination = mapDestination(
      uid: AuthService.userID,
      fileName: coverID,
      fileType: FileType.playListCover,
    );

    await _cloud.ref().child('/$destination').getDownloadURL();
  }
  //??[End] PlayList
}
