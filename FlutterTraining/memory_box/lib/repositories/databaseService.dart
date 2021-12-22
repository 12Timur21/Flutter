import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memory_box/models/userModel.dart';
import 'package:uuid/uuid.dart';

import 'authService.dart';

class DatabaseService {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DatabaseService._();
  static DatabaseService instance = DatabaseService._();

  //**[Start] Refs
  final CollectionReference _userCollection = _firestore.collection('users');
  final CollectionReference _playListsCollection =
      _firestore.collection('playLists');
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
