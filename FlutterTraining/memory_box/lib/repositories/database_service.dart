import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memory_box/models/playlist_model.dart';
import 'package:memory_box/models/tale_model.dart';
import 'package:memory_box/models/user_model.dart';
import 'package:memory_box/repositories/storage_service.dart';
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
    required TaleModel taleModel,
  }) async {
    String? uid = AuthService.userID;

    await _talesCollection
        .doc(uid)
        .collection('allTales')
        .doc(taleModel.ID)
        .set(taleModel.toMap());
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

  Future<List<TaleModel>?> getFewTaleModels({
    required List<String>? taleIDs,
  }) async {
    if (taleIDs?.isEmpty ?? true) return null;

    List<TaleModel> listTaleModels = [];

    String? uid = AuthService.userID;

    final documentSnapshot =
        _talesCollection.doc(uid).collection('allTales').where(
              'taleID',
              whereIn: taleIDs,
            );

    QuerySnapshot<Map<String, dynamic>> taleCollection =
        await documentSnapshot.get();

    taleCollection.docs.forEach((e) {
      listTaleModels.add(
        TaleModel.fromJson(
          e.data(),
        ),
      );
    });
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

  Future<List<TaleModel>> getAllDeletedTaleModels() async {
    List<TaleModel> listTaleModels = [];

    final String? uid = AuthService.userID;

    final querySnapshot = await _talesCollection
        .doc(uid)
        .collection('allTales')
        .where(
          'isDeleted.status',
          isEqualTo: true,
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

  Future<void> setTaleDeleteStatus(String taleID) async {
    String? uid = AuthService.userID;

    await _talesCollection.doc(uid).collection('allTales').doc(taleID).update({
      'isDeleted': {
        'deleteDate': DateTime.now(),
        'status': true,
      }
    });
  }

  Future<void> finalDeleteTaleRecord(String taleID) async {
    String? uid = AuthService.userID;

    await _talesCollection.doc(uid).collection('allTales').doc(taleID).delete();
    await StorageService.instance.deleteTale(
      taleID: taleID,
    );
  }

  Future<int> calculateTalesInMS(List<String>? taleIDs) async {
    int sumTimeInMS = 0;
    String? uid = AuthService.userID;

    QuerySnapshot<Map<String, dynamic>> documentSnapshot =
        await _talesCollection
            .doc(uid)
            .collection('allTales')
            .where(
              'taleID',
              whereIn: taleIDs,
            )
            .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> e
        in documentSnapshot.docs) {
      Map<String, dynamic> data = e.data();
      sumTimeInMS += data['durationInMS'] as int;
    }
    print(sumTimeInMS);
    return sumTimeInMS;
  }
  //??[End] Tale

  //??[Start] PlayList
  Future<void> createPlaylist({
    required String playlistID,
    required String title,
    String? description,
    List<String>? talesIDs,
    required String coverUrl,
  }) async {
    String? uid = AuthService.userID;
    int tilesSumDurationInMs = await calculateTalesInMS(talesIDs);

    Map<String, dynamic> collection = {
      'ID': playlistID,
      'title': title,
      'description': description,
      'taleIDsList': talesIDs,
      'tilesSumDurationInMs': tilesSumDurationInMs,
      'coverUrl': coverUrl,
    };

    await _playListsCollection
        .doc(uid)
        .collection('allPlaylists')
        .doc(playlistID)
        .set(collection);
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
    if (talesIDs != null) collection?['taleIDsList'] = talesIDs;

    await _playListsCollection.doc(uid).update({playListID: collection});
  }

//! переделать
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

    collection?[playListID]['taleIDsList'] = tilesIDSList;

    await _playListsCollection.doc(uid).update({
      playListID: collection?[playListID],
    });
  }

  Future<void> addOneTaleToFewPlaylist({
    required String taleID,
    required List<String> playListIDs,
  }) async {
    String? uid = AuthService.userID;

    for (String playListID in playListIDs) {
      await _playListsCollection
          .doc(uid)
          .collection('allPlaylists')
          .doc(playListID)
          .update({
        'taleIDsList': FieldValue.arrayUnion([
          taleID.toString(),
        ])
      });
    }
  }

//! переделать
  Future<void> removeTalesFromPlayList({
    required String playListID,
    required List<String> talesIDs,
  }) async {
    String? uid = AuthService.userID;

    DocumentSnapshot documentSnapshot =
        await _playListsCollection.doc(uid).get();

    Map<String, dynamic>? collection =
        documentSnapshot.data() as Map<String, dynamic>?;

    List<dynamic>? tilesIDSList = collection?[playListID]['taleIDsList'] ?? [];
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

  Future<TaleModel?> getPlayList({
    required String playListID,
  }) async {
    String? uid = AuthService.userID;

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _playListsCollection
            .doc(uid)
            .collection('allPlaylists')
            .doc(playListID)
            .get();

    Map<String, dynamic>? result = documentSnapshot.data();
    if (result != null) {
      return TaleModel.fromJson(result);
    }
  }

  Future<List<PlaylistModel>> getAllPlayList() async {
    List<PlaylistModel> playListModels = [];
    String? uid = AuthService.userID;

    QuerySnapshot<Map<String, dynamic>> documentSnapshots =
        await _playListsCollection.doc(uid).collection('allPlaylists').get();

    documentSnapshots.docs.forEach((doc) {
      playListModels.add(
        PlaylistModel.fromJson(doc.data()),
      );
    });

    return playListModels;
  }

//! переделать
  Future<void> deletePlayList({
    required String playListID,
  }) async {
    String? uid = AuthService.userID;

    await _playListsCollection.doc('$uid/$playListID').delete();
  }

  // getTaleModel({String taleID}) {}
  //??[END] PlayList
}
