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
  final CollectionReference _playlistsCollection =
      _firebase.collection('playlists');
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
        .set(
          taleModel.toJson(),
        );
  }

  Future<void> updateTale({
    required String taleID,
    String? title,
    bool? isDeleted,
  }) async {
    Map<String, dynamic> taleCollection = <String, dynamic>{};

    if (title != null) {
      taleCollection['title'] = title;
      taleCollection['searchKey'] = title.toLowerCase();
    }
    if (isDeleted != null) {
      if (isDeleted) {
        taleCollection['isDeleted'] = {
          'deleteDate': DateTime.now(),
          'status': true,
        };
      } else {
        taleCollection['isDeleted'] = {
          'deleteDate': null,
          'status': false,
        };
      }
    }

    await _talesCollection
        .doc(AuthService.userID)
        .collection('allTales')
        .doc(taleID)
        .update(taleCollection);
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

  // Future<void> setTaleDeleteStatus(String taleID) async {
  //   String? uid = AuthService.userID;

  //   await _talesCollection.doc(uid).collection('allTales').doc(taleID).update({
  //     'isDeleted': {
  //       'deleteDate': DateTime.now(),
  //       'status': true,
  //     }
  //   });
  // }

  Future<void> finalDeleteTaleRecord(String taleID) async {
    String? uid = AuthService.userID;

    await _talesCollection.doc(uid).collection('allTales').doc(taleID).delete();
    await StorageService.instance.deleteTale(
      taleID: taleID,
    );
  }

  Future<int> calculateTalesInMS(List<String>? taleIDs) async {
    int sumTimeInMS = 0;

    QuerySnapshot<Map<String, dynamic>> documentSnapshot =
        await _talesCollection
            .doc(AuthService.userID)
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

    return sumTimeInMS;
  }
  //??[End] Tale

  //??[Start] PlayList
  Future<PlaylistModel> createPlaylist({
    required String playlistID,
    required String title,
    required String coverUrl,
    String? description,
    List<TaleModel>? talesModels,
  }) async {
    List<DocumentReference> taleReferences = [];

    talesModels?.forEach((element) {
      taleReferences.add(
        _talesCollection
            .doc(AuthService.userID)
            .collection('allTales')
            .doc(element.ID),
      );
    });

    Map<String, dynamic> collection = {
      'ID': playlistID,
      'title': title,
      'description': description,
      'taleReferences': taleReferences,
      'coverUrl': coverUrl,
      'creation_date': Timestamp.fromDate(
        DateTime.now(),
      ),
    };

    await _playlistsCollection
        .doc(AuthService.userID)
        .collection('allPlaylists')
        .doc(playlistID)
        .set(collection);

    return PlaylistModel.fromJson(collection);
  }

  Future<void> updatePlaylist({
    required String playlistID,
    String? title,
    String? description,
    List<String>? talesIDs,
  }) async {
    DocumentSnapshot documentSnapshot = await _playlistsCollection
        .doc(AuthService.userID)
        .collection('allPlaylists')
        .doc(playlistID)
        .get();

    Map<String, dynamic>? collection =
        documentSnapshot.data() as Map<String, dynamic>?;

    if (title != null) collection?['title'] = title;
    if (description != null) collection?['description'] = description;
    if (talesIDs != null) {
      collection?['taleModelReferences'] = talesIDs;
      collection?['talesDurationInMs'] = await calculateTalesInMS(talesIDs);
    }

    await _playlistsCollection
        .doc(AuthService.userID)
        .collection('allPlaylists')
        .doc(playlistID)
        .update({playlistID: collection});
  }

// //! переделать
//   void addTalesToPlayList({
//     required String playListID,
//     required List<String> talesIDs,
//   }) async {
//     String? uid = AuthService.userID;

//     DocumentSnapshot documentSnapshot =
//         await _playlistsCollection.doc(uid).get();

//     Map<String, dynamic>? collection =
//         documentSnapshot.data() as Map<String, dynamic>?;

//     List<dynamic>? tilesIDSList = collection?[playListID]['tilesIDSList'] ?? [];
//     tilesIDSList?.addAll(talesIDs);

//     collection?[playListID]['taleIDsList'] = tilesIDSList;

//     await _playlistsCollection.doc(uid).update({
//       playListID: collection?[playListID],
//     });
//   }

  Future<void> addTalesToFewPlaylist({
    required List<TaleModel> taleModels,
    required List<PlaylistModel> playlistModels,
  }) async {
    List<DocumentReference> taleReferences = [];

    for (TaleModel element in taleModels) {
      taleReferences.add(
        _talesCollection
            .doc(AuthService.userID)
            .collection('allTales')
            .doc(element.ID),
      );
    }

    for (PlaylistModel playlistModel in playlistModels) {
      await _playlistsCollection
          .doc(AuthService.userID)
          .collection('allPlaylists')
          .doc(playlistModel.ID)
          .update({
        'taleReferences': FieldValue.arrayUnion(
          taleReferences,
        ),
      });
    }
  }

  Future<void> removeTalesFromFewPlayList({
    required List<TaleModel> taleModels,
    required List<PlaylistModel> playlistModels,
  }) async {
    List<DocumentReference> taleReferences = [];

    for (TaleModel element in taleModels) {
      taleReferences.add(
        _talesCollection
            .doc(AuthService.userID)
            .collection('allTales')
            .doc(element.ID),
      );
    }

    for (PlaylistModel playlistModel in playlistModels) {
      await _playlistsCollection
          .doc(AuthService.userID)
          .collection('allPlaylists')
          .doc(playlistModel.ID)
          .update({
        'taleReferences': FieldValue.arrayRemove(
          taleReferences,
        ),
      });
    }
  }

  Future<TaleModel?> getPlayList({
    required String playListID,
  }) async {
    String? uid = AuthService.userID;

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _playlistsCollection
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
    List<PlaylistModel> playlistModels = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _playlistsCollection
            .doc(AuthService.userID)
            .collection('allPlaylists')
            .get();

    for (final doc in querySnapshot.docs) {
      playlistModels.add(
        await PlaylistModel.fromJson(
          doc.data(),
        ),
      );
    }

    return playlistModels;
  }

//! переделать
  Future<void> deletePlayList({
    required String playListID,
  }) async {
    String? uid = AuthService.userID;

    await _playlistsCollection.doc('$uid/$playListID').delete();
  }

  // getTaleModel({String taleID}) {}
  //??[END] PlayList
}
