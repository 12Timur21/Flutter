import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memory_box/models/userModel.dart';

import 'authService.dart';

class DatabaseService {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DatabaseService._();
  static DatabaseService instance = DatabaseService._();

  final AuthService _authService = AuthService.instance;

  final CollectionReference _users = _firestore.collection('users');

  void recordNewUser(UserModel user) {
    _users.doc(user.uid).set(user.toJson());
  }

  Future<UserModel> userModelFromDatabase(
    String uid,
  ) async {
    print('object');
    print(uid);
    DocumentSnapshot<Object?> result = await _users.doc(uid).get();
    UserModel user = UserModel.fromJson(result.data() as Map<String, dynamic>);
    return user;
  }

  Future<void> deleteUserCollections(String uid) async {
    _users.doc(uid).delete();
  }

  Future<bool> isUserExist(String uid) async {
    DocumentSnapshot<Object?> document = await _users.doc(uid).get();
    return document.exists;
  }

  Future<void> updateUserCollection({
    required String uid,
    required String phoneNumber,
    required String displayName,
  }) async {
    _users.doc(uid).update({
      'displayName': displayName,
      'phoneNumber': phoneNumber,
    });
  }
}
