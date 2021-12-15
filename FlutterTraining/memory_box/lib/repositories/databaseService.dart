import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memory_box/models/userModel.dart';

import 'authService.dart';

class DatabaseService {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DatabaseService._();
  static DatabaseService instance = DatabaseService._();

  final AuthService _authService = AuthService.instance;

  final CollectionReference _userCollection = _firestore.collection('users');

  void recordNewUser(UserModel user) {
    _userCollection.doc(user.uid).set(user.toJson());
  }

  Future<UserModel> userModelFromDatabase(
    String uid,
  ) async {
    DocumentSnapshot<Object?> result = await _userCollection.doc(uid).get();
    return UserModel.fromJson(result.data() as Map<String, dynamic>);
  }

  Future<void> deleteUserCollections(String uid) async {
    _userCollection.doc(uid).delete();
  }

  Future<bool> isUserExist(String uid) async {
    DocumentSnapshot<Object?> document = await _userCollection.doc(uid).get();
    return document.exists;
  }

  Future<void> updateUserCollection({
    required String uid,
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

    _userCollection.doc(uid).update(updatedPair);
  }

  Future<void> addSoundToUserCollection({
    required String uid,
    required String soundTitle,
    required String soundUID,
  }) async {
    Map<String, Map<String, dynamic>> updatedPair = {};
    Map<String, dynamic> pair = {};
    DocumentSnapshot userSnapshot = await _userCollection.doc(uid).get();
    pair = await userSnapshot.get('soundList');

    pair[soundTitle] = soundUID;

    updatedPair['soundList'] = pair;
    _userCollection.doc(uid).update(updatedPair);
  }

  Future<void> updateSongTitle({
    required String oldTitle,
    required String newTitle,
    required String uid,
  }) async {
    Map<String, Map<String, dynamic>> updatedPair = {};
    Map<String, dynamic> pair = {};

    await _userCollection.doc(uid).get().then((value) {
      pair = value.get('soundList');
    });

    pair.forEach((key, value) {
      print('$key - $value');
      // if (key == oldTitle) {
      //   value = newTitle;
      // }
      // soundList[value] = key;
    });

    // pair[soundTitle] = soundUID;

    // updatedPair['soundList'] = pair;

    // _userCollection.doc(uid).update(updatedPair);
  }
}
