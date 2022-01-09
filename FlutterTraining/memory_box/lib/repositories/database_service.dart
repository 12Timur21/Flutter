import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memory_box/models/play_list_model.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/models/user_model.dart';
import 'auth_service.dart';

class DatabaseService {
  static final FirebaseFirestore _firebase = FirebaseFirestore.instance;
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
      'isDeleted': {
        'status': false,
        'deleteDate': null,
      },
      'taleUrl': taleUrl,
      'searchKey': title.toLowerCase(),
    };

    await _talesCollection
        .doc(uid)
        .collection('allTales')
        .doc(taleID)
        .set(taleCollection);
  }

  Future<void> updateTaleData({
    required String taleID,
    String? title,
    bool? isDeleted,
  }) async {
    String? uid = AuthService.userID;
    final documentSnapshot = await _talesCollection
        .doc(uid)
        .collection('allTales')
        .doc(taleID)
        .get();

    Map<String, dynamic>? taleCollection = documentSnapshot.data();

    if (title != null) {
      taleCollection?['title'] = title;
      taleCollection?['searchKey'] = title.toLowerCase();
    }
    if (isDeleted != null) taleCollection?['isDeleted'] = isDeleted;

    if (taleCollection != null) {
      await _talesCollection
          .doc(uid)
          .collection('allTales')
          .doc(taleID)
          .update(taleCollection);
    }
  }

  // Future<TaleModel> getTaleModel({
  //   required String taleID,
  // }) async {
  //   String? uid = AuthService.userID;
  //   final documentSnapshot = await _talesCollection
  //       .doc(uid)
  //       .collection('allTales')
  //       .doc(taleID)
  //       .get();

  //   Map<String, dynamic>? tale = documentSnapshot.data();

  //   return TaleModel(
  //     ID: tale?['taleID'],
  //     title: tale?['title'],
  //     url: tale?['taleUrl'],
  //     isDeleted: tale?['isDeleted'],
  //     duration: Duration(
  //       milliseconds: tale?['durationInMS'],
  //     ),
  //   );
  // }

  Future<List<TaleModel>> getFewTaleModels({
    required List<String> taleIDs,
  }) async {
    List<TaleModel> listTaleModels = [];

    String? uid = AuthService.userID;

    final documentSnapshot =
        _talesCollection.doc(uid).collection('allTales').where(
              'taleID',
              whereIn: taleIDs,
            );

    QuerySnapshot<Map<String, dynamic>> taleCollection =
        await documentSnapshot.get();

    print(taleCollection.docs.length);
    final value = taleCollection.docs.map((e) {
      print(e.data());
    });

    // listTaleModels.add(
    //   TaleModel(
    //     isDeleted: value['isDeleted'],
    //     ID: value['taleID'],
    //     duration: Duration(
    //       milliseconds: value['durationInMS'],
    //     ),
    //     title: value['title'],
    //     url: value['taleUrl'],
    //   ),
    // );

    // print(listTaleModels);
    return listTaleModels;
  }

  Future<List<TaleModel>> getAllNotDeletedTaleModels() async {
    List<TaleModel> listTaleModels = [];

    final String? uid = AuthService.userID;

    final querySnapshot = await _talesCollection
        .doc(uid)
        .collection('allTales')
        .where(
          'isDeleted.status',
          isEqualTo: false,
        )
        .get();

    Map<int, QueryDocumentSnapshot<Map<String, dynamic>>> resultMap =
        querySnapshot.docs.asMap();

    resultMap.forEach((index, value) {
      listTaleModels.add(
        TaleModel.fromJson(
          value.data(),
        ),
      );
    });

    return listTaleModels;
  }

  Future<List<TaleModel>> searchTalesByTitle({String? title}) async {
    title ??= '';
    List<TaleModel> listTaleModels = [];

    final String? uid = AuthService.userID;

    final querySnapshot = await _talesCollection
        .doc(uid)
        .collection('allTales')
        .where(
          'isDeleted.status',
          isEqualTo: false,
        )
        .where('searchKey', isGreaterThanOrEqualTo: title.toLowerCase())
        .where(
          'searchKey',
          isLessThanOrEqualTo: title.toLowerCase() + '\uf8ff',
        )
        .get();

    Map<int, QueryDocumentSnapshot<Map<String, dynamic>>> resultMap =
        querySnapshot.docs.asMap();

    resultMap.forEach((index, value) {
      listTaleModels.add(
        TaleModel.fromJson(
          value.data(),
        ),
      );
    });

    return listTaleModels;
  }

  // Future<List<TaleModel>> searchTalesByTitle(String taleTitle) async {
  //   List<TaleModel> listTaleModels = [];

  //   //!учитывать регистр
  //   String? uid = AuthService.userID;
  //   final collectionReference = _talesCollection
  //       .doc(uid)
  //       .collection('allTales')
  // .where('title', isGreaterThanOrEqualTo: taleTitle)
  // .where(
  //   'title',
  //   isLessThanOrEqualTo: taleTitle + '\uf8ff',
  // );

  //   final snapshot = await collectionReference.get();

  //   snapshot.docs.asMap().forEach(
  //     (key, value) {
  //       listTaleModels.add(
  //         TaleModel(
  //           isDeleted: value['isDeleted'],
  //           ID: value['taleID'],
  //           duration: Duration(
  //             milliseconds: value['durationInMS'],
  //           ),
  //           title: value['title'],
  //           url: value['taleUrl'],
  //         ),
  //       );
  //     },
  //   );
  //   return listTaleModels;
  // }

  // Future<List<TaleModel>> getDeletedTales() async {
  //   List<TaleModel> taleModelList = [];

  //   QuerySnapshot<Map<String, dynamic>> queryShapshot = await _talesCollection
  //       .doc('G5oxe9UbVHa25WsbrLEsuTPscUp2')
  //       .collection('allTales')
  //       .where(
  //         'isDeleted.status',
  //         isEqualTo: true,
  //       )
  //       .get();

  //   queryShapshot.docs.asMap().forEach((_, value) {
  //     taleModelList.add(
  //       TaleModel.fromQueryDocumentSnapshot(value),
  //     );
  //   });

  //   return taleModelList;
  // }

  // z.map((element) {
  //   element.docs.forEach((element) {
  //     TaleModel.fromJson(element.data());
  //   });
  // });
  // .map(TaleModel.toList);

  // QuerySnapshot<Map<String, dynamic>> snapshot =
  //     await collectionReference.get();

  // Map<int, QueryDocumentSnapshot<Map<String, dynamic>>> xcc =
  //     snapshot.docs.map((e) => {
  //       return
  //     });

  // print(xcc);

  // .forEach((key, value) {
  //   listTaleModels.add(
  //     TaleModel(
  //       isDeleted: value['isDeleted'],
  //       ID: value['taleID'],
  //       duration: Duration(
  //         milliseconds: value['durationInMS'],
  //       ),
  //       title: value['title'],
  //       url: value['taleUrl'],
  //     ),
  //   );
  // });
  Future<void> deleteTaleRecord(String taleID) async {
    String? uid = AuthService.userID;

    await _talesCollection.doc(uid).collection('allTales').doc(taleID).update({
      'isDeleted': {
        'deleteDate': DateTime.now(),
        'status': true,
      }
    });
  }
  //??[End] Tale

  //??[Start] PlayList
  Future<void> createPlayList({
    required String playListID,
    required String title,
    String? description,
    List<String>? talesIDs,
    required String coverUrl,
  }) async {
    String? uid = AuthService.userID;

    Map<String, dynamic> collection = {
      'title': title,
      'description': description,
      'tilesIDSList': talesIDs,
      'coverUrl': coverUrl,
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
    tilesIDSList?.addAll(talesIDs);

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

  Future<List<PlayListModel>> getAllPlayList() async {
    List<PlayListModel> playListModel = [];
    String? uid = AuthService.userID;

    DocumentSnapshot documentSnapshot =
        await _playListsCollection.doc(uid).get();

    Map<String, dynamic>? collection =
        documentSnapshot.data() as Map<String, dynamic>?;

    collection?.forEach((key, value) {
      playListModel.add(PlayListModel(
        coverUrl: value['coverUrl'],
        ID: value['key'],
        title: value['title'],
      ));
    });

    return playListModel;
  }

  Future<void> deletePlayList({
    required String playListID,
  }) async {
    String? uid = AuthService.userID;

    await _playListsCollection.doc('$uid/$playListID').delete();
  }

  // getTaleModel({String taleID}) {}
  //??[END] PlayList
}
