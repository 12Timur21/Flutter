import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/models/user_model.dart';
import 'package:uuid/uuid.dart';

import 'auth_service.dart';

class DatabaseService {
  static FirebaseFirestore _firebase = FirebaseFirestore.instance;
  DatabaseService._();
  static DatabaseService instance = DatabaseService._();

  //**[Start] Refs
  final CollectionReference _userCollection = _firebase.collection('users');
  final CollectionReference _talesCollection = _firebase.collection('tales');
  final CollectionReference _playListsCollection =
      _firebase.collection('playLists');
  //**[Start] Refs

  //??[Start] User
  Future<bool> isUserExist() async {
    String? uid = AuthService.userID;
    DocumentSnapshot<Object?> document = await _userCollection.doc(uid).get();
    return document.exists;
  }

  Future<void> recordNewUser(UserModel user) async {
    await _userCollection.doc(user.uid).set(user.toJson());
  }

  Future<void> updateUserCollection({
    String? phoneNumber,
    String? displayName,
  }) async {
    Map<String, dynamic> updatedPair = {};

    if (phoneNumber != null && phoneNumber != '') {
      updatedPair['phoneNumber'] = phoneNumber;
    }
    if (displayName != null && displayName != '') {
      updatedPair['displayName'] = displayName;
    }

    await _userCollection.doc(AuthService.userID).update(updatedPair);
  }

  Future<void> deleteUserFromFirebase() async {
    String? uid = AuthService.userID;

    await _userCollection.doc(uid).delete();
  }

  Future<UserModel?> userModelFromDatabase() async {
    String? uid = AuthService.userID;
    if (uid != null) {
      DocumentSnapshot<Object?> result = await _userCollection.doc(uid).get();
      return UserModel.fromJson(result.data() as Map<String, dynamic>);
    }
    return null;
  }
  //??[End] User

  //??[Start] Tale

  Future<void> createTale({
    required String taleID,
    required String title,
    required Duration duration,
    String? taleUrl,
  }) async {
    String? uid = AuthService.userID;

    Map<String, dynamic> taleCollection = {
      'taleID': taleID,
      'title': title,
      'durationInMS': duration.inMilliseconds,
      'isDeleted': false,
      'taleUrl': taleUrl,
    };

    DocumentSnapshot documentSnapshot = await _talesCollection.doc(uid).get();
    if (documentSnapshot.exists) {
      await _talesCollection.doc(uid).update({taleID: taleCollection});
    } else {
      await _talesCollection.doc(uid).set({taleID: taleCollection});
    }
  }

  Future<void> updateTaleData({
    required String taleID,
    String? title,
    bool? isDeleted,
  }) async {
    String? uid = AuthService.userID;
    final documentSnapshot = await _talesCollection.doc(uid).get();

    Map<String, dynamic>? taleCollection =
        documentSnapshot.data() as Map<String, dynamic>?;

    taleCollection = taleCollection?[taleID];

    if (title != null) taleCollection?['title'] = title;
    if (isDeleted != null) taleCollection?['isDeleted'] = isDeleted;

    await _talesCollection.doc(uid).update({taleID: taleCollection});
  }

  Future<TaleModel> getTaleModel({
    required String taleID,
  }) async {
    TaleModel taleModel = TaleModel();

    String? uid = AuthService.userID;
    final documentSnapshot = await _talesCollection.doc(uid).get();

    Map<String, dynamic>? taleCollection =
        documentSnapshot.data() as Map<String, dynamic>?;

    taleCollection = taleCollection?[taleID];

    taleModel.duration = Duration(
      milliseconds: taleCollection?['durationInMS'],
    );
    taleModel.title = taleCollection?['title'];
    taleModel.ID = taleID;
    taleModel.url = taleCollection?['taleUrl'];
    taleModel.isDeleted = taleCollection?['isDeleted'];

    return taleModel;
  }

  //List<TaleModel>
  Future<List<TaleModel>> getAllTaleModels() async {
    List<TaleModel> listTaleModels = [];

    String? uid = AuthService.userID;
    final documentSnapshot = await _talesCollection.doc(uid).get();

    Map<String, dynamic>? taleCollection =
        documentSnapshot.data() as Map<String, dynamic>?;

    taleCollection?.forEach((key, value) {
      listTaleModels.add(
        TaleModel(
          isDeleted: value['isDeleted'],
          ID: value['taleID'],
          duration: Duration(
            milliseconds: value['durationInMS'],
          ),
          title: value['title'],
          url: value['taleUrl'],
        ),
      );
    });
    return listTaleModels;
  }

  Future<List<TaleModel>> getFilteringTales(String taleTitle) async {
    List<TaleModel> listTaleModels = [];

    String? uid = AuthService.userID;
    final x = _talesCollection.doc(uid).collection('mas').orderBy('qqq');
    final z = await x.get();
    print(x);
    // final z = await _talesCollection.doc(uid).snapshots().forEach((element) {
    //   print(element);
    //   print(element.data());
    // });
    // print(z);

    //     .where(
    //       'qqq',
    //       isEqualTo: '222',
    //     )
    //     .get();
    // final data = z.docs.forEach((element) {
    //   print(element.data());
    // });
    // final x = await z;
    // x.docs.forEach((element) {
    //   print(element.data());
    // });
    // QuerySnapshot<Map<String, dynamic>> mp = await documentSnapshot.get();

    // mp.docChanges.map((e) => print(e.doc));

    return listTaleModels;
  }

  //??[End] Tale

  //??[Start] PlayList
  Future<void> createPlayList({
    required String playListID,
    required String title,
    String? description,
    List<String>? talesIDs,
  }) async {
    String? uid = AuthService.userID;

    Map<String, dynamic> collection = {
      'title': title,
      'description': description,
      'tilesIDSList': talesIDs,
    };

    DocumentSnapshot documentSnapshot =
        await _playListsCollection.doc(uid).get();
    if (!documentSnapshot.exists) {
      await _playListsCollection.doc(uid).set({playListID: collection});
    } else {
      await _playListsCollection.doc(uid).update({playListID: collection});
    }
  }

  Future<void> updatePlayList({
    required String playListID,
    String? title,
    String? description,
    List<String>? talesIDs,
  }) async {
    String? uid = AuthService.userID;

    DocumentSnapshot documentSnapshot =
        await _playListsCollection.doc(uid).get();

    Map<String, dynamic>? collection =
        documentSnapshot.data() as Map<String, dynamic>?;

    collection = collection?[playListID];

    if (title != null) collection?['title'] = title;
    if (description != null) collection?['description'] = description;
    if (talesIDs != null) collection?['talesIDs'] = talesIDs;

    await _playListsCollection.doc(uid).update({playListID: collection});
  }

  void addTalesToPlayList({
    required String playListID,
    required List<String> talesIDs,
  }) async {
    String? uid = AuthService.userID;

    DocumentSnapshot documentSnapshot =
        await _playListsCollection.doc(uid).get();

    Map<String, dynamic>? collection =
        documentSnapshot.data() as Map<String, dynamic>?;

    List<dynamic>? tilesIDSList = collection?[playListID]['tilesIDSList'] ?? [];
    tilesIDSList?..addAll(talesIDs);

    collection?[playListID]['tilesIDSList'] = tilesIDSList;

    await _playListsCollection.doc(uid).update({
      playListID: collection?[playListID],
    });
  }

  Future<void> removeTalesFromPlayList({
    required String playListID,
    required List<String> talesIDs,
  }) async {
    String? uid = AuthService.userID;

    DocumentSnapshot documentSnapshot =
        await _playListsCollection.doc(uid).get();

    Map<String, dynamic>? collection =
        documentSnapshot.data() as Map<String, dynamic>?;

    List<dynamic>? tilesIDSList = collection?[playListID]['tilesIDSList'] ?? [];
    tilesIDSList?.removeWhere((element) {
      for (String item in talesIDs) {
        if (item == element) return true;
      }
      return false;
    });

    collection?[playListID]['tilesIDSList'] = tilesIDSList;

    await _playListsCollection.doc(uid).update({
      playListID: collection?[playListID],
    });
  }

  Future<Map<String, dynamic>?> getPlayList({
    required String playListID,
  }) async {
    String? uid = AuthService.userID;

    DocumentSnapshot documentSnapshot =
        await _playListsCollection.doc(uid).get();

    Map<String, dynamic>? collection =
        documentSnapshot.data() as Map<String, dynamic>?;

    return collection?[playListID];
  }

  Future<void> deletePlayList({
    required String playListID,
  }) async {
    String? uid = AuthService.userID;

    await _playListsCollection.doc('$uid/$playListID').delete();
  }
  //??[END] PlayList
}
